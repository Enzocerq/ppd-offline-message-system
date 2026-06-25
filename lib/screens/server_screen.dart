import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/mqtt_service.dart';
import '../state/server_controller.dart';
import '../widgets/connection_bar.dart';

/// Papel Servidor: inicia o servidor gRPC + a conexão com o MOM e mostra um log
/// ao vivo (filas criadas, entregas instantâneas, enfileiramentos, drains).
class ServerScreen extends StatefulWidget {
  const ServerScreen({
    super.key,
    required this.brokerHost,
    required this.brokerPort,
    required this.grpcPort,
  });

  final String brokerHost;
  final int brokerPort;
  final int grpcPort;

  @override
  State<ServerScreen> createState() => _ServerScreenState();
}

class _ServerScreenState extends State<ServerScreen> {
  late final MqttService _mqtt;
  late final ServerController _controller;

  @override
  void initState() {
    super.initState();
    _mqtt = MqttService();
    _controller = ServerController(_mqtt);
    _controller.start(
      brokerHost: widget.brokerHost,
      brokerPort: widget.brokerPort,
      grpcPort: widget.grpcPort,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _mqtt),
        ChangeNotifierProvider.value(value: _controller),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Servidor de Mensagens')),
        body: Column(
          children: [
            const ConnectionBar(),
            Consumer<ServerController>(
              builder: (context, c, _) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(c.rpcAtivo ? Icons.podcasts : Icons.hourglass_empty,
                        color: c.rpcAtivo ? Colors.green : Colors.orange,
                        size: 20),
                    const SizedBox(width: 8),
                    Text(
                      c.rpcAtivo
                          ? 'gRPC ouvindo em :${c.grpcPort}'
                          : 'Iniciando…',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Consumer<ServerController>(
                builder: (context, c, _) {
                  if (c.log.isEmpty) {
                    return const Center(child: Text('Sem eventos ainda.'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: c.log.length,
                    itemBuilder: (context, i) => Text(
                      c.log[i],
                      style: const TextStyle(
                          fontFamily: 'monospace', fontSize: 13),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
