import 'package:flutter/material.dart';
import 'conversion_service.dart';
import 'conta_page.dart';

class ConversorTela extends StatelessWidget {
  final String usuario;
  const ConversorTela({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversor de Moedas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Minha Conta',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ContaPage(usuario: usuario)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ConversorWidget(),
      ),
    );
  }
}

class ConversorWidget extends StatefulWidget {
  const ConversorWidget({super.key});
  @override
  State<ConversorWidget> createState() => _ConversorWidgetState();
}

class _ConversorWidgetState extends State<ConversorWidget> {
  final _valorController = TextEditingController();
  String _moedaOrigem = 'USD';
  String _moedaDestino = 'BRL';
  String _resultado = '';
  bool _carregando = false;

  static const _moedas = ['USD', 'EUR', 'GBP', 'BTC', 'BRL'];

  Future<void> _converter() async {
    final texto = _valorController.text.replaceAll(',', '.');
    final valor = double.tryParse(texto);
    if (valor == null || valor <= 0) {
      setState(() => _resultado = 'Informe um valor válido');
      return;
    }
    if (_moedaOrigem == _moedaDestino) {
      setState(() => _resultado = 'Selecione moedas diferentes');
      return;
    }

    setState(() {
      _carregando = true;
      _resultado = '';
    });

    try {
      final convertido = await ConversionService.converterMoeda(
        valor: valor,
        moedaOrigem: _moedaOrigem,
        moedaDestino: _moedaDestino,
      );
      setState(() {
        _resultado =
        '${valor.toStringAsFixed(2)} $_moedaOrigem = ${convertido.toStringAsFixed(2)} $_moedaDestino';
      });
    } catch (e) {
      setState(() => _resultado = 'Erro ao converter: $e');
    } finally {
      setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _moedaOrigem,
                decoration: const InputDecoration(
                  labelText: 'De',
                  border: OutlineInputBorder(),
                ),
                items: _moedas
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (v) => setState(() => _moedaOrigem = v!),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _moedaDestino,
                decoration: const InputDecoration(
                  labelText: 'Para',
                  border: OutlineInputBorder(),
                ),
                items: _moedas
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (v) => setState(() => _moedaDestino = v!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _valorController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Valor',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        if (_carregando)
          const Center(child: CircularProgressIndicator())
        else if (_resultado.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF4CAF50)),
            ),
            child: Text(
              _resultado,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E7D32),
              ),
            ),
          ),
        ElevatedButton(
          onPressed: _converter,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4b9960),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            textStyle: const TextStyle(fontSize: 16),
          ),
          child: const Text('Converter'),
        ),
      ],
    );
  }
}
