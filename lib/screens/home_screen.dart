import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../rpc/chat_client.dart';
import '../state/chat_controller.dart';
import '../widgets/chat_view.dart';
import '../widgets/contact_list.dart';
import '../widgets/status_toggle.dart';

/// Tela principal do cliente: lista de contatos sempre à vista (esquerda) e a
/// conversa selecionada (direita), com a chave on/off no topo.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.client, required this.name});

  final ChatClient client;
  final String name;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ChatController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ChatController(client: widget.client, name: widget.name);
    _controller.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mensageria — ${widget.name}'),
        ),
        body: Consumer<ChatController>(
          builder: (context, c, _) {
            return Column(
              children: [
                if (c.erro != null)
                  Container(
                    width: double.infinity,
                    color: Colors.red.shade50,
                    padding: const EdgeInsets.all(8),
                    child: Text(c.erro!,
                        style: TextStyle(color: Colors.red.shade800)),
                  ),
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 300,
                        child: Column(
                          children: const [
                            StatusToggle(),
                            Divider(height: 1),
                            Expanded(child: ContactList()),
                          ],
                        ),
                      ),
                      const VerticalDivider(width: 1),
                      const Expanded(child: ChatView()),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
