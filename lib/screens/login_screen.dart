import 'package:flutter/material.dart';

import '../rpc/chat_client.dart';
import 'home_screen.dart';

/// Papel Cliente — passo de login: o usuário informa seu "nome de contato"
/// (req 1) que será usado para registrar a fila no servidor (req 7).
class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.serverHost,
    required this.grpcPort,
  });

  final String serverHost;
  final int grpcPort;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nome = TextEditingController();

  void _entrar() {
    final nome = _nome.text.trim();
    if (nome.isEmpty) return;
    final client = ChatClient(host: widget.serverHost, port: widget.grpcPort);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(client: client, name: nome),
      ),
    );
  }

  @override
  void dispose() {
    _nome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrar')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Seu nome de contato',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Servidor: ${widget.serverHost}:${widget.grpcPort}',
                      style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nome,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      hintText: 'ex.: ana',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _entrar(),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _entrar,
                    child: const Text('Entrar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
