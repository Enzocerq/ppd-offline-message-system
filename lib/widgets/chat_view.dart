import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/chat_controller.dart';

/// Painel da conversa com o contato selecionado: histórico + caixa de envio.
class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _enviar(BuildContext context, String para) {
    final texto = _input.text.trim();
    if (texto.isEmpty) return;
    context.read<ChatController>().sendMessage(para, texto);
    _input.clear();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ChatController>();
    final contato = controller.selected;

    if (contato == null) {
      return const Center(
        child: Text('Selecione um contato para conversar.',
            style: TextStyle(color: Colors.black54)),
      );
    }

    final mensagens = controller.conversationWith(contato);

    return Column(
      children: [
        Material(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.person),
                const SizedBox(width: 8),
                Text(contato,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
        ),
        Expanded(
          child: mensagens.isEmpty
              ? const Center(
                  child: Text('Sem mensagens ainda.',
                      style: TextStyle(color: Colors.black54)))
              : ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(12),
                  itemCount: mensagens.length,
                  itemBuilder: (context, i) {
                    final m = mensagens[mensagens.length - 1 - i];
                    return _Bolha(entry: m);
                  },
                ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _input,
                  decoration: const InputDecoration(
                    hintText: 'Digite uma mensagem…',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onSubmitted: (_) => _enviar(context, contato),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () => _enviar(context, contato),
                child: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Bolha extends StatelessWidget {
  const _Bolha({required this.entry});

  final ChatEntry entry;

  @override
  Widget build(BuildContext context) {
    final mine = entry.mine;
    final cor = mine
        ? Theme.of(context).colorScheme.primaryContainer
        : Colors.grey.shade200;

    // Define a legenda/ícone de status da bolha.
    String? legenda;
    IconData? icone;
    if (mine) {
      if (entry.delivered) {
        legenda = 'entregue';
        icone = Icons.done_all;
      } else if (entry.queuedId != null) {
        legenda = 'na fila (offline)';
        icone = Icons.schedule;
      }
    } else if (entry.fromQueue) {
      legenda = 'recebida da fila';
      icone = Icons.schedule;
    }

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: cor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment:
              mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(entry.text),
            if (legenda != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icone,
                      size: 12,
                      color: entry.delivered ? Colors.blue : Colors.black54,
                    ),
                    const SizedBox(width: 4),
                    Text(legenda,
                        style: TextStyle(
                            fontSize: 11,
                            color: entry.delivered
                                ? Colors.blue
                                : Colors.black54)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
