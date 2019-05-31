import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_doomo/Model/User.dart';

import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Doomo.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE User ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "birthPlace TEXT,"
          "birthDate TEXT,"
          "username TEXT UNIQUE,"
          "password TEXT"
          ")");
    });
  }

  newUser(User newUser) async {
    final db = await database;
    print(db);

    var checkData = await db
        .query("User", where: "username = ?", whereArgs: [newUser.username]);

    if (checkData.length > 0) {
      return 400;
    } else {
      var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM User");
      print(table);

      int id = table.first["id"];
      print('idnya adalah: ' + id.toString());

      var raw = await db.rawInsert(
          "INSERT INTO User (id, name, birthPlace, birthDate, username, password) VALUES (?,?,?,?,?,?)",
          [
            id,
            newUser.name,
            newUser.birthPlace,
            newUser.birthDate,
            newUser.username,
            generateMd5(newUser.password)
          ]);
      return 200;
    }
  }

  Future<List<User>> getAllUser() async {
    final db = await database;
    var res = await db.query("User");
    List<User> userList =
        res.isNotEmpty ? res.map((v) => User.fromMap(v)).toList() : [];
    return userList;
  }

  getUser(int id) async {
    final db = await database;
    var res = await db.query("User", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? User.fromMap(res.first) : null;
  }

  deleteUser(int id) async {
    final db = await database;
    return db.delete("User", where: "id = ?", whereArgs: [id]);
  }

  updateUser(User user) async {
    final db = await database;
    var res = await db.update("User", user.toMap(), where: "id = ?", whereArgs: [user.id]);
    print(res);
  }

  String generateMd5(String input) {
    return crypto.md5.convert(utf8.encode(input)).toString();
  }

  Future<User> loginUser(String username, String password) async {
    final db = await database;
    final encryptedPassword = generateMd5(password);


    var res = await db.rawQuery("SELECT * FROM User WHERE username = '" +
        username +
        "' AND password = '" +
        encryptedPassword +
        "'");
    if (res.length > 0) {
      return User.fromMap(res[0]);
    } else {
      return null;
    }
  }
}
