import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'calculadora_model.dart';

class CalculadoraScreen extends StatefulWidget {
  @override
  _CalculadoraScreenState createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  @override
  void initState() {
    super.initState();
    // Carrega dados do banco ao iniciar a tela
    Future.microtask(() => context.read<CalculadoraModel>().carregarDados());
  }

  @override
  @override
  Widget build(BuildContext context) {
    final model = context.watch<CalculadoraModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Histórico de operações',
            onPressed: () {
              Navigator.pushNamed(context, '/historico');
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 400, // largura fixa da calculadora
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tela de exibição
              Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.centerRight,
                child: Text(
                  model.tela,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 20),

              // Grade de botões
              Flexible(
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    for (var texto in [
                      '7',
                      '8',
                      '9',
                      '/',
                      '4',
                      '5',
                      '6',
                      '*',
                      '1',
                      '2',
                      '3',
                      '-',
                      '0',
                      'C',
                      '=',
                      '+',
                    ])
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          textStyle: const TextStyle(fontSize: 24),
                        ),
                        onPressed: () {
                          final calc = context.read<CalculadoraModel>();
                          if (texto == '=') {
                            calc.calcular();
                          } else if (texto == 'C') {
                            calc.concat('0');
                          } else if (['+', '-', '*', '/'].contains(texto)) {
                            calc.setoperacao(texto);
                          } else {
                            calc.concat(texto);
                          }
                        },
                        child: Text(texto),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Linha de memória
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        context.read<CalculadoraModel>().salvarMemoria(),
                    child: const Text('M+'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<CalculadoraModel>().limparMemoria(),
                    child: const Text('MC'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<CalculadoraModel>().lerMemoria(),
                    child: const Text('MR'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
