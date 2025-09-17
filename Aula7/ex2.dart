import 'package:flutter/material.dart';
import 'dart:math'; 

void main() {
  runApp(const MaterialApp(title: 'Cálculos do Círculo', home: CircleCalculator()));
}

class CircleCalculator extends StatefulWidget {
  const CircleCalculator({super.key});

  @override
  _CircleCalculatorState createState() => _CircleCalculatorState();
}

class _CircleCalculatorState extends State<CircleCalculator> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController raioController = TextEditingController();
  double? raio;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculos do Círculo'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Raio'),
            Tab(text: 'Diâmetro'),
            Tab(text: 'Circunferência'),
            Tab(text: 'Área'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: raioController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Digite o Raio',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      raio = double.tryParse(raioController.text);
                    });
                    if (raio == null || raio! <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor, insira um valor válido!')),
                      );
                    }
                  },
                  child: const Text('Definir Raio'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: raio != null
                  ? Text('Diâmetro: ${2 * raio!}', style: const TextStyle(fontSize: 24))
                  : const Text('Informe o raio na aba Raio', style: TextStyle(fontSize: 24)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: raio != null
                  ? Text('Circunferência: ${2 * pi * raio!}', style: const TextStyle(fontSize: 24))
                  : const Text('Informe o raio na aba Raio', style: TextStyle(fontSize: 24)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: raio != null
                  ? Text('Área: ${pi * raio! * raio!}', style: const TextStyle(fontSize: 24))
                  : const Text('Informe o raio na aba Raio', style: TextStyle(fontSize: 24)),
            ),
          ),
        ],
      ),
    );
  }
}
