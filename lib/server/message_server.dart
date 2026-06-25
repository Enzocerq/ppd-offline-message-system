import 'dart:async';

import 'package:grpc/grpc.dart';

import '../core/mqtt_service.dart';
import '../core/topics.dart';
import '../models/chat_message.dart';
import '../proto/messaging.pbgrpc.dart';

/// Implementação do servidor de mensagens (lado RPC do gRPC).
///
/// É o "servidor remoto" que os clientes acessam (req 4). Internamente usa o
/// MOM (broker MQTT, via [MqttService]) para manter **uma fila por cliente**
/// (req 5): cada mensagem destinada a um cliente offline vira uma mensagem
/// retida em `mom/inbox/<destinatário>/<id>` (req 6). Quando o cliente fica
/// online, o servidor assina a fila dele, reentrega o acumulado e apaga os
/// itens (drain).
class MessageServer extends MessageServiceBase {
  MessageServer(this._mqtt, {this.onLog}) {
    // Único ponto de escuta do MOM: roteia cada item de fila reentregue para o
    // stream do destinatário (que precisa estar online para receber).
    _mqtt.mensagens.listen(_aoReceberDoMom);
  }

  final MqttService _mqtt;
  final void Function(String linha)? onLog;

  /// Clientes que pediram criação de fila (req 7).
  final Set<String> _registrados = {};

  /// Clientes online: nome -> sink do stream `Subscribe`.
  final Map<String, StreamController<Incoming>> _online = {};

  /// Assinantes de presença (GUI).
  final List<StreamController<PresenceEvent>> _watchers = [];

  /// Recibos de entrega que ainda não foram entregues ao remetente porque ele
  /// estava offline na hora. Chave = nome do remetente. São esvaziados quando
  /// o remetente volta a ficar online.
  final Map<String, List<DeliveryReceipt>> _recibosPendentes = {};

  /// Gera ids únicos e monotônicos para os itens de fila, mesmo entre
  /// reinícios do servidor (semeado com o relógio para não colidir com filas
  /// já persistidas no broker).
  int _proximoId = DateTime.now().millisecondsSinceEpoch;

  void _log(String linha) => onLog?.call(linha);

  // ------------------------------------------------------------------ RPCs

  /// Req 7: cliente solicita a criação da sua fila ao entrar no sistema.
  @override
  Future<RegisterReply> register(ServiceCall call, RegisterRequest request) async {
    final nome = request.name.trim();
    if (nome.isEmpty) {
      return RegisterReply(ok: false, detail: 'Nome vazio.');
    }
    _registrados.add(nome);
    _log('Fila criada para "$nome" (req 7).');
    return RegisterReply(ok: true, detail: 'Fila pronta para $nome.');
  }

  /// Req 3 e 6: roteia uma mensagem. Online -> entrega instantânea; offline ->
  /// vai para a fila MOM do destinatário.
  @override
  Future<SendReply> sendMessage(ServiceCall call, ChatMessage request) async {
    final destino = request.to;
    final sink = _online[destino];

    if (sink != null) {
      // Destinatário online: entrega instantânea pelo stream gRPC (req 3).
      sink.add(Incoming(message: request, fromQueue: false));
      _log('Entregue ao vivo: ${request.from} -> $destino.');
      return SendReply(ok: true, queued: false);
    }

    // Destinatário offline: deixa na fila do MOM (req 6).
    final id = '${_proximoId++}';
    _mqtt.publish(
      Topics.inbox(destino, id),
      ChatCodec.encode(request),
      retain: true,
    );
    _log('Enfileirado no MOM: ${request.from} -> $destino (offline).');
    return SendReply(ok: true, queued: true, queuedId: id);
  }

  /// Req 3: o cliente abre este stream ao ficar online. O servidor marca
  /// presença, assina a fila do cliente (o broker reentrega o acumulado) e
  /// mantém o stream aberto para as mensagens ao vivo.
  @override
  Stream<Incoming> subscribe(ServiceCall call, SubscribeRequest request) {
    final nome = request.name.trim();
    final controller = StreamController<Incoming>();

    // Substitui um stream anterior do mesmo nome, se houver.
    _online[nome]?.close();
    _online[nome] = controller;
    _registrados.add(nome);
    _log('"$nome" ficou ONLINE.');
    _broadcastPresenca(nome, true);

    // Assinar o curinga dispara a reentrega das mensagens retidas (a fila).
    _mqtt.subscribe(Topics.inboxWildcard(nome));

    // Entrega os recibos que chegaram enquanto este cliente estava offline.
    final pendentes = _recibosPendentes.remove(nome);
    if (pendentes != null) {
      for (final recibo in pendentes) {
        controller.add(Incoming(receipt: recibo));
      }
    }

    controller.onCancel = () {
      _mqtt.unsubscribe(Topics.inboxWildcard(nome));
      if (identical(_online[nome], controller)) {
        _online.remove(nome);
        _log('"$nome" ficou OFFLINE.');
        _broadcastPresenca(nome, false);
      }
    };

    return controller.stream;
  }

  /// GUI: stream com o status on/off dos clientes.
  @override
  Stream<PresenceEvent> watchPresence(ServiceCall call, SubscribeRequest request) {
    final controller = StreamController<PresenceEvent>();
    _watchers.add(controller);

    // Snapshot inicial: quem está online agora.
    for (final nome in _online.keys) {
      controller.add(PresenceEvent(name: nome, online: true));
    }

    controller.onCancel = () => _watchers.remove(controller);
    return controller.stream;
  }

  // -------------------------------------------------------------- internos

  /// Item de fila reentregue pelo broker (mensagem retida em mom/inbox/...).
  void _aoReceberDoMom(MqttMensagem msg) {
    if (msg.payload.isEmpty) return; // confirmação de remoção da retida
    final destino = Topics.recipientOf(msg.topico);
    if (destino == null) return;

    final sink = _online[destino];
    if (sink == null) return; // só entrega se o destinatário estiver online

    final chat = ChatCodec.decode(msg.payload);
    sink.add(Incoming(message: chat, fromQueue: true));

    // Item entregue: remove da fila apagando a mensagem retida.
    _mqtt.deleteRetained(msg.topico);
    _log('Fila esvaziada: ${chat.from} -> $destino (estava offline).');

    // Avisa o remetente que a mensagem enfileirada foi entregue (recibo).
    final id = Topics.idOf(msg.topico);
    if (id != null) _notificarEntrega(chat.from, id, destino);
  }

  /// Entrega um recibo ao remetente; se ele estiver offline, guarda para depois.
  void _notificarEntrega(String remetente, String queuedId, String destino) {
    final recibo = DeliveryReceipt(queuedId: queuedId, to: destino);
    final sink = _online[remetente];
    if (sink != null) {
      sink.add(Incoming(receipt: recibo));
    } else {
      (_recibosPendentes[remetente] ??= []).add(recibo);
    }
  }

  void _broadcastPresenca(String nome, bool online) {
    final evento = PresenceEvent(name: nome, online: online);
    for (final w in _watchers) {
      w.add(evento);
    }
  }
}
