import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

/// Uma mensagem recebida do broker: tópico + payload (texto).
typedef MqttMensagem = ({String topico, String payload});

/// Situação da conexão com o broker, exposta para a UI.
enum StatusConexao { desconectado, conectando, conectado, erro }

/// Encapsula o cliente MQTT ([MqttServerClient]) com uma API enxuta:
/// conectar, publicar (com `retain`), assinar/desassinar e um stream de
/// mensagens recebidas.
///
/// Quem usa esta classe é o **papel Servidor** — só o servidor de mensagens
/// fala com o MOM. É um [ChangeNotifier] para a barra de conexão reagir a
/// mudanças de status.
class MqttService extends ChangeNotifier {
  MqttService();

  MqttServerClient? _client;

  StatusConexao _status = StatusConexao.desconectado;
  StatusConexao get status => _status;

  String? _ultimoErro;
  String? get ultimoErro => _ultimoErro;

  String _host = 'localhost';
  int _port = 1883;
  String get host => _host;
  int get port => _port;

  /// Stream broadcast com todas as mensagens recebidas dos tópicos assinados.
  final StreamController<MqttMensagem> _mensagens =
      StreamController<MqttMensagem>.broadcast();
  Stream<MqttMensagem> get mensagens => _mensagens.stream;

  bool get conectado => _status == StatusConexao.conectado;

  /// Conecta ao broker. [clientId] deve ser único por instância do app.
  Future<void> connect({
    required String host,
    required int port,
    required String clientId,
  }) async {
    if (_status == StatusConexao.conectando) return;
    _host = host;
    _port = port;
    await disconnect();

    final client = MqttServerClient.withPort(host, clientId, port)
      ..logging(on: false)
      ..keepAlivePeriod = 20
      ..autoReconnect = true
      ..onConnected = _onConnected
      ..onDisconnected = _onDisconnected
      ..connectionMessage = (MqttConnectMessage()
        ..withClientIdentifier(clientId)
        ..startClean());
    _client = client;

    _definirStatus(StatusConexao.conectando);
    try {
      await client.connect();
    } catch (e) {
      _ultimoErro = e.toString();
      _definirStatus(StatusConexao.erro);
      client.disconnect();
      _client = null;
      return;
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      _ultimoErro = null;
      _definirStatus(StatusConexao.conectado);
      _ouvirAtualizacoes(client);
    } else {
      _ultimoErro = 'Falha na conexão (${client.connectionStatus?.state}).';
      _definirStatus(StatusConexao.erro);
      _client = null;
    }
  }

  void _ouvirAtualizacoes(MqttServerClient client) {
    client.updates?.listen((eventos) {
      for (final evento in eventos) {
        final mensagem = evento.payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(
          mensagem.payload.message,
        );
        _mensagens.add((topico: evento.topic, payload: payload));
      }
    });
  }

  /// Publica [payload] em [topico]. Use [retain] para mensagens de fila.
  void publish(
    String topico,
    String payload, {
    bool retain = false,
    MqttQos qos = MqttQos.atLeastOnce,
  }) {
    final client = _client;
    if (client == null || !conectado) return;
    final builder = MqttClientPayloadBuilder()..addUTF8String(payload);
    client.publishMessage(topico, qos, builder.payload!, retain: retain);
  }

  /// Apaga a mensagem retida de [topico] publicando um payload vazio retido.
  /// É como o MQTT remove um item da fila depois de entregue.
  void deleteRetained(String topico) {
    final client = _client;
    if (client == null || !conectado) return;
    final builder = MqttClientPayloadBuilder();
    client.publishMessage(
      topico,
      MqttQos.atLeastOnce,
      builder.payload!,
      retain: true,
    );
  }

  void subscribe(String topico) {
    if (conectado) _client?.subscribe(topico, MqttQos.atLeastOnce);
  }

  void unsubscribe(String topico) {
    if (conectado) _client?.unsubscribe(topico);
  }

  Future<void> disconnect() async {
    final client = _client;
    if (client != null) {
      client.onConnected = null;
      client.onDisconnected = null;
      client.disconnect();
      _client = null;
    }
    if (_status != StatusConexao.erro) {
      _definirStatus(StatusConexao.desconectado);
    }
  }

  void _onConnected() => _definirStatus(StatusConexao.conectado);

  void _onDisconnected() {
    if (_status != StatusConexao.erro) {
      _definirStatus(StatusConexao.desconectado);
    }
  }

  void _definirStatus(StatusConexao status) {
    _status = status;
    notifyListeners();
  }

  @override
  void dispose() {
    disconnect();
    _mensagens.close();
    super.dispose();
  }
}
