import 'package:flutter/material.dart';
import 'database_helper.dart';

class CalculadoraModel extends ChangeNotifier {
  double valor1 = 0.0;
  String operacao = '';
  String _tela = '0';
  String _memoria = '0';

  String get tela => _tela;
  String get memoria => _memoria;

  // ======= Funções de memória =======
  void salvarMemoria() {
    _memoria = _tela;
    _salvarDadosNoBanco();
    notifyListeners();
  }

  void lerMemoria() {
    _tela = _memoria;
    notifyListeners();
  }

  void limparMemoria() {
    _memoria = '0';
    _salvarDadosNoBanco();
    notifyListeners();
  }

  // ======= Operações =======
  void concat(String valor) {
    if (_tela != '0') {
      _tela = _tela + valor;
    } else {
      _tela = valor;
    }
    notifyListeners();
  }

  void setoperacao(String valor) {
    operacao = valor;
    valor1 = double.tryParse(_tela) ?? 0.0;
    _tela = '0';
    notifyListeners();
  }

  void calcular() async {
    try {
      double valor2 = double.tryParse(_tela) ?? 0.0;
      double resultado = valor1;
      String expressao = '';

      switch (operacao) {
        case '+':
          resultado = valor1 + valor2;
          expressao = '$valor1 + $valor2';
          break;
        case '-':
          resultado = valor1 - valor2;
          expressao = '$valor1 - $valor2';
          break;
        case '*':
          resultado = valor1 * valor2;
          expressao = '$valor1 * $valor2';
          break;
        case '/':
          if (valor2 == 0) {
            _tela = 'Erro';
            notifyListeners();
            return;
          }
          resultado = valor1 / valor2;
          expressao = '$valor1 / $valor2';
          break;
        default:
          return;
      }

      _tela = resultado.toStringAsFixed(2);
      valor1 = resultado;
      operacao = '';

      // Salvar no banco de dados
      await DatabaseHelper.instance.salvarOperacao(expressao, _tela);
      await _salvarDadosNoBanco();
    } catch (e) {
      _tela = 'Erro';
    }
    notifyListeners();
  }

  // ======= Banco de Dados =======
  Future<void> _salvarDadosNoBanco() async {
    await DatabaseHelper.instance.salvarDados(_tela, _memoria);
  }

  Future<void> carregarDados() async {
    final dados = await DatabaseHelper.instance.getDados();
    if (dados.isNotEmpty) {
      final ultimo = dados.last;
      _tela = ultimo['tela'] ?? '0';
      _memoria = ultimo['memoria'] ?? '0';
      notifyListeners();
    }
  }
}
