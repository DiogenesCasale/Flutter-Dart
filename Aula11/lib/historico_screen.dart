import 'package:flutter/material.dart';
import 'database_helper.dart';

class HistoricoScreen extends StatefulWidget {
  @override
  _HistoricoScreenState createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  late Future<List<Map<String, dynamic>>> _operacoesFuture;

  @override
  void initState() {
    super.initState();
    _operacoesFuture = DatabaseHelper.instance.getOperacoes();
  }

  Future<void> _limparHistorico() async {
    await DatabaseHelper.instance.limparHistorico();
    setState(() {
      _operacoesFuture = DatabaseHelper.instance.getOperacoes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Operações'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _limparHistorico,
            tooltip: 'Limpar histórico',
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _operacoesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados'));
          }
          final operacoes = snapshot.data ?? [];
          if (operacoes.isEmpty) {
            return Center(child: Text('Nenhuma operação registrada.'));
          }
          return ListView.builder(
            itemCount: operacoes.length,
            itemBuilder: (context, index) {
              final operacao = operacoes[index];
              return ListTile(
                title:
                    Text('${operacao['operacao']} = ${operacao['resultado']}'),
                subtitle: Text('Data: ${operacao['timestamp']}'),
              );
            },
          );
        },
      ),
    );
  }
}
