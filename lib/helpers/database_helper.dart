// lib/helpers/database_helper.dart

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../models/filme.dart'; // Importe seu modelo

class DatabaseHelper {
  // Padrão Singleton: garante que teremos apenas uma instância do banco de dados
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Inicializa o banco de dados
  Future<Database> _initDB() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'filmes_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Cria a tabela de filmes quando o banco de dados é criado pela primeira vez
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE filmes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        year TEXT,
        isWatched INTEGER NOT NULL
      )
    ''');
  }

  // --- Funções CRUD (Create, Read, Update, Delete) ---

  // LER TODOS OS FILMES
  Future<List<Filme>> getFilmes() async {
    final db = await instance.database;
    final maps = await db.query('filmes', orderBy: 'id DESC'); // Ordena pelos mais recentes
    return List.generate(maps.length, (i) {
      return Filme.fromMap(maps[i]);
    });
  }

  // ADICIONAR UM NOVO FILME
  Future<int> addFilme(Filme filme) async {
    final db = await instance.database;
    return await db.insert('filmes', filme.toMap());
  }

  // ATUALIZAR UM FILME
  Future<int> updateFilme(Filme filme) async {
    final db = await instance.database;
    return await db.update(
      'filmes',
      filme.toMap(),
      where: 'id = ?',
      whereArgs: [filme.id],
    );
  }
  
  // DELETAR UM FILME
  Future<int> deleteFilme(int id) async {
    final db = await instance.database;
    return await db.delete(
      'filmes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}