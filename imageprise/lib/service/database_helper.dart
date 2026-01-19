import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../modele/endroit.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('endroits.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE endroits (
        id TEXT PRIMARY KEY,
        nom TEXT NOT NULL,
        imagePath TEXT
      )
    ''');
  }

  Future<void> insertEndroit(Endroit endroit) async {
    final db = await instance.database;
    await db.insert(
      'endroits',
      endroit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Endroit>> getAllEndroits() async {
    final db = await instance.database;
    final result = await db.query('endroits', orderBy: 'rowid DESC');
    return result.map((map) {
      // map contient id, nom, imagePath
      return Endroit.fromMap(map);
    }).toList();
  }

  Future<Endroit?> getEndroitById(String id) async {
    final db = await instance.database;
    final result = await db.query('endroits', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Endroit.fromMap(result.first);
    }
    return null;
  }

  Future<void> updateEndroit(Endroit endroit) async {
    final db = await instance.database;
    await db.update(
      'endroits',
      endroit.toMap(),
      where: 'id = ?',
      whereArgs: [endroit.id],
    );
  }

  Future<void> deleteEndroit(String id) async {
    final db = await instance.database;
    await db.delete('endroits', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
    _database = null;
  }
}
