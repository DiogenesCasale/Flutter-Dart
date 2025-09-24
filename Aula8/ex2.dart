import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const PerguntasApp());
}

class Pergunta {
  final String t; 
  final String r;
  final bool c;

  const Pergunta({
    required this.t,
    required this.r,
    required this.c,
  });
}

class PerguntasApp extends StatefulWidget {
  const PerguntasApp({super.key});

  @override
  State<PerguntasApp> createState() => _PerguntasAppState();
}

class _PerguntasAppState extends State<PerguntasApp> {
  final List<Widget> _responseIcons = <Widget>[];

  int _currentQuestionIndex = 0;
  late SharedPreferences _prefs;

  final List<Pergunta> _questions = const <Pergunta>[
    Pergunta(t: 'Qual é a capital da França?', r: 'Paris', c: true),
    Pergunta(t: 'Quem escreveu "Dom Quixote"?', r: 'Miguel de Cervantes', c: true),
    Pergunta(t: 'Qual é o maior planeta do sistema solar?', r: 'Terra', c: false),
    Pergunta(t: 'Em que ano ocorreu a Revolução Francesa?', r: '1789', c: true),
    Pergunta(t: 'Quem pintou a Mona Lisa?', r: 'Leonardo da Vinci', c: true),
    Pergunta(t: 'Qual é o elemento químico representado pelo símbolo \'O\'?', r: 'Oxigênio', c: true),
    Pergunta(t: 'Qual é o rio mais longo do mundo?', r: 'Rio Nilo', c: true),
    Pergunta(t: 'Quem foi o primeiro presidente dos Estados Unidos?', r: 'George Washington', c: true),
    Pergunta(t: 'Qual é o país mais populoso do mundo?', r: 'China', c: true),
    Pergunta(t: 'Qual é a fórmula química da água?', r: 'H2O', c: true),
  ];

  @override
  void initState() {
    super.initState();
    _loadState(); 
  }

  Future<void> _loadState() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentQuestionIndex = _prefs.getInt('currentQuestionIndex') ?? 0;

      List<String>? savedResponses = _prefs.getStringList('responseIcons');
      if (savedResponses != null) {
        _responseIcons.addAll(
          savedResponses.map((icon) => Icon(
            icon == 'check' ? Icons.check : Icons.close,
            color: icon == 'check' ? Colors.green : Colors.red,
          )),
        );
      }
    });
  }

  // Salvar o estado atual
  Future<void> _saveState() async {
    await _prefs.setInt('currentQuestionIndex', _currentQuestionIndex);
    List<String> responseIcons = _responseIcons.map((icon) {
      return icon is Icon && icon.icon == Icons.check ? 'check' : 'close';
    }).toList();
    await _prefs.setStringList('responseIcons', responseIcons);
  }

  void _nextQuestion(bool userPressedSim) {
    if (_currentQuestionIndex >= _questions.length) {
      return; 
    }

    final Pergunta currentQuestion = _questions[_currentQuestionIndex];
    final bool isCorrect = (userPressedSim == currentQuestion.c);

    setState(() {
      _responseIcons.add(
        Icon(
          isCorrect ? Icons.check : Icons.close,
          color: isCorrect ? Colors.green : Colors.red,
        ),
      );
      _currentQuestionIndex++;
    });

    _saveState(); 
  }

  @override
  Widget build(BuildContext context) {
    final bool quizFinished = _currentQuestionIndex >= _questions.length;
    final Pergunta? currentQuestion = quizFinished
        ? null
        : _questions[_currentQuestionIndex];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blueGrey[900],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(
                      quizFinished
                          ? 'Quiz Finalizado!'
                          : currentQuestion!.t, 
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: quizFinished
                        ? const SizedBox.shrink()
                        : Text(
                            currentQuestion!.r, 
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 28,
                              color: Colors.blueGrey[200],
                            ),
                          ),
                  ),
                ),
                if (!quizFinished) ...<Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextButton(
                      onPressed: () => _nextQuestion(true), 
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        minimumSize: const Size(200, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'SIM',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextButton(
                      onPressed: () => _nextQuestion(false), 
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        foregroundColor: Colors.white,
                        minimumSize: const Size(200, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'NÃO',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _responseIcons,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
