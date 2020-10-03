import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'model/timer.dart';

import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MultiTimer.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;
  final String timerTable = 'timer';
  final String columnId = 'id';
  final String name = 'name';
  final String time = 'time';

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $timerTable (
                $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
                $name TEXT NOT NULL,
                $time INTEGER NOT NULL
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(MyTimer t) async {
    Database db = await database;
    int id = await db.insert(timerTable,
        t.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<List<MyTimer>> getAllTimers() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query(timerTable);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return MyTimer(
        id: maps[i][columnId],
        name: maps[i][name],
        time: maps[i][time],
      );
    });
  }

  Future<int> getNumberOfTimer() async{
    Database db = await database;
    int result =  Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT($columnId) FROM $timerTable"));
    print(result);
    return result;
  }

  Future<MyTimer> getTimer(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(timerTable,
        columns: [columnId, name, time],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return MyTimer(
          name: maps.first[name],
          time: maps.first[time],
      );
    }
    return null;
  }

  Future<void> deleteTimer(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      timerTable,
      // Use a `where` clause to delete a specific dog.
      where: "$columnId = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> updateTimer(MyTimer t) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      timerTable,
      t.toMap(),
      // Ensure that the Dog has a matching id.
      where: "$columnId = ?",
      whereArgs: [t.id],
    );
  }

}