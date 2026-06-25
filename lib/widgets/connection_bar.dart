import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/mqtt_service.dart';

/// Barra de status da conexão do servidor com o broker MQTT (MOM).
class ConnectionBar extends StatelessWidget {
  const ConnectionBar({super.key});

  @override
  Widget build(BuildContext context) {
    final servico = context.watch<MqttService>();

    final (cor, rotulo, icone) = switch (servico.status) {
      StatusConexao.conectado => (Colors.green, 'Broker conectado', Icons.cloud_done),
      StatusConexao.conectando => (Colors.orange, 'Conectando…', Icons.cloud_sync),
      StatusConexao.erro => (Colors.red, 'Erro de conexão', Icons.cloud_off),
      StatusConexao.desconectado => (Colors.grey, 'Desconectado', Icons.cloud_off),
    };

    return Material(
      color: cor.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(icone, color: cor, size: 20),
            const SizedBox(width: 8),
            Text(rotulo, style: TextStyle(color: cor, fontWeight: FontWeight.w600)),
            const SizedBox(width: 12),
            Text('${servico.host}:${servico.port}',
                style: const TextStyle(color: Colors.black54)),
            if (servico.status == StatusConexao.erro &&
                servico.ultimoErro != null) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Text(servico.ultimoErro!,
                    style: const TextStyle(color: Colors.red),
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
