import 'package:flutter/material.dart';
import 'database.dart';
import 'login_page.dart';
import 'cadastro_page.dart';

void main() {
  runApp(const ConversorApp());
}

class ConversorApp extends StatelessWidget {
  const ConversorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversor de Moeda',
      debugShowCheckedModeBanner: false,
      home: const TelaInicial(), // decide para onde ir
    );
  }
}

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  bool _verificando = true;
  bool _existeUsuario = false;

  @override
  void initState() {
    super.initState();
    _checarUsuario();
  }

  Future<void> _checarUsuario() async {
    final existe = await DatabaseHelper.instance.existeAlgumUsuario();
    setState(() {
      _verificando = false;
      _existeUsuario = existe;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_verificando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return _existeUsuario ? const LoginPage() : const CadastroPage();
  }
}
