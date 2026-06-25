/// Esquema de tópicos do MOM (broker MQTT).
///
/// Cada cliente tem uma "fila" representada pelo subárvore de tópicos
/// `mom/inbox/<nome>/#`. Cada mensagem offline é publicada como uma mensagem
/// **retida** em `mom/inbox/<nome>/<id>`. Como o broker guarda as mensagens
/// retidas, elas funcionam como uma fila durável por cliente: quando o
/// destinatário fica online o servidor assina o curinga e o broker reentrega
/// tudo o que estava acumulado.
class Topics {
  static const String root = 'mom/inbox';

  /// Tópico de um item específico da fila de [name].
  static String inbox(String name, String id) => '$root/$name/$id';

  /// Curinga que casa com todos os itens da fila de [name].
  static String inboxWildcard(String name) => '$root/$name/+';

  /// Extrai o nome do destinatário de um tópico `mom/inbox/<nome>/<id>`.
  /// Retorna `null` se o tópico não pertencer ao esquema de filas.
  static String? recipientOf(String topic) {
    final parts = topic.split('/');
    if (parts.length == 4 && parts[0] == 'mom' && parts[1] == 'inbox') {
      return parts[2];
    }
    return null;
  }

  /// Extrai o id do item de um tópico `mom/inbox/<nome>/<id>`.
  static String? idOf(String topic) {
    final parts = topic.split('/');
    if (parts.length == 4 && parts[0] == 'mom' && parts[1] == 'inbox') {
      return parts[3];
    }
    return null;
  }
}
