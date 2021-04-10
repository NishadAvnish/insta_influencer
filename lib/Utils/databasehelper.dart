import 'package:instsinfu/Models/profile_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import "package:path/path.dart";
import 'dart:async';
import 'dart:io';

class DatabaseHelper {
  static Database _database;

  String instaTable = 'InstaInflucerTable';
  String colUserid = 'userid';
  String colUserProfilelink = 'userProfilelink';
  String colEmail = 'email';
  String colEngrate = 'engrate';
  String colCategory = 'category';
  String colAvgLike = 'avgLike';
  String colUserName = "userName";
  // String colCurrentNo = "currentNo";

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    String path = join(directory.path, "Insta_Influncer.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int vesion) async {
    db.execute(
        'CREATE TABLE $instaTable($colUserid TEXT PRIMARY KEY, $colUserName TEXT, $colUserProfilelink TEXT, $colEmail TEXT, $colEngrate TEXT , $colCategory TEXT , $colAvgLike TEXT, )');
  }

  Future<List<ProfileModel>> getTrans() async {
    var dbClient = await database;
    final List<Map<String, dynamic>> maps = await dbClient.query(instaTable);
    return List.generate(maps.length, (i) {
      return ProfileModel(
        userName: maps[i]["userName"],
        userid: maps[i]["userId"].toString(),
        userProfilelink: maps[i]["userProfile"],
        email: maps[i]["email"],
        category: maps[i]["category"],
        engrate: maps[i]["engRate"].toString(),
        avgLike: maps[i]["avgLikes"].toString(),
      );
    });
  }

  Future<bool> isPresent(ProfileModel transaction) async {
    var dbClient = await database;
    final List<Map<String, dynamic>> maps = await dbClient.rawQuery(
        "SELECT * FROM $instaTable WHERE $colUserid = '${transaction.userid}'");
    if (maps.length > 0) {
      return true;
    } else
      return false;
  }

  Future<void> addTransToDatabase(ProfileModel transaction) async {
    var dbClient = await database;
    //  await dbClient.insert(instaTable, transaction.toMap());
    final bool _isPresent = await isPresent(transaction);
    if (!_isPresent) {
      await dbClient.insert(
        instaTable,
        transaction.toMap(),
      );
    }
  }

  Future close() async {
    var dbClient = await database;
    dbClient.close();
  }
}
