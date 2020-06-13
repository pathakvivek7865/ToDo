import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import '../models/todo.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  String tableTodo = "todo";
  String columnId = "id";
  String columnTitle = "title";
  String columnPriority = "priority";
  String columnDate = "date";
  String columnIsDone = "isDone";

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initializeDb();
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "todo.db");

    var ourDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return ourDb;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute("CREATE TABLE $tableTodo(" +
        "$columnId INTEGER PRIMARY KEY AUTOINCREMENT, " +
        "$columnTitle TEXT NOT NULL," +
        "$columnPriority INTEGER NOT NULL," +
        "$columnDate TEXT NOT NULL," +
        "$columnIsDone INTEGER NOT NULL);");
  }

  Future<int> insertTodo(Todo todo) async {
    Database database = await this.db;
    var result = await database.insert(tableTodo, todo.toMap());
    return result;
  }

  Future<List> getTodos() async {
    Database database = await this.db;
    var result = await database.rawQuery(
        "SELECT * FROM $tableTodo " + "ORDER BY $columnPriority ASC;");
    return result;
  }

  Future<int> deleteTodo(int id) async {
    Database database = await this.db;
    return await database
        .rawDelete("DELETE FROM $tableTodo WHERE $columnId = $id;");
  }

  Future<int> updateTodo(Todo todo) async {
    Database database = await this.db;
    return await database.update(tableTodo, todo.toMap(),
        where: "$columnId = ?", whereArgs: [todo.id]);
  }
}
