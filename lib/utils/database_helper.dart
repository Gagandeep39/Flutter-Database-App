import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'models/user.dart';

///Created on Android Studio Canary Version
///User: Gagandeep
///Date: 04-05-2019
///Time: 21:23
///Project Name: flutter_database_app

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;
  final String tableUser = "userTable";
  final columnId = "id";
  final columnUsername = "username";
  final columnPassword = "password";
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "maindb.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  } //named constructor

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tableUser ($columnId INTEGER PRIMARY KEY, $columnUsername TEXT, $columnPassword TEXT)");
  }

  //Insertion
  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int result = await dbClient.insert(tableUser, user.toMap());
    return result;
  }

  //Get User
  Future<List> getAllUsers() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableUser");
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT COUNT (*) FROM $tableUser");
    return Sqflite.firstIntValue(result);
  }

  Future<User> getUser(int id) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableUser WHERE $columnId = $id");
    if (result.length == 0) return null;
    return User.fromMap(result.first);
  }

  Future<int> deleteUser(int id) async {
    var dbClient = await db;
    var result = await dbClient
        .delete(tableUser, where: "$columnId = ?", whereArgs: [id]);
    return result;
  }

  Future<int> updateUser(User user) async {
    var dbClient = await db;
    var result = await dbClient.update(tableUser, user.toMap(),
        where: "$columnId = ?", whereArgs: [user.id]);
    return result;
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
