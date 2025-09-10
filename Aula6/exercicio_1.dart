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
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                setState(() {
                  index = (index + 1) % itens.length;
                });
                print(itens[index]);
              },
              child: const Text('Próxima Imagem'),
            )
          ],
        ),
      ),
    );
  }
}

class $ {}
