// service/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; // Pour la fonction join
import '../modele/joueur.dart'; // Import de votre modèle Joueur

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Nom de la table et des colonnes
  static const String tableJoueurs = 'joueurs';
  static const String columnId = 'id';
  static const String columnNom = 'nom';
  static const String columnPoste = 'poste';
  static const String columnPrenoms = 'prenoms';
  static const String columnImage = 'chemin_image';
  static const String columnNbButs = 'nb_buts';
  static const String columnEstPresent = 'est_present';

  static const String columnCotisation = 'cotisation';
  static const String columnPresences = 'presences';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialisation de la base de données
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'joueurs.db');
    return await openDatabase(
      path,
      version: 2, // Version de la base de données
      onCreate: _onCreate, // Callback appelé lors de la première création
      onUpgrade: _onUpgrade, // Callback pour les migrations
    );
  }

  // Callback appelé lors de la création de la base de données
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableJoueurs (
        $columnId TEXT PRIMARY KEY,
        $columnNom TEXT NOT NULL,
        $columnPoste TEXT NOT NULL,
        $columnPrenoms TEXT NOT NULL,
        $columnImage TEXT,
        $columnNbButs INTEGER DEFAULT 0,
        $columnEstPresent INTEGER DEFAULT 0, -- 0 pour false, 1 pour true
        $columnCotisation REAL DEFAULT 0.0,
        $columnPresences TEXT DEFAULT ''
      )
    ''');
  }

  // Callback pour les migrations
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE $tableJoueurs ADD COLUMN $columnCotisation REAL DEFAULT 0.0',
      );
      await db.execute(
        'ALTER TABLE $tableJoueurs ADD COLUMN $columnPresences TEXT DEFAULT ""',
      );
    }
  }

  // --- Méthodes CRUD ---

  // Lire tous les joueurs
  Future<List<Joueur>> lireTousLesJoueurs() async {
    final db = await database;
    final maps = await db.query(tableJoueurs);

    if (maps.isEmpty) return [];

    return List.generate(maps.length, (i) {
      return Joueur.fromMap(maps[i]); // Utilise le constructeur fromMap
    });
  }

  // Ajouter un nouveau joueur
  Future<void> ajouterJoueur(Joueur joueur) async {
    final db = await database;
    await db.insert(
      tableJoueurs,
      joueur.toMap(), // Utilise la méthode toMap
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Remplace si l'id existe déjà
    );
  }

  // Mettre à jour un joueur existant
  Future<void> mettreAJourJoueur(Joueur joueur) async {
    final db = await database;
    await db.update(
      tableJoueurs,
      joueur.toMap(), // Utilise la méthode toMap
      where: '$columnId = ?',
      whereArgs: [joueur.id],
    );
  }

  // Supprimer un joueur (optionnel)
  Future<void> supprimerJoueur(String id) async {
    final db = await database;
    await db.delete(tableJoueurs, where: '$columnId = ?', whereArgs: [id]);
  }
}
