// lib/service/databasemanager.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import '../modele/note.dart'; // ← Changement ici

class DatabaseManager {
  static const String _dbName = 'notes.db'; // ← Changement ici
  static const int _dbVersion = 1;
  static const String _tableNotes = 'notes'; // ← Changement ici

  // Singleton
  DatabaseManager._privateConstructor();
  static final DatabaseManager instance = DatabaseManager._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialisation de la base de données
  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String fullPath = path.join(dbPath, _dbName);

    return await openDatabase(
      fullPath,
      version: _dbVersion,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $_tableNotes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titre TEXT NOT NULL,
            contenu TEXT NOT NULL,
            date_creation TEXT NOT NULL
          )
          ''');
      },
    );
  }

  // Insérer une note
  Future<int> insertNote(Note note) async {
    // ← Changement ici
    final db = await database;
    return await db.insert(_tableNotes, note.toMap()); // ← Changement ici
  }

  // Récupérer toutes les notes
  Future<List<Note>> getAllNotes() async {
    // ← Changement ici
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableNotes,
    ); // ← Changement ici

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]); // ← Changement ici
    });
  }

  // Mettre à jour une note
  Future<int> updateNote(Note note) async {
    // ← Changement ici
    final db = await database;
    return await db.update(
      _tableNotes, // ← Changement ici
      note.toMap(), // ← Changement ici
      where: 'id = ?', // ← Changement ici
      whereArgs: [note.id], // ← Changement ici
    );
  }

  // Supprimer une note
  Future<int> deleteNote(int id) async {
    // ← Changement ici
    final db = await database;
    return await db.delete(
      _tableNotes, // ← Changement ici
      where: 'id = ?', // ← Changement ici
      whereArgs: [id], // ← Changement ici
    );
  }
}
