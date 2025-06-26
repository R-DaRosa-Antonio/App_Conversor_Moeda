import 'package:flutter/material.dart';
import 'database.dart';
import 'cadastro_page.dart';

class ContaPage extends StatefulWidget {
  final String usuario;
  const ContaPage({super.key, required this.usuario});

  @override
  State<ContaPage> createState() => _ContaPageState();
}

class _ContaPageState extends State<ContaPage> {
  List<Conversao> _historico = [];
  UsuarioLogado? _localizacao;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final lista = await DatabaseHelper.instance.fetchAllConversoes();
    final logins = await DatabaseHelper.instance.fetchUsuariosLogados();
    final ultimoLogin = logins.firstWhere(
          (l) => l.usuario == widget.usuario,
      orElse: () => UsuarioLogado(
        usuario: widget.usuario,
        latitude: 0,
        longitude: 0,
        dataLogin: '',
      ),
    );

    setState(() {
      _historico = lista;
      _localizacao = ultimoLogin;
    });
  }

  Future<void> _excluirConta() async {
    await DatabaseHelper.instance.excluirUsuario(widget.usuario);
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const CadastroPage()),
          (route) => false,
    );
  }

  Widget _buildItem(Conversao c) {
    return ListTile(
      title: Text('${c.tipo} — ${c.valorOrigem} → ${c.valorDestino}'),
      subtitle: Text(c.data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Conta'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Usuário: ${widget.usuario}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            if (_localizacao != null)
              Text('Login em:\nLat: ${_localizacao!.latitude}, Long: ${_localizacao!.longitude}'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _excluirConta,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Excluir Conta'),
            ),
            const Divider(height: 32),
            const Text('Histórico de Conversões', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            if (_historico.isEmpty)
              const Text('Nenhuma conversão registrada'),
            ..._historico.map(_buildItem).toList(),
          ],
        ),
      ),
    );
  }
}
