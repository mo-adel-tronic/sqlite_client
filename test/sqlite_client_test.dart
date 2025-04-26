import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite_client/sqlite_client.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Sample User model implementing BaseModel
class User extends BaseModel {
  final int id;
  final String name;

  User({required this.id, required this.name});

  @override
  String get tableName => 'users';

  @override
  String get primaryKey => 'id';

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  late Database db;
  late DatabaseService<User> userService;

  setUpAll(() async {
    db = await databaseFactory.openDatabase(inMemoryDatabasePath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute(
              'CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT)',
            );
          },
        ));

    userService = DatabaseService<User>(db);
  });

  test('Insert user into database', () async {
    final user = User(id: 1, name: 'Alice');
    final result = await userService.insert(user);
    expect(result, isNonZero);
  });

  test('Query all users', () async {
    final users = await userService.queryAll('users');
    expect(users.length, greaterThanOrEqualTo(1));
    expect(users.first['name'], 'Alice');
  });

  test('Update user', () async {
    final updatedUser = User(id: 1, name: 'Alice Updated');
    final result = await userService.update(updatedUser);
    expect(result, 1);

    final updated = await userService.queryById('users', 'id', 1);
    expect(updated?['name'], 'Alice Updated');
  });

  test('Delete user', () async {
    final user = User(id: 1, name: 'Alice Updated');
    final result = await userService.delete(user);
    expect(result, 1);

    final deleted = await userService.queryById('users', 'id', 1);
    expect(deleted, isNull);
  });

  tearDownAll(() async {
    await db.close();
  });
}
