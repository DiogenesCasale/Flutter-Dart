import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> buscaPost() async {
  var url = Uri.https(
    'olinda.bcb.gov.br',
    '/olinda/servico/PTAX/versao/v1/odata/CotacaoDolarDia(dataCotacao=@dataCotacao)',
    {
      '@dataCotacao': '\'03-07-2025\'',  
      '\$top': '100',
      '\$format': 'json',
      '\$select': 'cotacaoCompra'
    },
  );

  try {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonBody = json.decode(response.body);
      var cotacao = jsonBody['value'][0]['cotacaoCompra'];
      return cotacao.toString();
    } else {
      return 'Erro ao acessar a API. Status Code: ${response.statusCode}';
    }
  } catch (e) {
    return 'Ocorreu um erro na requisição: $e';
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder<String>(
            future: buscaPost(),  
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erro: ${snapshot.error}');
              } else {
                return Text(
                  'Cotação Dólar 03-07-2025: ${snapshot.data}',
                  style: const TextStyle(fontSize: 24),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
