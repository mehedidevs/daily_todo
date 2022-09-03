import 'package:daily_todo/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = "taskTable";

  static Future<void> initDB() async {
    if (_db != null) {
      return;
    } else {
      try {
        String path = await getDatabasesPath() + 'task.db';
        _db = await openDatabase(path, version: _version,
            onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE $_tableName ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, "
            "note TEXT, "
            "date STRING, "
            "startTime STRING, "
            "endTime STRING, "
            "remind INTEGER, "
            "repeat STRING, "
            "color INTEGER, "
            "isCompleted INTEGER)",
          );
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  static Future<int> insert(Task? task) async {
    return await _db?.insert(_tableName, task!.toJson()) ?? -1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(_tableName);
  }

  static delete(Task task) async {
    return await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static update(Task task) async {
    return await _db!.rawUpdate(
        'UPDATE $_tableName SET isCompleted =?  WHERE id =?', [1, task.id]);
  }
}
