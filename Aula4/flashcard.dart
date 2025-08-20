import 'package:flutter/material.dart';

void main() {
  runApp(const FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        
        appBar: AppBar(
          title: const Text('Flashcards Verbos em Inglês'),
          backgroundColor: Colors.green,
        ),
     
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                
                const FlashcardWidget(
                  frase: 'He ran a marathon last month.',
                  tempoVerbal: 'Past', 
                  icone: Icons.history, 
                  corIcone: Colors.brown,
                  urlImagem: 'https://images.pexels.com/photos/1034662/pexels-photo-1034662.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 
                ),

                const SizedBox(
                  height: 10,
                  width: 300,
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),

                const FlashcardWidget(
                  frase: 'She runs every evening.',
                  tempoVerbal: 'Present', 
                  icone: Icons.wb_sunny, 
                  corIcone: Colors.orange,
                  urlImagem: 'https://admin.cnnbrasil.com.br/wp-content/uploads/sites/12/2025/03/corredora-holandesa-cai-prova-atletismo-e1741606396468.jpg?w=1200&h=675&crop=1', 
                ),

                const SizedBox(
                  height: 10,
                  width: 300,
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),

                const FlashcardWidget(
                  frase: 'They will run in the next race.',
                  tempoVerbal: 'Future', 
                  icone: Icons.event, 
                  corIcone: Colors.blue,
                  urlImagem: 'https://cdn.atletis.com.br/atletis-website/base/088/7f1/a5b/treinos-grupos-de-corrida.jpg', 
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FlashcardWidget extends StatelessWidget {
  final String frase;
  final String tempoVerbal;
  final IconData icone;
  final Color corIcone;
  final String urlImagem;

  const FlashcardWidget({
    super.key,
    required this.frase,
    required this.tempoVerbal,
    required this.icone,
    required this.corIcone,
    required this.urlImagem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      elevation: 5,
      clipBehavior: Clip.antiAlias, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Image.network(
            urlImagem,
            height: 200,
            fit: BoxFit.cover, 
          ),
          
          ListTile(
            leading: Icon(icone, color: corIcone, size: 40),
            title: Text(
              frase,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              tempoVerbal,
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
          ), 
          
          Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                
                TextButton(
                  onPressed: () {
                  },
                  child: const Text('Memorizado'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}