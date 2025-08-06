class Aluno {
  String nome;
  String matricula;
  List<double> notas;

  Aluno(this.nome, this.matricula) : notas = [];

  void lancaNota(double nota) {
    this.notas += [nota];
  }
}

void main() {
  Aluno mauro = Aluno('Fulano de Tal', '123456');
  mauro.lancaNota(6.3);
  mauro.lancaNota(5.2);
  mauro.lancaNota(9.4);
  print(mauro.notas);
}
