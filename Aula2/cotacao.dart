import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CotacaoData {
  final String date;
  final String cotacao;

  CotacaoData({required this.date, required this.cotacao});
}

Future<CotacaoData> buscaPost() async {
  DateTime hoje = DateTime.now();
  DateTime ontem = hoje.subtract(const Duration(days: 1));

  if (ontem.weekday == DateTime.sunday) {
    ontem = ontem.subtract(const Duration(days: 2)); 
  }

  String dataCotacao =
      '${ontem.month.toString().padLeft(2, '0')}-${ontem.day.toString().padLeft(2, '0')}-${ontem.year}';

  var url = Uri.https(
    'olinda.bcb.gov.br',
    '/olinda/servico/PTAX/versao/v1/odata/CotacaoDolarDia(dataCotacao=@dataCotacao)',
    {
      '@dataCotacao': "'$dataCotacao'",
      '\$top': '100',
      '\$format': 'json',
      '\$select': 'cotacaoCompra'
    },
  );

  final http.Response response;
  try {
    response = await http.get(url);
  } catch (e) {
    throw Exception('Ocorreu um erro na requisição de rede: $e');
  }

  if (response.statusCode == 200) {
    var jsonBody = json.decode(response.body);

    if (jsonBody is Map &&
        jsonBody.containsKey('value') &&
        jsonBody['value'] is List &&
        jsonBody['value'].isNotEmpty) {
      var cotacao = jsonBody['value'][0]['cotacaoCompra'];
      if (cotacao != null) {
        return CotacaoData(date: dataCotacao, cotacao: cotacao.toString());
      } else {
        throw Exception('Cotação não encontrada na resposta da API.');
      }
    } else {
      throw Exception('Formato de resposta da API inesperado ou dados vazios.');
    }
  } else {
    throw Exception('Erro ao acessar a API. Status Code: ${response.statusCode}');
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
      debugShowCheckedModeBanner: false, 
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cotação do Dólar'),
        ),
        body: Center(
          child: FutureBuilder<CotacaoData>(
            future: buscaPost(), 
            builder: (BuildContext context, AsyncSnapshot<CotacaoData> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text(
                  'Erro: ${snapshot.error}',
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                  textAlign: TextAlign.center,
                );
              } else if (snapshot.hasData) {
                return Text(
                  'Cotação Dólar ${snapshot.data!.date}: ${snapshot.data!.cotacao}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                );
              } else {
                return const Text(
                  'Nenhum dado disponível.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}