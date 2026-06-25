import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/contact.dart';
import '../proto/messaging.pbgrpc.dart';
import '../rpc/chat_client.dart';

/// Uma linha exibida em uma conversa.
class ChatEntry {
  ChatEntry({
    required this.text,
    required this.mine,
    required this.timestamp,
    this.fromQueue = false,
    this.queuedId,
    this.delivered = false,
  });

  final String text;
  final bool mine; // true = enviada por mim
  final int timestamp; // epoch em ms

  /// Mensagem recebida que veio da fila offline (replay).
  final bool fromQueue;

  /// Mensagem minha que foi enfileirada (destinatário estava offline). Guarda o
  /// id da fila para casar com o recibo de entrega. `null` se entregue ao vivo.
  String? queuedId;

  /// Mensagem minha já entregue ao destinatário (ao vivo ou após sair da fila).
  bool delivered;
}

/// Estado do **papel Cliente**. Conversa só por gRPC com o servidor (req 4) e
/// mantém a lista de contatos (req 1/8), o estado on/off (req 2) e o histórico
/// das conversas (em memória).
class ChatController extends ChangeNotifier {
  ChatController({required this.client, required this.name});

  final ChatClient client;
  final String name;

  final List<Contact> _contacts = [];
  List<Contact> get contacts => List.unmodifiable(_contacts);

  final Map<String, List<ChatEntry>> _conversations = {};

  String? _selected;
  String? get selected => _selected;

  bool _online = false;
  bool get online => _online;

  String? _erro;
  String? get erro => _erro;

  StreamSubscription<IncomingMessage>? _inbox;
  StreamSubscription<DeliveryReceipt>? _receipts;
  StreamSubscription<PresenceEvent>? _presence;

  /// Inicializa: registra a fila (req 7), acompanha recibos e presença, e entra
  /// online. Os streams de recibo e presença ficam abertos durante toda a
  /// sessão (independentes do estado on/off).
  Future<void> init() async {
    final reply = await client.register(name);
    if (!reply.ok) {
      _erro = 'Falha no registro: ${reply.detail}';
      notifyListeners();
      return;
    }
    _watchReceipts();
    _watchPresence();
    await setOnline(true);
  }

  List<ChatEntry> conversationWith(String contact) =>
      List.unmodifiable(_conversations[contact] ?? const []);

  // ----------------------------------------------------------- contatos

  /// Req 8: adiciona um contato à lista.
  void addContact(String contactName) {
    final n = contactName.trim();
    if (n.isEmpty || n == name) return;
    if (_contacts.any((c) => c.name == n)) return;
    _contacts.add(Contact(n, online: _onlineNames.contains(n)));
    _selected ??= n;
    notifyListeners();
  }

  /// Req 8: remove um contato da lista.
  void removeContact(String contactName) {
    _contacts.removeWhere((c) => c.name == contactName);
    if (_selected == contactName) {
      _selected = _contacts.isEmpty ? null : _contacts.first.name;
    }
    notifyListeners();
  }

  void selectContact(String contactName) {
    _selected = contactName;
    notifyListeners();
  }

  // ------------------------------------------------------------ recibos

  /// Stream dedicado aos recibos de entrega das minhas mensagens.
  void _watchReceipts() {
    _receipts = client.watchReceipts(name).listen(
      _aoReceberRecibo,
      onError: (_) {},
    );
  }

  // ------------------------------------------------------------ presença

  final Set<String> _onlineNames = {};

  void _watchPresence() {
    _presence = client.watchPresence(name).listen(
      (evento) {
        if (evento.online) {
          _onlineNames.add(evento.name);
        } else {
          _onlineNames.remove(evento.name);
        }
        for (final c in _contacts) {
          if (c.name == evento.name) c.online = evento.online;
        }
        notifyListeners();
      },
      onError: (_) {},
    );
  }

  // --------------------------------------------------------- on/off (req 2)

  Future<void> setOnline(bool value) async {
    if (value == _online) return;
    if (value) {
      _abrirInbox();
    } else {
      await _inbox?.cancel();
      _inbox = null;
    }
    _online = value;
    notifyListeners();
  }

  /// Req 3: abre o stream de mensagens recebidas. O servidor entrega o que
  /// estava na fila offline (replay) e depois as mensagens ao vivo.
  void _abrirInbox() {
    _inbox = client.receiveMessages(name).listen(
      (incoming) => _aoReceberMensagem(incoming.message, incoming.fromQueue),
      onError: (e) {
        _erro = 'Conexão com o servidor perdida: $e';
        _online = false;
        notifyListeners();
      },
      onDone: () {
        _online = false;
        notifyListeners();
      },
    );
  }

  void _aoReceberMensagem(ChatMessage m, bool fromQueue) {
    final remetente = m.from;
    // Garante que o remetente apareça na lista para a conversa ser acessível.
    if (!_contacts.any((c) => c.name == remetente)) {
      _contacts.add(Contact(remetente, online: _onlineNames.contains(remetente)));
    }
    _push(
      remetente,
      ChatEntry(
        text: m.text,
        mine: false,
        timestamp: m.timestamp.toInt(),
        fromQueue: fromQueue,
      ),
    );
    _selected ??= remetente;
    notifyListeners();
  }

  /// Recibo: uma mensagem minha que estava na fila foi entregue. Marca a bolha
  /// correspondente como "entregue".
  void _aoReceberRecibo(DeliveryReceipt recibo) {
    final lista = _conversations[recibo.to];
    if (lista == null) return;
    for (final e in lista) {
      if (e.mine && e.queuedId == recibo.queuedId) {
        e.delivered = true;
        break;
      }
    }
    notifyListeners();
  }

  // -------------------------------------------------------------- enviar

  /// Req 3/6: envia para [to]. Reflete na UI se foi entregue ao vivo ou
  /// enfileirada (destinatário offline).
  Future<void> sendMessage(String to, String text) async {
    final t = text.trim();
    if (t.isEmpty) return;

    final entry = ChatEntry(
      text: t,
      mine: true,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    _push(to, entry);
    notifyListeners();

    try {
      final reply = await client.send(from: name, to: to, text: t);
      if (reply.queued) {
        // Destinatário offline: aguarda o recibo de entrega.
        entry.queuedId = reply.queuedId;
      } else {
        // Entregue instantaneamente.
        entry.delivered = true;
      }
      notifyListeners();
    } catch (e) {
      _erro = 'Falha ao enviar: $e';
      notifyListeners();
    }
  }

  void _push(String contact, ChatEntry entry) {
    (_conversations[contact] ??= []).add(entry);
    _conversations[contact]!.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  @override
  void dispose() {
    _inbox?.cancel();
    _receipts?.cancel();
    _presence?.cancel();
    client.shutdown();
    super.dispose();
  }
}
