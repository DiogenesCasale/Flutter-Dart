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
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2C2F36),
          labelStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _controller = TextEditingController();

  String? temperature;
  String? humidity;
  String? wind;
  String? errorMessage;

  Future<Map<String, dynamic>?> _getCoordinates(String city) async {
    final url =
        "https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1&language=en&format=json";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["results"] != null && data["results"].isNotEmpty) {
        final result = data["results"][0];
        return {"lat": result["latitude"], "lon": result["longitude"]};
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> _getWeather(double lat, double lon) async {
    final url =
        "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true&hourly=relativehumidity_2m";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return {
        "temperature": data["current_weather"]["temperature"],
        "humidity": data["hourly"]["relativehumidity_2m"][0],
        "wind": data["current_weather"]["windspeed"],
      };
    }
    return null;
  }

  Future<void> _searchWeather() async {
    setState(() {
      errorMessage = null;
      temperature = humidity = wind = null;
    });

    final city = _controller.text.trim();
    if (city.isEmpty) {
      setState(() => errorMessage = "Digite o nome de uma cidade.");
      return;
    }

    final coords = await _getCoordinates(city);
    if (coords == null) {
      setState(() => errorMessage = "Cidade não encontrada.");
      return;
    }

    final weather = await _getWeather(coords["lat"], coords["lon"]);
    if (weather == null) {
      setState(() => errorMessage = "Não foi possível obter as informações.");
      return;
    }

    setState(() {
      temperature = weather["temperature"].toString();
      humidity = weather["humidity"].toString();
      wind = weather["wind"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🌤️ Busca de Clima"),
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
                labelText: "Nome da cidade",
                prefixIcon: Icon(Icons.location_city, color: Colors.white70),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _searchWeather,
              child: const Text("Buscar"),
            ),

            const SizedBox(height: 30),

            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 18),
              ),

            if (temperature != null) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2F36),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      "🌡️ Temperatura: $temperature °C",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "💧 Umidade: $humidity %",
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "🌬️ Vento: $wind km/h",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
