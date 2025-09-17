import 'package:flutter/material.dart';
import 'dart:math'; 
void main() {
  runApp(const MaterialApp(title: 'Cálculo da Área do Círculo', home: FirstRoute()));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController raioController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Primeira Rota')),
      body: Padding(
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
                double? raio = double.tryParse(raioController.text);
                if (raio != null && raio > 0) {
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondRoute(raio: raio),
                    ),
                  );
                } else {
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor, insira um valor válido!')),
                  );
                }
              },
              child: const Text('Calcular Área'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  final double raio;

  const SecondRoute({super.key, required this.raio});

  @override
  Widget build(BuildContext context) {
    
    double area = pi * raio * raio;

    return Scaffold(
      appBar: AppBar(title: const Text('Segunda Rota')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Raio: ${raio.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              'Área do Círculo: ${area.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
