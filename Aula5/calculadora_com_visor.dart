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
  bool novoCalculo = false; // controla se deve limpar o visor

  void _pressionar(String valor) {
    setState(() {
      if (valor == "+") {
        somaApertado = true;
      } else if (valor == "=") {
        if (operador1 != null && operador2 != null) {
          resultado = operador1! + operador2!;
          novoCalculo =
              true; // após mostrar o resultado, preparar para próximo cálculo
        }

        // mostrar os dados console (mas no visor apenas resultado)
        print("Operador 1: $operador1");
        print("Operador 2: $operador2");
        print("Soma apertado: $somaApertado");
        print("Resultado: $resultado");
        print("------------------");

        // limpar operadores e soma
        operador1 = null;
        operador2 = null;
        somaApertado = false;
      } else {
        int numero = int.parse(valor);

        // qnd começar novo calculo, limpa o resultado do visor
        if (novoCalculo) {
          resultado = null;
          novoCalculo = false;
        }

        if (!somaApertado) {
          operador1 =
              (operador1 == null) ? numero : int.parse("$operador1$numero");
        } else {
          operador2 =
              (operador2 == null) ? numero : int.parse("$operador2$numero");
        }
      }
    });
  }

  Widget _buildButton(String text) {
    return ElevatedButton(
      onPressed: () => _pressionar(text),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(70, 70),
      ),
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
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerRight,
            color: Colors.black12,
            child: Text(
              resultado?.toString() ?? "",
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
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
