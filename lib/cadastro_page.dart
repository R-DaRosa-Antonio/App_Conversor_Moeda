import 'package:flutter/material.dart';
import 'database.dart';
import 'login_page.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _usuarioController = TextEditingController();
  final _senhaController = TextEditingController();

  void _cadastrar() async {
    final usuario = _usuarioController.text.trim();
    final senha = _senhaController.text.trim();

    if (usuario.isEmpty || senha.isEmpty) {
      _mostrarMensagem('Preencha todos os campos');
      return;
    }

    final existe = await DatabaseHelper.instance.buscarUsuario(usuario);
    if (existe != null) {
      _mostrarMensagem('Usuário já existe');
      return;
    }

    await DatabaseHelper.instance.inserirUsuario(
      Usuario(usuario: usuario, senha: senha),
    );

    _mostrarMensagem('Usuário cadastrado com sucesso');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void _mostrarMensagem(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usuarioController,
                decoration: const InputDecoration(
                  labelText: 'Usuário',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _senhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _cadastrar,
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
