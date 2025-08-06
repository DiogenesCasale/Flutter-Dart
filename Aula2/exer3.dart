class Aluno {
  String nome;
  String matricula;
  List<double> notas;

  Aluno(this.nome, this.matricula) : notas = [];

  void lancaNota(double nota) {
    this.notas = [nota];
  }
}

void main() {
  Aluno mauro = Aluno('Fulano de Tal', '123456');
  double notaNova = 5.5;
  mauro.lancaNota(notaNova);
  print(mauro.notas);
}
