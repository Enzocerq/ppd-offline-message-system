import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/chat_controller.dart';

/// Chave on/off do cliente (req 2). Ligar abre o stream de entrada (e dispara o
/// recebimento das mensagens que ficaram na fila); desligar fecha o stream.
class StatusToggle extends StatelessWidget {
  const StatusToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ChatController>();
    final online = controller.online;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            online ? Icons.circle : Icons.circle_outlined,
            color: online ? Colors.green : Colors.grey,
            size: 14,
          ),
          const SizedBox(width: 8),
          Text(
            online ? 'Online' : 'Offline',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: online ? Colors.green.shade700 : Colors.grey.shade700,
            ),
          ),
          const Spacer(),
          Switch(
            value: online,
            onChanged: (v) => context.read<ChatController>().setOnline(v),
          ),
        ],
      ),
    );
  }
}
