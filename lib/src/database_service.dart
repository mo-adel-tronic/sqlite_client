import 'package:sqflite/sqflite.dart';
import 'base_model.dart';

class DatabaseService<T extends BaseModel> {
  final Database db;

  DatabaseService(this.db);

  Future<int> insert(T model) async {
    return await db.insert(model.tableName, model.toMap());
  }

  Future<int> update(T model) async {
    return await db.update(
      model.tableName,
      model.toMap(),
      where: '${model.primaryKey} = ?',
      whereArgs: [model.toMap()[model.primaryKey]],
    );
  }

  Future<int> delete(T model) async {
    return await db.delete(
      model.tableName,
      where: '${model.primaryKey} = ?',
      whereArgs: [model.toMap()[model.primaryKey]],
    );
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    return await db.query(table);
  }

  Future<Map<String, dynamic>?> queryById(String table, String idKey, dynamic id) async {
    final result = await db.query(table, where: '$idKey = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }
}