/// Um contato na lista de amigos do cliente (req 1 e 8).
///
/// [online] reflete a presença informada pelo servidor via `WatchPresence`.
class Contact {
  Contact(this.name, {this.online = false});

  final String name;
  bool online;
}
