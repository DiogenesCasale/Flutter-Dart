import 'package:flutter/material.dart';

void main() {
  runApp(const PetAgeApp());
}

const double altura = 80.0;
const Color fundo = Color(0xFF1E164B);
const Color selecionada = Color.fromARGB(255, 45, 11, 237);

enum Animal { gato, cachorro }

class PetAgeApp extends StatefulWidget {
  const PetAgeApp({super.key});

  @override
  State<PetAgeApp> createState() => _PetAgeAppState();
}

class _PetAgeAppState extends State<PetAgeApp> {
  Animal animalSelecionado = Animal.gato;
  int idade = 1;
  double peso = 5.0;

  void selecionarAnimal(Animal animal) {
    setState(() {
      animalSelecionado = animal;
    });
  }

  String calcularIdadeFisiologica() {
    if (animalSelecionado == Animal.gato) {
      const gatos = [
        10,
        15,
        24,
        28,
        32,
        36,
        40,
        44,
        48,
        52,
        56,
        60,
        64,
        68,
        72,
        76,
        80,
        84,
        88,
        92,
        96,
        100
      ];
      if (idade >= 0 && idade <= 21) {
        return gatos[idade].toString();
      }
    } else {
      const cachorro = {
        'pequeno': [
          15,
          24,
          28,
          32,
          36,
          40,
          44,
          48,
          52,
          56,
          60,
          64,
          68,
          72,
          76,
          80,
          84,
          88,
          92,
          96
        ],
        'medio': [
          15,
          24,
          28,
          33,
          37,
          42,
          47,
          52,
          56,
          60,
          65,
          69,
          74,
          78,
          83,
          87,
          92,
          96,
          101,
          105
        ],
        'grande': [
          15,
          24,
          28,
          35,
          40,
          45,
          50,
          55,
          61,
          66,
          72,
          77,
          82,
          88,
          93,
          99,
          104,
          109,
          115,
          120
        ],
        'gigante': [
          15,
          24,
          32,
          37,
          42,
          49,
          56,
          64,
          71,
          78,
          86,
          93,
          101,
          108,
          115,
          123
        ]
      };

      String porte = '';
      if (peso <= 9.07) {
        porte = 'pequeno';
      } else if (peso <= 22.7) {
        porte = 'medio';
      } else if (peso <= 40.8) {
        porte = 'grande';
      } else {
        porte = 'gigante';
      }

      List<int> lista = cachorro[porte]!;
      if (idade - 1 < lista.length) {
        return lista[idade - 1].toString();
      } else {
        return '-';
      }
    }

    return '-';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Idade Fisiológica de Pets')),
        body: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => selecionarAnimal(Animal.gato),
                      child: Caixa(
                        cor: animalSelecionado == Animal.gato
                            ? selecionada
                            : fundo,
                        filho: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pets, size: 80.0, color: Colors.white),
                            SizedBox(height: 15),
                            Text('GATO', style: TextStyle(fontSize: 18.0))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => selecionarAnimal(Animal.cachorro),
                      child: Caixa(
                        cor: animalSelecionado == Animal.cachorro
                            ? selecionada
                            : fundo,
                        filho: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pets, size: 80.0, color: Colors.white),
                            SizedBox(height: 15),
                            Text('CACHORRO', style: TextStyle(fontSize: 18.0))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (animalSelecionado == Animal.cachorro)
              Expanded(
                child: Caixa(
                  cor: fundo,
                  filho: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Peso (kg)',
                          style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                      Text('${peso.toStringAsFixed(1)} kg',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white)),
                      Slider(
                        value: peso,
                        min: 1,
                        max: 60,
                        divisions: 590,
                        label: '${peso.toStringAsFixed(1)} kg',
                        onChanged: (double novoPeso) {
                          setState(() {
                            peso = novoPeso;
                          });
                        },
                      )
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
                        children: [
                          const Text('Idade (anos)',
                              style: TextStyle(color: Colors.grey)),
                          Text('$idade',
                              style: const TextStyle(
                                  fontSize: 24.0, color: Colors.white)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (idade < 21) idade++;
                                  });
                                },
                                icon: const Icon(Icons.add),
                                color: Colors.white,
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (idade > 1) idade--;
                                  });
                                },
                                icon: const Icon(Icons.remove),
                                color: Colors.white,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Caixa(
                      cor: fundo,
                      filho: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Idade Fisiológica (anos humanos)',
                              style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 10),
                          Text(
                            calcularIdadeFisiologica(),
                            style: const TextStyle(
                                fontSize: 24.0, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: const Color(0xFF638ED6),
              width: double.infinity,
              height: altura,
              alignment: Alignment.center,
              child: const Text(
                'Idade fisiológica de gatos e cachorros:',
                style: TextStyle(fontSize: 18),
              ),
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

  const Caixa({super.key, required this.cor, this.filho});

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
