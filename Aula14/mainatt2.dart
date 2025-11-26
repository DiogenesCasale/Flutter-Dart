import 'dart:convert';
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
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: const Color(0xFF1B1D23),
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2C2F36),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIconColor: Colors.white70,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      home: DictionaryPage(),
    );
  }
}

class DictionaryPage extends StatefulWidget {
  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final TextEditingController _controller = TextEditingController();
  String? definition;
  String? error;

  Future<void> _searchDefinition() async {
    setState(() {
      definition = null;
      error = null;
    });

    final word = _controller.text.trim();
    if (word.isEmpty) {
      setState(() => error = "Digite uma palavra em inglês.");
      return;
    }

    final url = "https://api.dictionaryapi.dev/api/v2/entries/en/$word";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      try {
        final firstDefinition =
            data[0]["meanings"][0]["definitions"][0]["definition"];

        setState(() {
          definition = firstDefinition;
        });
      } catch (e) {
        setState(() => error = "Nenhuma definição encontrada.");
      }
    } else {
      setState(() => error = "Palavra não encontrada.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📘 Dicionário de Inglês"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Digite uma palavra",
                prefixIcon: Icon(Icons.search),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _searchDefinition,
              child: const Text("Buscar definição"),
            ),

            const SizedBox(height: 30),

            if (error != null)
              Text(
                error!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 18),
              ),

            if (definition != null)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2F36),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  "📚 Definição:\n\n$definition",
                  style: const TextStyle(fontSize: 20, height: 1.4),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
