void main() {
  
  int informado = 8;
  int atual = DateTime.now().month;

  if (atual < informado) {
    print('$atual é menor que $informado!');
  } else if (atual > informado) {
    print('$atual é maior que $informado!');
  } else {
    print('Os meses são iguais!');
  }
}