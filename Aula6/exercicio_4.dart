import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const JogoApp());
}

class JogoApp extends StatefulWidget {
  const JogoApp({super.key});

  @override
  State<JogoApp> createState() => _JogoAppState();
}

class _JogoAppState extends State<JogoApp> {
  final player = AudioPlayer();

  final itens = [
    'https://t3.ftcdn.net/jpg/01/23/14/80/360_F_123148069_wkgBuIsIROXbyLVWq7YNhJWPcxlamPeZ.jpg',
    'https://i.ebayimg.com/00/s/MTIwMFgxNjAw/z/KAcAAOSwTw5bnTbW/\$_57.JPG',
    'https://t4.ftcdn.net/jpg/02/55/26/63/360_F_255266320_plc5wjJmfpqqKLh0WnJyLmjc6jFE9vfo.jpg',
  ];

  int index = 0;
  int indexjogo = 0;
  int contadorJogadas = 0;
  String resultado = '';

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> tocarSom(String nome) async {
    await player.stop();
    await player.play(AssetSource('sounds/$nome.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jogo: Pedra, Papel, Tesoura',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pedra, Papel ou Tesoura'),
          backgroundColor: Colors.blueGrey,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              itens[index],
              width: 300,
              height: 200,
              fit: BoxFit.cover,
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
            Image.network(
              itens[indexjogo],
              width: 300,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                setState(() {
                  contadorJogadas++;

                  if (contadorJogadas % 5 == 0) {
                    indexjogo = perdePara(index);
                    resultado = "GANHOU";
                    tocarSom('ganhou');
                  } else {
                    int sorteio = Random().nextInt(2);
                    if (sorteio == 0) {
                      indexjogo = index;
                      resultado = "EMPATE";
                      tocarSom('empate');
                    } else {
                      indexjogo = ganhaDe(index);
                      resultado = "PERDEU";
                      tocarSom('perdeu');
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
    }
    return 0;
  }

  int ganhaDe(int jogador) {
    switch (jogador) {
      case 0:
        return 1;
      case 1:
        return 2;
      case 2:
        return 0;
    }
    return 0;
  }
}
