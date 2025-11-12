import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

class Localizacao {
  double? latitude;
  double? longitude;

  Future<void> pegaLocalizacaoAtual() async {
    LocationPermission permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        throw Exception('Permissão de localização negada.');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      throw Exception('Permissão de localização negada permanentemente.');
    }

    Position posicao = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    latitude = posicao.latitude;
    longitude = posicao.longitude;
  }
}

class Clima {
  final double temperatura;
  final double umidade;
  final double velocidadeVento;

  Clima({
    required this.temperatura,
    required this.umidade,
    required this.velocidadeVento,
  });

  factory Clima.fromJson(Map<String, dynamic> json) {
    return Clima(
      temperatura: json['current']['temperature_2m'].toDouble(),
      umidade: json['current']['relative_humidity_2m'].toDouble(),
      velocidadeVento: json['current']['wind_speed_10m'].toDouble(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final Localizacao localizacao = Localizacao();
  Clima? clima;
  bool carregando = true;
  String erro = '';

  @override
  void initState() {
    super.initState();
    obterDadosClima();
  }

  Future<void> obterDadosClima() async {
    setState(() {
      carregando = true;
      erro = '';
    });

    try {
      await localizacao.pegaLocalizacaoAtual();

      final url =
          'https://api.open-meteo.com/v1/forecast?latitude=${localizacao.latitude}&longitude=${localizacao.longitude}&current=temperature_2m,relative_humidity_2m,wind_speed_10m';

      final resposta = await http.get(Uri.parse(url));

      if (resposta.statusCode == 200) {
        final dados = json.decode(resposta.body);
        clima = Clima.fromJson(dados);
      } else {
        erro = 'Erro ao obter dados do clima: ${resposta.statusCode}';
      }
    } catch (e) {
      erro = 'Erro: $e';
    }

    setState(() {
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Clima Atual')),
        body: Center(
          child: carregando
              ? const CircularProgressIndicator()
              : erro.isNotEmpty
                  ? Text(erro, style: const TextStyle(color: Colors.red))
                  : clima == null
                      ? const Text('Sem dados disponíveis')
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '🌡 Temperatura: ${clima!.temperatura.toStringAsFixed(1)} °C',
                              style: const TextStyle(fontSize: 22),
                            ),
                            Text(
                              '💧 Umidade: ${clima!.umidade.toStringAsFixed(0)}%',
                              style: const TextStyle(fontSize: 22),
                            ),
                            Text(
                              '💨 Vento: ${clima!.velocidadeVento.toStringAsFixed(1)} m/s',
                              style: const TextStyle(fontSize: 22),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: obterDadosClima,
                              child: const Text('Atualizar'),
                            ),
                          ],
                        ),
        ),
      ),
    );
  }
}
