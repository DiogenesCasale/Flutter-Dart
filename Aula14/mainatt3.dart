import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: CardGamePage(),
    );
  }
}

class CardGamePage extends StatefulWidget {
  @override
  State<CardGamePage> createState() => _CardGamePageState();
}

class _CardGamePageState extends State<CardGamePage> {
  Map<String, dynamic>? cardPlayer;
  Map<String, dynamic>? cardEnemy;

  String result = "";

  int playerWins = 0;
  int enemyWins = 0;

  final random = Random();

  /// Busca personagem aleatório da API Rick and Morty
  Future<Map<String, dynamic>> fetchRandomCard() async {
    while (true) {
      int randomId = random.nextInt(826) + 1;
      final url = "https://rickandmortyapi.com/api/character/$randomId";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final card = jsonDecode(response.body);

        if (card["image"] != null && card["image"].toString().isNotEmpty) {
          return card;
        }
      }
    }
  }

  Future<void> playRound() async {
    setState(() {
      cardPlayer = null;
      cardEnemy = null;
      result = "";
    });

    final p = await fetchRandomCard();
    final e = await fetchRandomCard();

    final playerValue = (p["episode"] as List).length;
    final enemyValue = (e["episode"] as List).length;

    String r = "";

    if (playerValue > enemyValue) {
      playerWins++;
      r = "Você venceu!";
    } else if (enemyValue > playerValue) {
      enemyWins++;
      r = "Adversário venceu!";
    } else {
      r = "Empate!";
    }

    setState(() {
      cardPlayer = p;
      cardEnemy = e;
      result = r;
    });
  }

  Widget buildCard(Map<String, dynamic>? card, bool isPlayer) {
    if (card == null) {
      return Container(
        width: 150,
        height: 260,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: Colors.white),
      );
    }

    final String name = card["name"];
    final String status = card["status"];
    final int episodes = (card["episode"] as List).length;
    final String imageUrl = card["image"];

    return Container(
      width: 160,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 2,
          color: isPlayer ? Colors.greenAccent : Colors.redAccent,
        ),
        boxShadow: [
          BoxShadow(
            color: (isPlayer ? Colors.green : Colors.red).withOpacity(0.5),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 120,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text("Status: $status", style: const TextStyle(color: Colors.white70)),
          Text("Episódios: $episodes",
              style: const TextStyle(color: Colors.greenAccent, fontSize: 16)),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    playRound();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0b0b0d),
      appBar: AppBar(
        title: const Text("Rick and Morty Card Battle ⚡"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Vitórias — Você: $playerWins   |   Adversário: $enemyWins",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            /// Cartas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildCard(cardEnemy, false),
                buildCard(cardPlayer, true),
              ],
            ),
            const SizedBox(height: 25),

            Text(
              result,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.amberAccent,
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: playRound,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.shade400,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Jogar novamente", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
