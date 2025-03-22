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

  void alternarConversao() {
    setState(() {
      realParaDolar = !realParaDolar;
    });
  }

  @override
  Widget build(BuildContext context) {
    String titulo = realParaDolar ? 'Real para Dólar' : 'Dólar para Real';

    return Scaffold(
      appBar: AppBar(
        title: Text('Conversor de Moeda',
          style: TextStyle(fontSize: 30,
          fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,

      actions: [
        IconButton(
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoricoTela()));
            },
            icon: Icon(Icons.history))
      ],
      ),


      body: Center(
        child: GestureDetector(
          onTap: alternarConversao,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              titulo,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HistoricoTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico ou Filtros ou outra coisa'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text(
          'Histórico ou Filtros de busca ou Outra coisa ainda',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
