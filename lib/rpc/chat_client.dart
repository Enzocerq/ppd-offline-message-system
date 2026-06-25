import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';

import '../proto/messaging.pbgrpc.dart';

/// Stub gRPC do cliente. Esconde o [ClientChannel] e o [MessageServiceClient]
/// gerado atrás de uma API enxuta. É o único caminho do cliente até o servidor
/// de mensagens (req 4) — o cliente nunca fala com o MOM.
class ChatClient {
  ChatClient({required this.host, required this.port}) {
    _channel = ClientChannel(
      host,
      port: port,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    _stub = MessageServiceClient(_channel);
  }

  final String host;
  final int port;

  late final ClientChannel _channel;
  late final MessageServiceClient _stub;

  /// Req 7: pede ao servidor para criar a fila deste cliente.
  Future<RegisterReply> register(String name) =>
      _stub.register(RegisterRequest(name: name));

  /// Req 3/6: envia uma mensagem. O reply diz se foi entregue ao vivo ou
  /// enfileirada (destinatário offline).
  Future<SendReply> send({
    required String from,
    required String to,
    required String text,
  }) {
    final msg = ChatMessage(
      from: from,
      to: to,
      text: text,
      timestamp: Int64(DateTime.now().millisecondsSinceEpoch),
    );
    return _stub.sendMessage(msg);
  }

  /// Req 3: stream de entrada. Abrir = ficar online (dispara o drain da fila).
  ResponseStream<Incoming> subscribe(String name) =>
      _stub.subscribe(SubscribeRequest(name: name));

  /// Stream de presença dos demais clientes (GUI).
  ResponseStream<PresenceEvent> watchPresence(String name) =>
      _stub.watchPresence(SubscribeRequest(name: name));

  Future<void> shutdown() => _channel.shutdown();
}
