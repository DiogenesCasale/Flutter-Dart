class Aluno {
  String nome;
  String matricula;
  List<double> notas;

  Aluno(this.nome, this.matricula) : notas = [];
}

void main() {
  Aluno mauro = Aluno('Fulano de Tal', '123456');
}
