// Teste de fumaça ponta-a-ponta do fluxo offline -> fila -> drain.
//
// Pré-requisitos: o broker MQTT e uma instância do app no papel **Servidor**
// devem estar rodando (gRPC em localhost:50051). Rode com:
//
//   dart run tool/smoke_test.dart
//
// Ele NÃO usa Flutter — só o stub gRPC gerado.

// ignore_for_file: avoid_print

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:ppd_offline_message_system/proto/messaging.pbgrpc.dart';

const host = 'localhost';
const port = 50051;

ChatMessage _msg(String from, String to, String text) => ChatMessage(
      from: from,
      to: to,
      text: text,
      timestamp: Int64(DateTime.now().millisecondsSinceEpoch),
    );

Future<void> main() async {
  final canalAna = ClientChannel(host,
      port: port,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()));
  final canalBruno = ClientChannel(host,
      port: port,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()));
  final ana = MessageServiceClient(canalAna);
  final bruno = MessageServiceClient(canalBruno);

  var falhas = 0;
  void check(bool ok, String descricao) {
    print('${ok ? "PASS" : "FALHOU"}: $descricao');
    if (!ok) falhas++;
  }

  try {
    // Req 7: ambos pedem a criação da fila.
    final regA = await ana.register(RegisterRequest(name: 'ana'));
    final regB = await bruno.register(RegisterRequest(name: 'bruno'));
    check(regA.ok && regB.ok, 'registro das filas (req 7)');

    // Req 6: bruno OFFLINE (sem Subscribe). ana envia -> deve enfileirar.
    final r1 = await ana.sendMessage(_msg('ana', 'bruno', 'mensagem offline'));
    check(r1.queued, 'mensagem para contato offline foi enfileirada (req 6)');

    // Req 3/4: bruno fica ONLINE -> deve receber o que estava na fila (drain).
    final recebidas = <IncomingMessage>[];
    final sub = bruno.receiveMessages(SubscribeRequest(name: 'bruno')).listen(
      recebidas.add,
      onError: (_) {},
    );

    await Future<void>.delayed(const Duration(milliseconds: 800));
    final replay = recebidas.where((i) => i.fromQueue).toList();
    check(
      replay.any((i) => i.message.text == 'mensagem offline'),
      'fila esvaziada ao ficar online (req 4) — recebeu replay',
    );

    // Req 3: bruno ONLINE -> entrega instantânea (não enfileira).
    recebidas.clear();
    final r2 = await ana.sendMessage(_msg('ana', 'bruno', 'mensagem ao vivo'));
    check(!r2.queued, 'mensagem para contato online NÃO foi enfileirada (req 3)');

    await Future<void>.delayed(const Duration(milliseconds: 500));
    check(
      recebidas.any((i) => !i.fromQueue && i.message.text == 'mensagem ao vivo'),
      'entrega instantânea ao contato online (req 3)',
    );

    await sub.cancel();
  } catch (e) {
    print('ERRO: $e');
    falhas++;
  } finally {
    await canalAna.shutdown();
    await canalBruno.shutdown();
  }

  print('\n${falhas == 0 ? "TODOS OS TESTES PASSARAM" : "$falhas teste(s) falharam"}');
}
