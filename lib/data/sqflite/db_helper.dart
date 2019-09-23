import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static DbHelper _instance;

  factory DbHelper() {
    if (_instance == null) {
      _instance = DbHelper._internal();
    }
    return _instance;
  }

  DbHelper._internal();

  final String dbName = "cooking.db";
  final String createDb =
      "CREATE TABLE recipe (id TEXT PRIMARY KEY, name TEXT, time INTEGER, level TEXT, serving INTEGER, img TEXT, total_component INTEGER, total_step INTEGER)";

  Database db;

  Future<Database> open() async {
    if (db == null) {
      var dbPath = await getDatabasesPath();
      String path = join(dbPath, dbName);

      db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute(createDb);
      });
    }

    return db;
  }

  Future<void> close() async {
    if (db != null) {
      db.close();
    }
  }

  Future<void> delete() async {
    if (db != null) {
      var dbPath = await getDatabasesPath();
      String path = join(dbPath, dbName);

      deleteDatabase(path);
    }
  }
}
