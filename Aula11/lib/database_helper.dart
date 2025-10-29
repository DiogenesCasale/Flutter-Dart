import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('calculadora.db');
    return _database!;
  }

  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final fullPath = join(dbPath, path);
    return openDatabase(fullPath, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE dados (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tela TEXT,
        memoria TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE operacoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        operacao TEXT,
        resultado TEXT,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
      );
    ''');
  }

  Future<void> salvarDados(String tela, String memoria) async {
    final db = await instance.database;
    await db.insert('dados', {'tela': tela, 'memoria': memoria});
  }

  Future<void> salvarOperacao(String operacao, String resultado) async {
    final db = await instance.database;
    await db.insert('operacoes', {
      'operacao': operacao,
      'resultado': resultado,
    });
  }

  Future<List<Map<String, dynamic>>> getOperacoes() async {
    final db = await instance.database;
    return db.query('operacoes', orderBy: 'timestamp DESC');
  }

  Future<List<Map<String, dynamic>>> getDados() async {
    final db = await instance.database;
    return db.query('dados');
  }

  Future<void> limparHistorico() async {
    final db = await instance.database;
    await db.delete('operacoes');
  }
}
