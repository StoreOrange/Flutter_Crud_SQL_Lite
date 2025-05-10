import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_firebase/Models/dish.dart';
import 'package:path_provider/path_provider.dart';  
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('dishes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Solo para desarrollo: eliminar DB anterior
    await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE dishes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        price REAL NOT NULL
      )
    ''');
  }

  Future<Dish> create(Dish dish) async {
    final db = await instance.database;
    final id = await db.insert('dishes', dish.toMap());
    return dish.copyWith(id: id);
  }

  Future<List<Dish>> readAll() async {
    final db = await instance.database;
    final result = await db.query('dishes');
    return result.map((map) => Dish.fromMap(map)).toList();
  }

  Future<int> update(Dish dish) async {
    final db = await instance.database;
    return db.update(
      'dishes',
      dish.toMap(),
      where: 'id = ?',
      whereArgs: [dish.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return db.delete(
      'dishes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
