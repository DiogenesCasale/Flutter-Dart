import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const TabuadaApp());
}

class TabuadaApp extends StatefulWidget {
  const TabuadaApp({super.key});

  @override
  State<TabuadaApp> createState() => _TabuadaAppState();
}

class _TabuadaAppState extends State<TabuadaApp> {
  late SharedPreferences _prefs;
  int _currentTabuada = 1;
  int _questionIndex = 1;
  int _correctAnswers = 0;
  String _userInput = '';
  String _feedbackMessage = '';

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  // Carregar o estado salvo
  Future<void> _loadState() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentTabuada = _prefs.getInt('currentTabuada') ?? 1;
      _correctAnswers = _prefs.getInt('correctAnswers') ?? 0;
      _questionIndex = _prefs.getInt('questionIndex') ?? 1;
    });
  }

  // Salvar o estado atual
  Future<void> _saveState() async {
    await _prefs.setInt('currentTabuada', _currentTabuada);
    await _prefs.setInt('correctAnswers', _correctAnswers);
    await _prefs.setInt('questionIndex', _questionIndex);
  }

  void _checkAnswer() {
    final int correctAnswer = _currentTabuada * _questionIndex;
    if (int.tryParse(_userInput) == correctAnswer) {
      setState(() {
        _feedbackMessage = 'Resposta Correta!';
        _correctAnswers++;
      });
    } else {
      setState(() {
        _feedbackMessage = 'Resposta Errada. A resposta correta era: $correctAnswer';
      });
    }

    // Avançar para a próxima pergunta
    setState(() {
      _questionIndex++;
      _userInput = '';
    });

    // Se a tabuada estiver completa, avançar para a próxima tabuada
    if (_questionIndex > 10) {
      setState(() {
        if (_currentTabuada < 10) {
          _currentTabuada++;
          _questionIndex = 1;
        } else {
          _feedbackMessage = 'Você terminou todas as tabuadas!';
        }
      });
    }

    _saveState(); // Salvar o estado após cada interação
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Treinamento de Tabuada'),
          backgroundColor: Colors.blueGrey[700],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Tabuada de $_currentTabuada',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '$_currentTabuada × $_questionIndex = ?',
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (input) {
                  setState(() {
                    _userInput = input;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Digite sua resposta',
                  hintStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.blueGrey[700],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _userInput.isNotEmpty ? _checkAnswer : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700, 
                  minimumSize: const Size(200, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Responder',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (_feedbackMessage.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  _feedbackMessage,
                  style: TextStyle(
                    fontSize: 18,
                    color: _feedbackMessage.contains('Errada')
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Text(
                'Acertos: $_correctAnswers',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.blueGrey[900],
      ),
    );
  }
}
