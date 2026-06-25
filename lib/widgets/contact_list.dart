import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/chat_controller.dart';

/// Lista de contatos — sempre visível (req 1). Permite adicionar e remover
/// contatos (req 8) e mostra a presença on/off de cada um.
class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ChatController>();
    final contatos = controller.contacts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
          child: Row(
            children: [
              const Text('Contatos',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              IconButton(
                tooltip: 'Adicionar contato',
                icon: const Icon(Icons.person_add),
                onPressed: () => _dialogAdicionar(context),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: contatos.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Nenhum contato.\nUse + para adicionar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54)),
                  ),
                )
              : ListView.builder(
                  itemCount: contatos.length,
                  itemBuilder: (context, i) {
                    final c = contatos[i];
                    final selecionado = c.name == controller.selected;
                    return ListTile(
                      selected: selecionado,
                      leading: Icon(
                        c.online ? Icons.circle : Icons.circle_outlined,
                        color: c.online ? Colors.green : Colors.grey,
                        size: 14,
                      ),
                      title: Text(c.name),
                      subtitle: Text(c.online ? 'online' : 'offline',
                          style: const TextStyle(fontSize: 12)),
                      trailing: IconButton(
                        tooltip: 'Remover',
                        icon: const Icon(Icons.delete_outline, size: 20),
                        onPressed: () =>
                            context.read<ChatController>().removeContact(c.name),
                      ),
                      onTap: () =>
                          context.read<ChatController>().selectContact(c.name),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future<void> _dialogAdicionar(BuildContext context) async {
    final ctrl = TextEditingController();
    final nome = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Adicionar contato'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nome do contato',
            hintText: 'ex.: bruno',
          ),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text),
              child: const Text('Adicionar')),
        ],
      ),
    );
    if (nome != null && nome.trim().isNotEmpty && context.mounted) {
      context.read<ChatController>().addContact(nome);
    }
  }
}
