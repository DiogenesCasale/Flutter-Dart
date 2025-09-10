import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(NovoWidgetEstado());
}

class NovoWidgetEstado extends StatefulWidget {
  const NovoWidgetEstado({super.key});

  @override
  State<NovoWidgetEstado> createState() => _NovoWidgetEstadoState();
}

class _NovoWidgetEstadoState extends State<NovoWidgetEstado> {
  var aleatorio = 0;
  var quantidade = [0, 0, 0, 0, 0];

  var itens = [
    'https://t3.ftcdn.net/jpg/01/23/14/80/360_F_123148069_wkgBuIsIROXbyLVWq7YNhJWPcxlamPeZ.jpg',
    'https://i.ebayimg.com/00/s/MTIwMFgxNjAw/z/KAcAAOSwTw5bnTbW/\$_57.JPG',
    'https://t4.ftcdn.net/jpg/02/55/26/63/360_F_255266320_plc5wjJmfpqqKLh0WnJyLmjc6jFE9vfo.jpg'
  ];

  var index = 0;
  var indexjogo = 0;

  String resultado = ''; // <- Novo estado para o resultado

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.network(
                itens[index],
                width: 300,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                setState(() {
                  index = (index + 1) % itens.length;
                });
              },
              child: const Text('Próxima Opção'),
            ),
            const SizedBox(height: 20),
            Center(
              child: Image.network(
                itens[indexjogo],
                width: 300,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                setState(() {
                  indexjogo = Random().nextInt(3);
                  if (index == indexjogo) {
                    resultado = "EMPATE";
                  } else if ((index == 0 && indexjogo == 2) ||
                      (index == 1 && indexjogo == 0) ||
                      (index == 2 && indexjogo == 1)) {
                    resultado = "GANHOU";
                  } else {
                    resultado = "PERDEU";
                  }
                });
              },
              child: const Text('JOGAR'),
            ),
            const SizedBox(height: 20),
            Text(
              resultado,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }
}
