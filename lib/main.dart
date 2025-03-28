import 'package:flutter/material.dart';

void main() {
  runApp(ConversorApp());
}

class ConversorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversor de Moeda',
      home: ConversorTela(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ConversorTela extends StatefulWidget {
  @override
  _ConversorTelaState createState() => _ConversorTelaState();
}

class _ConversorTelaState extends State<ConversorTela> {
  bool realParaDolar = true;

  final TextEditingController _controllerOrigem = TextEditingController();
  final TextEditingController _controllerDestino = TextEditingController();

  void alternarConversao() {
    setState(() {
      realParaDolar = !realParaDolar;
      _controllerOrigem.clear();
      _controllerDestino.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    String titulo = realParaDolar ? 'Real para Dólar' : 'Dólar para Real';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Conversor de Moeda',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoricoTela()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


            // Campo de entrada (origem)
            TextField(
              controller: _controllerOrigem,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: realParaDolar ? 'Valor em Reais' : 'Valor em Dólares',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            SizedBox(height: 20),

            // Campo de resultado (destino)
            TextField(
              controller: _controllerDestino,
              readOnly: true,
              decoration: InputDecoration(
                labelText: realParaDolar ? 'Valor em Dólares' : 'Valor em Reais',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.swap_horiz),
              ),
            ),
            SizedBox(height: 20),

            // Botão de alternar direção
            ElevatedButton(
              onPressed: alternarConversao,
              child: Text('Alternar: $titulo',
                style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold),
                ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 40),

            // Placeholder para gráfico
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green),
              ),
              child: Center(
                child: Text(
                  '',
                  style: TextStyle(color: Colors.green.shade900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tela de histórico (sem alterações)
class HistoricoTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: Center(
        child: Text(
          'Histórico ou filtros aparecerão aqui.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
