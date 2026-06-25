import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart' as grpc;

import '../core/mqtt_service.dart';
import '../server/message_server.dart';

/// Estado do **papel Servidor**: liga o servidor gRPC (RPC) e a conexão com o
/// broker (MOM), e mantém um log para a UI mostrar o que está acontecendo.
class ServerController extends ChangeNotifier {
  ServerController(this.mqtt);

  final MqttService mqtt;

  grpc.Server? _grpcServer;
  int _grpcPort = 50051;
  int get grpcPort => _grpcPort;

  bool _rpcAtivo = false;
  bool get rpcAtivo => _rpcAtivo;

  String? _erro;
  String? get erro => _erro;

  final List<String> _log = [];
  List<String> get log => List.unmodifiable(_log);

  /// Sobe o broker (conexão MQTT) e o servidor gRPC.
  Future<void> start({
    required String brokerHost,
    required int brokerPort,
    required int grpcPort,
  }) async {
    _grpcPort = grpcPort;
    _erro = null;

    _adicionarLog('Conectando ao broker MQTT (MOM) em $brokerHost:$brokerPort…');
    await mqtt.connect(
      host: brokerHost,
      port: brokerPort,
      clientId: 'servidor-mensagens',
    );
    if (!mqtt.conectado) {
      _erro = 'Não foi possível conectar ao broker: ${mqtt.ultimoErro}';
      _adicionarLog(_erro!);
      return;
    }
    _adicionarLog('Broker conectado.');

    final service = MessageServer(mqtt, onLog: _adicionarLog);
    final server = grpc.Server.create(services: [service]);
    try {
      await server.serve(port: grpcPort);
    } catch (e) {
      _erro = 'Falha ao iniciar o servidor gRPC: $e';
      _adicionarLog(_erro!);
      return;
    }
    _grpcServer = server;
    _rpcAtivo = true;
    _adicionarLog('Servidor gRPC ouvindo em :$grpcPort. Pronto.');
    notifyListeners();
  }

  void _adicionarLog(String linha) {
    final hora = DateTime.now();
    final hh = hora.hour.toString().padLeft(2, '0');
    final mm = hora.minute.toString().padLeft(2, '0');
    final ss = hora.second.toString().padLeft(2, '0');
    _log.insert(0, '[$hh:$mm:$ss] $linha');
    if (_log.length > 300) _log.removeLast();
    notifyListeners();
  }

  @override
  void dispose() {
    _grpcServer?.shutdown();
    mqtt.dispose();
    super.dispose();
  }
}
