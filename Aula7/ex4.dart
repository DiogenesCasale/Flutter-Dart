import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AgeCalculatorData extends ChangeNotifier {
  DateTime? _birthDate;

  AgeCalculatorData() : _birthDate = null;

  DateTime? get birthDate => _birthDate;

  void setBirthDate(DateTime date) {
    if (_birthDate != date) {
      _birthDate = date;
      notifyListeners();
    }
  }

  int? get age {
    if (_birthDate == null) {
      return null;
    }

    final DateTime now = DateTime.now();
    int calculatedAge = now.year - _birthDate!.year;

    if (now.month < _birthDate!.month ||
        (now.month == _birthDate!.month && now.day < _birthDate!.day)) {
      calculatedAge--;
    }
    return calculatedAge;
  }

  String get formattedBirthDate {
    if (_birthDate == null) {
      return 'Nenhuma data selecionada';
    }
    return '${_birthDate!.day.toString().padLeft(2, '0')}/${_birthDate!.month.toString().padLeft(2, '0')}/${_birthDate!.year}';
  }
}

class AgeCalculatorApp extends StatelessWidget {
  const AgeCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AgeCalculatorData>(
      create: (BuildContext context) => AgeCalculatorData(),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'Calculadora de Idade',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
                .copyWith(secondary: Colors.lightBlueAccent),
            textTheme: const TextTheme(
              titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              headlineSmall:
                  TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              displayLarge:
                  TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              titleMedium: TextStyle(fontSize: 18),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          home: const AgeCalculatorScreen(),
        );
      },
    );
  }
}

class AgeCalculatorScreen extends StatelessWidget {
  const AgeCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AgeCalculatorData ageData = context.watch<AgeCalculatorData>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Idade'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Data de Nascimento:',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                ageData.formattedBirthDate,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: ageData.birthDate == null
                          ? Colors.grey.shade600
                          : Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: ageData.birthDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    helpText: 'Selecione sua data de nascimento',
                    cancelText: 'Cancelar',
                    confirmText: 'Confirmar',
                    fieldLabelText: 'Data de Nascimento',
                    errorFormatText: 'Formato de data inválido.',
                    errorInvalidText: 'Data inserida é inválida.',
                  );

                  if (pickedDate != null) {
                    context.read<AgeCalculatorData>().setBirthDate(pickedDate);
                  }
                },
                icon: const Icon(Icons.calendar_today, size: 24),
                label: const Text('Selecionar Data de Nascimento',
                    style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 60),
              if (ageData.age != null)
                Column(
                  children: <Widget>[
                    Text(
                      'Sua idade é:',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${ageData.age} anos',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              else
                Text(
                  'Por favor, selecione sua data de nascimento para calcular a idade.',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const AgeCalculatorApp());
}
