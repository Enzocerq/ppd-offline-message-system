import 'dart:convert';

import 'package:fixnum/fixnum.dart';

import '../proto/messaging.pbgrpc.dart';

/// Helpers de (de)serialização da [ChatMessage] do protobuf para JSON.
///
/// O JSON é o payload usado nas filas do MOM. Texto legível foi escolhido de
/// propósito: dá para inspecionar a fila no broker com
/// `mosquitto_sub -t 'mom/inbox/#' -v` durante a demonstração.
class ChatCodec {
  static String encode(ChatMessage m) => jsonEncode({
        'from': m.from,
        'to': m.to,
        'text': m.text,
        'ts': m.timestamp.toInt(),
      });

  static ChatMessage decode(String payload) {
    final json = jsonDecode(payload) as Map<String, dynamic>;
    return ChatMessage(
      from: json['from'] as String,
      to: json['to'] as String,
      text: json['text'] as String,
      timestamp: Int64(json['ts'] as int),
    );
  }

  /// Constrói uma [ChatMessage] já com o timestamp atual (epoch em ms).
  static ChatMessage build({
    required String from,
    required String to,
    required String text,
    required int epochMs,
  }) {
    return ChatMessage(
      from: from,
      to: to,
      text: text,
      timestamp: Int64(epochMs),
    );
  }
}
