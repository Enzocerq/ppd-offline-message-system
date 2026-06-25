import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppd_offline_message_system/core/topics.dart';
import 'package:ppd_offline_message_system/models/chat_message.dart';
import 'package:ppd_offline_message_system/proto/messaging.pbgrpc.dart';

void main() {
  group('ChatCodec', () {
    test('round-trip JSON preserva os campos', () {
      final original = ChatMessage(
        from: 'ana',
        to: 'bruno',
        text: 'olá, acentuação: ção °C',
        timestamp: Int64(1719300000000),
      );

      final decoded = ChatCodec.decode(ChatCodec.encode(original));

      expect(decoded.from, 'ana');
      expect(decoded.to, 'bruno');
      expect(decoded.text, 'olá, acentuação: ção °C');
      expect(decoded.timestamp.toInt(), 1719300000000);
    });

    test('build define o timestamp informado', () {
      final m = ChatCodec.build(from: 'a', to: 'b', text: 'oi', epochMs: 42);
      expect(m.timestamp.toInt(), 42);
    });
  });

  group('Topics', () {
    test('monta os caminhos da fila', () {
      expect(Topics.inbox('ana', '7'), 'mom/inbox/ana/7');
      expect(Topics.inboxWildcard('ana'), 'mom/inbox/ana/+');
    });

    test('extrai o destinatário e o id de um tópico de fila', () {
      expect(Topics.recipientOf('mom/inbox/bruno/1719300000000'), 'bruno');
      expect(Topics.idOf('mom/inbox/bruno/1719300000000'), '1719300000000');
    });

    test('ignora tópicos fora do esquema', () {
      expect(Topics.recipientOf('outro/topico'), isNull);
      expect(Topics.recipientOf('mom/inbox/ana'), isNull);
    });
  });
}
