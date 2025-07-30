import 'dart:core';

void main() {

  final DateTime now = DateTime.now();
  int diaAtual = now.day;
  final DateTime primeiroDia = DateTime(now.year, now.month, 1);

  final int inicio = primeiroDia.weekday % 7;

  print('| D | S | T | Q | Q | S | S |');

  String linha = '|';

  for (int i = 0; i < inicio; i++) {
    linha += '   |'; 
  }

  for (int i = 1; i <= diaAtual; i++) {
   
    final String formatado = i.toString().padLeft(2);

   
    linha += ' $formatado|'; 

    
    if ((inicio + i) % 7 == 0) {
      print(linha); 
      linha = '|'; 
    }
  }

  
  if (linha != '|') {
    print(linha);
  }
}