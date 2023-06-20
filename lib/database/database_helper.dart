import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:todo_list_app/models/user.dart';
import 'package:todo_list_app/models/user_task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init() {
    sqfliteFfiInit();
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('todo.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    final bool isDatabaseExists = await databaseExists(path);
    if (!isDatabaseExists) {
      // If the database doesn't exist, copy it from the assets folder
      ByteData data = await rootBundle.load(join("assets", "todo.db"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }

    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        email TEXT,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        title TEXT,
        description TEXT,
        isDone INTEGER
      )
    ''');
  }

  Future<List<UserTask>> getUserTasks() async {
    final db = await instance.database;

    final maps = await db.query('user_tasks');
    return List.generate(maps.length, (index) {
      return UserTask.fromMap(maps[index]);
    });
  }

  Future<UserTask> insertUserTask(UserTask userTask) async {
    final db = await instance.database;
    final id = await db.insert('user_tasks', userTask.toMapWithoutId()); // Exclude the 'id' column
    return UserTask(
      id: id,
      userId: userTask.userId,
      title: userTask.title,
      description: userTask.description,
      isDone: userTask.isDone,
    );
  }

  Future<void> updateUserTask(UserTask userTask) async {
    final db = await instance.database;
    await db.update(
      'user_tasks',
      userTask.toMap(),
      where: 'id = ?',
      whereArgs: [userTask.id],
    );
  }

  Future<void> deleteUserTask(int id) async {
    final db = await instance.database;
    await db.delete(
      'user_tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<User?> authenticateUser(String username, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }

    return null;
  }

  Future<User> insertUser(User user) async {
    final db = await instance.database;
    final id = await db.insert('users', user.toMap());
    return User(
      id: id,
      username: user.username,
      email: user.email,
      password: user.password,
    );
  }
}
