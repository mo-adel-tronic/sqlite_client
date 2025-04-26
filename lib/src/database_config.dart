import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConfig {
  static Future<Database> init(String dbName, List<String> createTableQueries) async {
    final path = join(await getDatabasesPath(), dbName);
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        for (final query in createTableQueries) {
          await db.execute(query);
        }
      },
    );
  }
}