import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(title: 'Cálculo da Idade', home: FirstRoute()));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController dateController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Primeira Rota')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Digite sua data de nascimento (dd/MM/yyyy)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final String dateStr = dateController.text;
                if (dateStr.isNotEmpty) {
                  final DateTime? birthDate = _parseDate(dateStr);
                  if (birthDate != null) {
                    // Navega para a segunda tela e passa a data de nascimento
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SecondRoute(birthDate: birthDate),
                      ),
                    );
                  } else {
                    // Exibe mensagem de erro caso o formato esteja errado
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Formato de data inválido!')),
                    );
                  }
                }
              },
              child: const Text('Calcular Idade'),
            ),
          ],
        ),
      ),
    );
  }

  // Função para tentar parsear a data no formato 'dd/MM/yyyy'
  DateTime? _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}

class SecondRoute extends StatelessWidget {
  final DateTime birthDate;

  const SecondRoute({super.key, required this.birthDate});

  @override
  Widget build(BuildContext context) {
    final age = _calculateAge(birthDate);

    return Scaffold(
      appBar: AppBar(title: const Text('Segunda Rota')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sua idade: $age anos',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Volta para a primeira tela
              },
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }

  // Função para calcular a idade
  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
