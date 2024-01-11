import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'your_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id STRING,
        name TEXT,
        status TEXT,
        completed INTEGER,
        owner TEXT
      )
    ''');
  }

  Future<List<TaskModel>> getTasks(String owner) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('tasks', where: 'owner = ?', whereArgs: [owner]);
    return List.generate(maps.length, (i) => TaskModel.fromJson(maps[i]));
  }

  Future<TaskModel?> getTask(int id, String owner) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db
        .query('tasks', where: 'id = ? AND owner = ?', whereArgs: [id, owner]);

    if (maps.isNotEmpty) {
      return TaskModel.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<TaskModel> addTask(TaskModel task) async {
    final Database db = await database;

    // Temporarily change the id type to int
    int insertedId = await db.insert('tasks', task.toMap());

    task.id = insertedId.toString();

    return task;
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    final Database db = await database;
    await db.update('tasks', task.toMap(),
        where: 'id = ? AND owner = ?', whereArgs: [task.id, task.owner]);
    return task;
  }

  Future<void> deleteTask(int id, String owner) async {
    final Database db = await database;
    await db
        .delete('tasks', where: 'id = ? AND owner = ?', whereArgs: [id, owner]);
  }
}
