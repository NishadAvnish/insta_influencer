import 'package:instsinfu/Models/profile_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import "package:path/path.dart";
import 'dart:async';
import 'dart:io';

class DatabaseHelper {
  static Database _database;

  String instaTable_1 = 'InstaInflucerTable_1';
  String instaTable_2 = 'InstaInflucerTable_2';
  String instaTable_3 = 'InstaInflucerTable_3';

  String colUserid = 'userid';
  String colUserProfilelink = 'userProfilelink';
  String colEmail = 'email';
  String colEngrate = 'engrate';
  String colCategory = 'category';
  String colAvgLike = 'avgLike';
  String colUserName = "userName";
  String colRating = "rating";
  bool isConvrtCSV = true;

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
        'CREATE TABLE $instaTable_1($colUserid TEXT PRIMARY KEY, $colUserName TEXT, $colUserProfilelink TEXT, $colEmail TEXT, $colEngrate TEXT , $colCategory TEXT , $colAvgLike TEXT, $colRating Text)');
    db.execute(
        'CREATE TABLE $instaTable_2($colUserid TEXT PRIMARY KEY, $colUserName TEXT, $colUserProfilelink TEXT, $colEmail TEXT, $colEngrate TEXT , $colCategory TEXT , $colAvgLike TEXT, $colRating Text)');
    db.execute(
        'CREATE TABLE $instaTable_3($colUserid TEXT PRIMARY KEY, $colUserName TEXT, $colUserProfilelink TEXT, $colEmail TEXT, $colEngrate TEXT , $colCategory TEXT , $colAvgLike TEXT, $colRating Text)');
  }

  Future<List<ProfileModel>> getTrans({int rating}) async {
    var dbClient = await database;
    String instaTable;
    if (rating == 1) {
      instaTable = instaTable_1;
    } else if (rating == 2) {
      instaTable = instaTable_2;
    } else
      instaTable = instaTable_3;

    final List<Map<String, dynamic>> maps = await dbClient.query(instaTable);
    return List.generate(maps.length, (i) {
      return ProfileModel(
          userName: maps[i]["userName"],
          userid: maps[i]["userid"].toString(),
          userProfilelink: maps[i]["userProfilelink"],
          email: maps[i]["email"],
          category: maps[i]["category"],
          engrate: maps[i]["engrate"].toString(),
          avgLike: maps[i]["avgLike"].toString(),
          rating: maps[i]["rating"].toString());
    });
  }

  Future<List<List<String>>> getTransCSV({int rating}) async {
    var dbClient = await database;
    String instaTable;
    if (rating == 1) {
      instaTable = instaTable_1;
    } else if (rating == 2) {
      instaTable = instaTable_2;
    } else
      instaTable = instaTable_3;

    final List<Map<String, dynamic>> maps = await dbClient.query(instaTable);
    return List.generate(maps.length, (i) {
      return [
        maps[i]["userName"],
        maps[i]["userid"].toString(),
        maps[i]["userProfilelink"],
        maps[i]["email"],
        maps[i]["category"],
        maps[i]["engrate"].toString(),
        maps[i]["avgLike"].toString(),
        maps[i]["rating"].toString(),
      ];
    });
  }

  Future<bool> isPresent(String userId, String instaTable) async {
    var dbClient = await database;
    final List<Map<String, dynamic>> maps = await dbClient
        .rawQuery("SELECT * FROM $instaTable WHERE $colUserid = $userId");
    if (maps.length > 0) {
      return true;
    } else
      return false;
  }

  Future<void> addTransToDatabase(Map<String, dynamic> transaction) async {
    var dbClient = await database;
    String instaTable;
    if (transaction["rating"] == 1) {
      instaTable = instaTable_1;
    } else if (transaction["rating"] == 2) {
      instaTable = instaTable_2;
    } else
      instaTable = instaTable_3;
    final bool _isPresent = await isPresent(transaction["userid"], instaTable);
    if (!_isPresent) {
      await dbClient.insert(instaTable, transaction);
    }
  }

  Future<void> delete({String userId, int rating}) async {
    var dbClient = await database;
    String instaTable;
    if (rating == 1) {
      instaTable = instaTable_1;
    } else if (rating == 2) {
      instaTable = instaTable_2;
    } else
      instaTable = instaTable_3;
    return await dbClient.delete(
      instaTable,
      where: '$colUserid = ?',
      whereArgs: [userId],
    );
  }

  Future close() async {
    var dbClient = await database;
    dbClient.close();
  }
}
