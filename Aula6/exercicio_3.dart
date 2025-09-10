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
  var itens = [
    'https://t3.ftcdn.net/jpg/01/23/14/80/360_F_123148069_wkgBuIsIROXbyLVWq7YNhJWPcxlamPeZ.jpg',
    'https://i.ebayimg.com/00/s/MTIwMFgxNjAw/z/KAcAAOSwTw5bnTbW/\$_57.JPG',
    'https://t4.ftcdn.net/jpg/02/55/26/63/360_F_255266320_plc5wjJmfpqqKLh0WnJyLmjc6jFE9vfo.jpg'
  ];

  var index = 0;
  var indexjogo = 0;
  String resultado = '';
  int contadorJogadas = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Escolha do jogador
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

            // computador
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
                  contadorJogadas++;

                  if (contadorJogadas % 5 == 3) {
                    indexjogo = perdePara(index);
                    resultado = "GANHOU";
                  } else {
                    int sorteio = Random().nextInt(2); // 0 ou 1

                    if (sorteio == 0) {
                      indexjogo = index; // empate
                      resultado = "EMPATE";
                    } else {
                      indexjogo = ganhaDe(index); // máquina vence
                      resultado = "PERDEU";
                    }
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
            ),
          ],
        ),
      ),
    );
  }

  int perdePara(int jogador) {
    switch (jogador) {
      case 0:
        return 2;
      case 1:
        return 0;
      case 2:
        return 1;
      default:
        return 0;
    }
  }

  int ganhaDe(int jogador) {
    switch (jogador) {
      case 0:
        return 1;
      case 1:
        return 2;
      case 2:
        return 0;
      default:
        return 0;
    }
  }
}
