import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'calculadora_model.dart';
import 'calculadora_screen.dart';
import 'historico_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa SQLite para Desktop
  if (!kIsWeb) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  // Para Web, não precisa fazer nada extra
  // O sqflite funciona normalmente no Web com a versão atual

  runApp(
    ChangeNotifierProvider(
      create: (_) => CalculadoraModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora com Banco de Dados',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => CalculadoraScreen(),
        '/historico': (context) => HistoricoScreen(),
      },
    );
  }
}
