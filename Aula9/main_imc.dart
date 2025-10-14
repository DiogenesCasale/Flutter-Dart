import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const double alturaConstante = 80.0;
const Color fundo = Color(0xFF1E164B);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double altura = 150.0;
  double peso = 65.0;
  double resultado = 0.0;

  void calcularIMC() {
    setState(() {
      resultado = peso / ((altura / 100) * (altura / 100));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('IMC')),
        body: Column(
          children: [
            const Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Caixa(
                      cor: fundo,
                      filho: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.male, size: 80),
                          SizedBox(height: 15.0),
                          Text(
                            'MASC',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Caixa(
                      cor: fundo,
                      filho: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.female, size: 80),
                          SizedBox(height: 15.0),
                          Text(
                            'FEM',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Caixa(
                cor: fundo,
                filho: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Altura: ${altura.toStringAsFixed(1)} cm',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Slider(
                      value: altura,
                      min: 100,
                      max: 220,
                      divisions: 120,
                      label: altura.toStringAsFixed(1),
                      onChanged: (double newValue) {
                        setState(() {
                          altura = newValue;
                        });
                        calcularIMC();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Caixa(
                      cor: fundo,
                      filho: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Peso: ${peso.toStringAsFixed(1)} kg',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    if (peso > 10) peso -= 0.5;
                                  });
                                  calcularIMC();
                                },
                              ),
                              Text(
                                peso.toStringAsFixed(1),
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    peso += 0.5;
                                  });
                                  calcularIMC();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Caixa(
                      cor: fundo,
                      filho: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Resultado: ${resultado.toStringAsFixed(1)}',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: const Color(0xFF638ED6),
              width: double.infinity,
              height: alturaConstante, // constante!
              margin: const EdgeInsets.only(top: 10.0),
            ),
          ],
        ),
      ),
    );
  }
}

class Caixa extends StatelessWidget {
  final Color cor;
  final Widget? filho;

  const Caixa({required this.cor, this.filho});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: cor,
      ),
      child: filho,
    );
  }
}
