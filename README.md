# 📦 sqlite_client

A professional, reusable, and flexible SQLite wrapper for Flutter using `sqflite`.  
This package provides a clean structure and testable service for SQLite operations using generics and base models.

---

## 🚀 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  sqlite_client:
    git:
      url: https://github.com/your-username/sqlite_client.git
      ref: main
dev_dependencies:
  flutter_test:
    sdk: flutter
  sqflite_common_ffi: ^2.3.0
```

---

## ✨ Features

✅ Generic DatabaseService&lt;T&gt; for CRUD

✅ DatabaseConfig for easy DB initialization

✅ BaseModel abstract class for your models

✅ Works with all model types

✅ Testable using sqflite_common_ffi

✅ Clean, reusable, and maintainable

---

## 📦 Usage Example

### 1. Define your model

```dart
import 'package:sqlite_client/sqlite_client.dart';

class User extends BaseModel {
  final int id;
  final String name;

  User({required this.id, required this.name});

  @override
  String get tableName => 'users';

  @override
  String get primaryKey => 'id';

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
    );
  }
}
```

---

### 2. Initialize your database

```dart
final db = await DatabaseConfig.init('app.db', [
  'CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT)',
]);

final userService = DatabaseService<User>(db);
```

---

### 3. Perform CRUD

```dart
await userService.insert(User(id: 1, name: 'Alice'));

final users = await userService.queryAll('users');
print(users);

await userService.update(User(id: 1, name: 'Alice Updated'));

await userService.delete(User(id: 1, name: 'Alice Updated'));
```

---

## 🧪 Unit Test Example

> 📍 Use sqflite_common_ffi to run tests on desktop/CI without device.

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite_client/sqlite_client.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

class User extends BaseModel {
  final int id;
  final String name;

  User({required this.id, required this.name});

  @override
  String get tableName => 'users';

  @override
  String get primaryKey => 'id';

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };

  factory User.fromMap(Map<String, dynamic> map) =>
      User(id: map['id'], name: map['name']);
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

  test('Insert and query user', () async {
    await userService.insert(User(id: 1, name: 'Alice'));
    final result = await userService.queryAll('users');
    expect(result.first['name'], equals('Alice'));
  });

  test('Update user', () async {
    await userService.update(User(id: 1, name: 'Alice Smith'));
    final updated = await userService.queryById('users', 'id', 1);
    expect(updated?['name'], equals('Alice Smith'));
  });

  test('Delete user', () async {
    await userService.delete(User(id: 1, name: 'Alice Smith'));
    final deleted = await userService.queryById('users', 'id', 1);
    expect(deleted, isNull);
  });

  tearDownAll(() async {
    await db.close();
  });
}
```

---

## 🧱 Project Structure

```bash
lib/
├── sqlite_client.dart        # Entry point
└── src/
    ├── base_model.dart       # Model interface
    ├── database_config.dart  # DB initializer
    └── database_service.dart # CRUD service
```

---

## 🔌 Exported API

```dart
export 'src/database_config.dart';
export 'src/database_service.dart';
export 'src/base_model.dart';
```

---

## 👨‍💻 Contributing

- Fork it 🍴

- Create your feature branch 🔧

- Commit your changes ✅

- Push to the branch 🚀

- Open a pull request 🎉

---

## 📜 License

This package is MIT licensed. See [License](./LICENSE).

> Designed with ❤️ by [Mohamed Abouzaid]
