import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:starwarsapp/models/savepeople_model.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the People table
  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'savedpeople.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE SavedPeople('
          'idAI INTEGER PRIMARY KEY AUTOINCREMENT,'
          'name TEXT,'
          'height TEXT,'
          'mass TEXT,'
          'hair_color TEXT,'
          'skin_color TEXT,'
          'eye_color TEXT,'
          'birth_year TEXT,'
          'gender TEXT,'
          'homeworld TEXT,'
          'films TEXT,'
          'species TEXT,'
          'vehicles TEXT,'
          'starships TEXT,'
          'created TEXT,'
          'edited TEXT,'
          'url TEXT,'
          'saved TEXT'
          ')');
    });
  }

  //UPDATE TO SAVED
  Future<int> updateToSaved(int idAI) async {
    Database db = await this.database;
    int count = await db.rawUpdate(
        'UPDATE SavedPeople SET saved = ? WHERE idAI = ?', ['true', idAI]);
    return count;
  }

  //UPDATE TO UNSAVED
  Future<int> updateToUnSaved(int idAI) async {
    Database db = await this.database;
    int count = await db.rawUpdate(
        'UPDATE SavedPeople SET saved = ? WHERE idAI = ?', ['false', idAI]);
    return count;
  }

  // Insert People on database
  Future<int> insertOneData(Result newPeople) async {
    // await deleteAllPeoples();
    final db = await database;
    final res = await db.insert('SavedPeople', newPeople.toJson());

    return res;
  }

  Future<int> insertManyData(List<Result> listPeople) async {
    final db = await database;
    int res = 0;
    listPeople.forEach((element) async {
      Result people = element;
      res += await insertOneData(people);
    });
    return res;
  }

  // Delete all Peoples
  Future<int> deleteAllPeoples() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM SavedPeople');

    return res;
  }

  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.database;
    var mapList = await db.query('SavedPeople', orderBy: 'name');
    return mapList;
  }

  Future<List<Map<String, dynamic>>> selectSaved() async {
    Database db = await this.database;
    var mapList = await db.query('SavedPeople',
        orderBy: 'name', where: 'saved=?', whereArgs: ["true"]);
    return mapList;
  }

  Future<int> delete(int id) async {
    Database db = await this.database;
    int count =
        await db.delete('SavedPeople', where: 'idAI=?', whereArgs: [id]);
    return count;
  }

  Future<List<Result>> getAllPeoples() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM SavedPeople");

    var contactMapList = await select();

    int count = contactMapList.length;
    List<Result> contactList = List<Result>();
    for (int i = 0; i < count; i++) {
      contactList.add(Result.fromJson(contactMapList[i]));
    }
    return contactList;
  }

  Future<List<Result>> getSavedData() async {
    var contactMapList = await selectSaved();

    int count = contactMapList.length;
    List<Result> contactList = List<Result>();
    for (int i = 0; i < count; i++) {
      contactList.add(Result.fromJson(contactMapList[i]));
    }
    return contactList;
  }
}
