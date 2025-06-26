import 'package:flutter/material.dart';
import 'database.dart';
import 'gps_service.dart';
import 'conversor_tela.dart';
import 'cadastro_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usuarioController = TextEditingController();
  final _senhaController = TextEditingController();

  void _fazerLogin() async {
    final usuario = _usuarioController.text.trim();
    final senha = _senhaController.text.trim();

    if (usuario.isEmpty || senha.isEmpty) {
      _mostrarMensagem('Preencha todos os campos');
      return;
    }

    final user = await DatabaseHelper.instance.validarLogin(usuario, senha);
    if (user == null) {
      _mostrarMensagem('Usuário ou senha inválidos');
      return;
    }

    // Só aqui, após validar usuário, solicitamos e salvamos a localização
    final posicao = await GpsService.obterLocalizacao(context);
    if (posicao != null) {
      final loginData = UsuarioLogado(
        usuario: usuario,
        latitude: posicao.latitude,
        longitude: posicao.longitude,
        dataLogin: DateTime.now().toIso8601String(),
      );
      await DatabaseHelper.instance.insertUsuarioLogin(loginData);
    } else {
      _mostrarMensagem('Não foi possível obter localização.');
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ConversorTela(usuario: usuario)),
    );
  }

  void _mostrarMensagem(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
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
                onPressed: _fazerLogin,
                child: const Text('Entrar'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CadastroPage()),
                  );
                },
                child: const Text("Não possui login? Cadastre-se"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
