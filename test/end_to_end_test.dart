// Teste ponta-a-ponta EM PROCESSO: sobe o MessageServer real (gRPC) ligado a um
// MqttService real e exercita o fluxo completo offline -> fila -> drain -> live.
//
// Requer o broker MQTT rodando em localhost:1883. Se o broker não estiver no
// ar, o teste é PULADO (para não quebrar `flutter test` sem o broker).
//
//   flutter test test/end_to_end_test.dart

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart' as grpc;
import 'package:ppd_offline_message_system/core/mqtt_service.dart';
import 'package:ppd_offline_message_system/proto/messaging.pbgrpc.dart';
import 'package:ppd_offline_message_system/server/message_server.dart';

ChatMessage _msg(String from, String to, String text) => ChatMessage(
      from: from,
      to: to,
      text: text,
      timestamp: Int64(DateTime.now().millisecondsSinceEpoch),
    );

void main() {
  test('offline -> fila MOM -> drain ao ficar online -> entrega ao vivo',
      () async {
    final mqtt = MqttService();
    await mqtt.connect(host: 'localhost', port: 1883, clientId: 'srv-e2e');
    if (!mqtt.conectado) {
      markTestSkipped('Broker MQTT não está rodando em localhost:1883.');
      return;
    }

    final server = grpc.Server.create(services: [MessageServer(mqtt)]);
    await server.serve(port: 0);
    final porta = server.port!;

    final canalA = grpc.ClientChannel('localhost',
        port: porta,
        options: const grpc.ChannelOptions(
            credentials: grpc.ChannelCredentials.insecure()));
    final canalB = grpc.ClientChannel('localhost',
        port: porta,
        options: const grpc.ChannelOptions(
            credentials: grpc.ChannelCredentials.insecure()));
    final ana = MessageServiceClient(canalA);
    final bruno = MessageServiceClient(canalB);

    // Usa um nome único por execução para não pegar mensagens retidas antigas.
    final anaNome = 'ana-${DateTime.now().millisecondsSinceEpoch}';
    final brunoNome = 'bruno-${DateTime.now().millisecondsSinceEpoch}';

    // Req 7
    expect((await ana.register(RegisterRequest(name: anaNome))).ok, isTrue);
    expect((await bruno.register(RegisterRequest(name: brunoNome))).ok, isTrue);

    // ana fica online para poder receber o recibo de entrega.
    final anaRecebidas = <Incoming>[];
    final subAna =
        ana.subscribe(SubscribeRequest(name: anaNome)).listen(anaRecebidas.add);
    await Future<void>.delayed(const Duration(milliseconds: 200));

    // Req 6: bruno offline -> mensagem é enfileirada.
    final r1 = await ana.sendMessage(_msg(anaNome, brunoNome, 'offline-1'));
    expect(r1.queued, isTrue, reason: 'destinatário offline deve enfileirar');
    expect(r1.queuedId, isNotEmpty, reason: 'deve retornar o id da fila');

    // Req 3/4: bruno fica online -> recebe o que estava na fila (drain).
    final recebidas = <Incoming>[];
    final sub =
        bruno.subscribe(SubscribeRequest(name: brunoNome)).listen(recebidas.add);
    await Future<void>.delayed(const Duration(milliseconds: 800));

    expect(
      recebidas.any((i) =>
          i.hasMessage() && i.fromQueue && i.message.text == 'offline-1'),
      isTrue,
      reason: 'mensagem da fila deve ser reentregue ao ficar online',
    );

    // Recibo: ana deve ser avisada de que a mensagem enfileirada foi entregue.
    expect(
      anaRecebidas.any((i) =>
          i.hasReceipt() &&
          i.receipt.queuedId == r1.queuedId &&
          i.receipt.to == brunoNome),
      isTrue,
      reason: 'remetente deve receber o recibo de entrega',
    );

    // Req 3: bruno online -> entrega instantânea, sem enfileirar.
    recebidas.clear();
    final r2 = await ana.sendMessage(_msg(anaNome, brunoNome, 'live-1'));
    expect(r2.queued, isFalse, reason: 'destinatário online não enfileira');
    await Future<void>.delayed(const Duration(milliseconds: 400));
    expect(
      recebidas.any((i) =>
          i.hasMessage() && !i.fromQueue && i.message.text == 'live-1'),
      isTrue,
      reason: 'entrega instantânea ao contato online',
    );

    await subAna.cancel();
    await sub.cancel();
    await canalA.shutdown();
    await canalB.shutdown();
    await server.shutdown();
    await mqtt.disconnect();
  }, timeout: const Timeout(Duration(seconds: 30)));
}
