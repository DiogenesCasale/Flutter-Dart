import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculadoraPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculadoraPage extends StatefulWidget {
  @override
  _CalculadoraPageState createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  int? operador1;
  int? operador2;
  bool somaApertado = false;
  int? resultado;

  void _pressionar(String valor) {
    setState(() {
      if (valor == "+") {
        somaApertado = true;
      } else if (valor == "=") {
        if (operador1 != null && operador2 != null) {
          resultado = operador1! + operador2!;
        }

        print("Operador 1: $operador1");
        print("Operador 2: $operador2");
        print("Soma apertado: $somaApertado");
        print("Resultado: $resultado");
        print("------------------");

        //  limpar qnd apertar =
        operador1 = null;
        operador2 = null;
        somaApertado = false;
        resultado = null;
      } else {
        int numero = int.parse(valor);

        if (!somaApertado) {
          operador1 =
              (operador1 == null) ? numero : int.parse("$operador1$numero");
        } else {
          operador2 =
              (operador2 == null) ? numero : int.parse("$operador2$numero");
        }
      }

      // mostrar no console passo a passo das operações
      print("Operador 1: $operador1");
      print("Operador 2: $operador2");
      print("Soma apertado: $somaApertado");
      print("Resultado: $resultado");
      print("------------------");
    });
  }

  Widget _buildButton(String text) {
    return ElevatedButton(
      onPressed: () => _pressionar(text),
      child: Text(text, style: const TextStyle(fontSize: 22)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculadora")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_buildButton("7"), _buildButton("8"), _buildButton("9")],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_buildButton("4"), _buildButton("5"), _buildButton("6")],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_buildButton("1"), _buildButton("2"), _buildButton("3")],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_buildButton("0"), _buildButton("="), _buildButton("+")],
          ),
        ],
      ),
    );
  }
}
