import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'server_screen.dart';

/// Tela inicial: escolhe o papel desta instância do app (igual ao
/// mom-project-ppd). Rode o mesmo executável várias vezes — uma como
/// **Servidor** e as demais como **Cliente**.
class RoleSelectorScreen extends StatefulWidget {
  const RoleSelectorScreen({super.key});

  @override
  State<RoleSelectorScreen> createState() => _RoleSelectorScreenState();
}

class _RoleSelectorScreenState extends State<RoleSelectorScreen> {
  // Servidor
  final _brokerHost = TextEditingController(text: 'localhost');
  final _brokerPort = TextEditingController(text: '1883');
  final _grpcPortSrv = TextEditingController(text: '50051');

  // Cliente
  final _serverHost = TextEditingController(text: 'localhost');
  final _grpcPortCli = TextEditingController(text: '50051');

  @override
  void dispose() {
    _brokerHost.dispose();
    _brokerPort.dispose();
    _grpcPortSrv.dispose();
    _serverHost.dispose();
    _grpcPortCli.dispose();
    super.dispose();
  }

  void _abrirServidor() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ServerScreen(
          brokerHost: _brokerHost.text.trim(),
          brokerPort: int.tryParse(_brokerPort.text.trim()) ?? 1883,
          grpcPort: int.tryParse(_grpcPortSrv.text.trim()) ?? 50051,
        ),
      ),
    );
  }

  void _abrirCliente() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(
          serverHost: _serverHost.text.trim(),
          grpcPort: int.tryParse(_grpcPortCli.text.trim()) ?? 50051,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mensageria Offline — PPD')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _cardServidor()),
                const SizedBox(width: 16),
                Expanded(child: _cardCliente()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardServidor() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(children: [
              Icon(Icons.dns),
              SizedBox(width: 8),
              Text('Servidor de Mensagens',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 4),
            const Text('Sobe o servidor gRPC (RPC) e conecta ao broker MQTT (MOM).',
                style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 16),
            TextField(
              controller: _brokerHost,
              decoration: const InputDecoration(
                  labelText: 'Host do broker (MQTT)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _brokerPort,
              decoration: const InputDecoration(
                  labelText: 'Porta do broker', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _grpcPortSrv,
              decoration: const InputDecoration(
                  labelText: 'Porta gRPC (escuta)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _abrirServidor,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Iniciar servidor'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardCliente() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(children: [
              Icon(Icons.chat),
              SizedBox(width: 8),
              Text('Cliente',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 4),
            const Text('Conversa com o servidor por gRPC. Abra várias instâncias.',
                style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 16),
            TextField(
              controller: _serverHost,
              decoration: const InputDecoration(
                  labelText: 'Host do servidor', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _grpcPortCli,
              decoration: const InputDecoration(
                  labelText: 'Porta gRPC do servidor', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _abrirCliente,
              icon: const Icon(Icons.login),
              label: const Text('Entrar como cliente'),
            ),
          ],
        ),
      ),
    );
  }
}
