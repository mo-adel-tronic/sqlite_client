abstract class BaseModel {
  Map<String, dynamic> toMap();
  String get tableName;
  String get primaryKey;
}
