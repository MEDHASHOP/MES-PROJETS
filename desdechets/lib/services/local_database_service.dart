import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../screens/profile_screen.dart';
import '../models/index.dart';

/// Service pour la gestion de la base de données locale avec SQLite
class LocalDatabaseService {
  static final LocalDatabaseService _instance =
      LocalDatabaseService._internal();
  static Database? _database;

  // Noms des tables
  static const String usersTable = 'users';
  static const String preferencesTable = 'preferences';
  static const String collectionsTable = 'collections';
  static const String sortingHabitsTable = 'sorting_habits';
  static const String savedTipsTable = 'saved_tips';
  static const String achievementsTable = 'achievements';

  factory LocalDatabaseService() {
    return _instance;
  }

  LocalDatabaseService._internal();

  /// Obtenir la base de données (singleton)
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Initialiser la base de données
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'desdechets.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  /// Créer les tables
  Future<void> _createTables(Database db, int version) async {
    // Table des utilisateurs
    await db.execute('''
      CREATE TABLE $usersTable (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        profileImage TEXT,
        address TEXT NOT NULL,
        phoneNumber TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        notificationsEnabled INTEGER DEFAULT 1,
        sortingScore INTEGER DEFAULT 0
      )
    ''');

    // Table des préférences utilisateur
    await db.execute('''
      CREATE TABLE $preferencesTable (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        notificationsEnabled INTEGER DEFAULT 1,
        emailReminders INTEGER DEFAULT 1,
        pushNotifications INTEGER DEFAULT 1,
        preferredLanguage TEXT DEFAULT 'fr',
        themeMode TEXT DEFAULT 'light',
        shareStatistics INTEGER DEFAULT 0,
        reminderTime TEXT DEFAULT '09:00',
        interestedWasteTypes TEXT,
        radiusKm REAL DEFAULT 5.0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES $usersTable(id) ON DELETE CASCADE
      )
    ''');

    // Table des collectes
    await db.execute('''
      CREATE TABLE $collectionsTable (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        type TEXT NOT NULL,
        collectionDate TEXT NOT NULL,
        location TEXT,
        latitude REAL,
        longitude REAL,
        quantity INTEGER DEFAULT 0,
        notes TEXT,
        createdAt TEXT NOT NULL,
        completed INTEGER DEFAULT 0,
        FOREIGN KEY (userId) REFERENCES $usersTable(id) ON DELETE CASCADE
      )
    ''');

    // Table des habitudes de tri
    await db.execute('''
      CREATE TABLE $sortingHabitsTable (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        totalCollections INTEGER DEFAULT 0,
        totalWeight INTEGER DEFAULT 0,
        wasteTypeCount TEXT,
        lastCollection TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        currentStreak INTEGER DEFAULT 0,
        bestStreak INTEGER DEFAULT 0,
        FOREIGN KEY (userId) REFERENCES $usersTable(id) ON DELETE CASCADE
      )
    ''');

    // Table des conseils sauvegardés
    await db.execute('''
      CREATE TABLE $savedTipsTable (
        id TEXT PRIMARY KEY,
        tipId TEXT NOT NULL,
        userId TEXT NOT NULL,
        savedAt TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES $usersTable(id) ON DELETE CASCADE
      )
    ''');

    // Table des réussites débloquées
    await db.execute('''
      CREATE TABLE $achievementsTable (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        achievementId TEXT NOT NULL,
        unlockedAt TEXT NOT NULL,
        progress REAL DEFAULT 0.0,
        FOREIGN KEY (userId) REFERENCES $usersTable(id) ON DELETE CASCADE
      )
    ''');

    // Index pour optimiser les recherches
    await db.execute(
      'CREATE INDEX idx_collections_userId ON $collectionsTable(userId)',
    );
    await db.execute(
      'CREATE INDEX idx_collections_date ON $collectionsTable(collectionDate)',
    );
    await db.execute(
      'CREATE INDEX idx_preferences_userId ON $preferencesTable(userId)',
    );
  }

  /// Gestion des migrations
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Ajouter ici les migrations si nécessaire
  }

  /// --- MÉTHODES POUR LES UTILISATEURS ---

  /// Sauvegarder un utilisateur
  Future<void> saveUser(User user) async {
    final db = await database;
    await db.insert(
      usersTable,
      _userToJson(user),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Obtenir un utilisateur par ID
  Future<User?> getUser(String userId) async {
    final db = await database;
    final results = await db.query(
      usersTable,
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (results.isEmpty) return null;
    return _jsonToUser(results.first);
  }

  /// --- MÉTHODES POUR LES PRÉFÉRENCES ---

  /// Sauvegarder les préférences utilisateur
  Future<void> saveUserPreferences(UserPreferences preferences) async {
    final db = await database;
    await db.insert(
      preferencesTable,
      _preferencesToJson(preferences),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Obtenir les préférences utilisateur
  Future<UserPreferences?> getUserPreferences(String userId) async {
    final db = await database;
    final results = await db.query(
      preferencesTable,
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (results.isEmpty) return null;
    return _jsonToUserPreferences(results.first);
  }

  /// --- MÉTHODES POUR LES COLLECTES ---

  /// Sauvegarder une collecte
  Future<void> saveCollection(WasteCollection collection) async {
    final db = await database;
    await db.insert(
      collectionsTable,
      _collectionToJson(collection),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Obtenir toutes les collectes d'un utilisateur
  Future<List<WasteCollection>> getUserCollections(String userId) async {
    final db = await database;
    final results = await db.query(
      collectionsTable,
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'collectionDate DESC',
    );

    return results.map((json) => _jsonToCollection(json)).toList();
  }

  /// Obtenir les collectes d'un utilisateur pour une date donnée
  Future<List<WasteCollection>> getCollectionsForDate(
    String userId,
    DateTime date,
  ) async {
    final db = await database;
    final dateStr = date.toIso8601String().split('T')[0];

    final results = await db.query(
      collectionsTable,
      where: 'userId = ? AND DATE(collectionDate) = ?',
      whereArgs: [userId, dateStr],
    );

    return results.map((json) => _jsonToCollection(json)).toList();
  }

  /// Obtenir les collectes du mois
  Future<List<WasteCollection>> getCollectionsForMonth(
    String userId,
    DateTime month,
  ) async {
    final db = await database;
    final startDate = DateTime(month.year, month.month, 1);
    final endDate = DateTime(month.year, month.month + 1, 0);

    final results = await db.query(
      collectionsTable,
      where: 'userId = ? AND collectionDate BETWEEN ? AND ?',
      whereArgs: [
        userId,
        startDate.toIso8601String(),
        endDate.toIso8601String(),
      ],
      orderBy: 'collectionDate DESC',
    );

    return results.map((json) => _jsonToCollection(json)).toList();
  }

  /// Supprimer une collecte
  Future<void> deleteCollection(String collectionId) async {
    final db = await database;
    await db.delete(
      collectionsTable,
      where: 'id = ?',
      whereArgs: [collectionId],
    );
  }

  /// --- MÉTHODES POUR LES HABITUDES DE TRI ---

  /// Sauvegarder les habitudes de tri
  Future<void> saveSortingHabit(SortingHabit habit) async {
    final db = await database;
    await db.insert(
      sortingHabitsTable,
      _habitToJson(habit),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Obtenir les habitudes de tri d'un utilisateur
  Future<SortingHabit?> getSortingHabit(String userId) async {
    final db = await database;
    final results = await db.query(
      sortingHabitsTable,
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (results.isEmpty) return null;
    return _jsonToHabit(results.first);
  }

  /// --- MÉTHODES POUR LES CONSEILS SAUVEGARDÉS ---

  /// Ajouter un conseil aux favoris
  Future<void> saveTipAsFavorite(String userId, String tipId) async {
    final db = await database;
    await db.insert(savedTipsTable, {
      'id': '$userId-$tipId',
      'tipId': tipId,
      'userId': userId,
      'savedAt': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Retirer un conseil des favoris
  Future<void> removeTipFromFavorites(String userId, String tipId) async {
    final db = await database;
    await db.delete(
      savedTipsTable,
      where: 'userId = ? AND tipId = ?',
      whereArgs: [userId, tipId],
    );
  }

  /// Obtenir les conseils sauvegardés
  Future<List<String>> getSavedTipsIds(String userId) async {
    final db = await database;
    final results = await db.query(
      savedTipsTable,
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return results.map((row) => row['tipId'] as String).toList();
  }

  /// --- MÉTHODES POUR LES RÉUSSITES ---

  /// Débloquer une réussite
  Future<void> unlockAchievement(String userId, String achievementId) async {
    final db = await database;
    await db.insert(achievementsTable, {
      'id': '$userId-$achievementId',
      'userId': userId,
      'achievementId': achievementId,
      'unlockedAt': DateTime.now().toIso8601String(),
      'progress': 1.0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Obtenir les réussites débloquées
  Future<List<String>> getUnlockedAchievements(String userId) async {
    final db = await database;
    final results = await db.query(
      achievementsTable,
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return results.map((row) => row['achievementId'] as String).toList();
  }

  /// --- MÉTHODES UTILITAIRES ---

  /// Vider toutes les données (pour le débogage)
  Future<void> clearAll() async {
    final db = await database;
    await db.delete(collectionsTable);
    await db.delete(sortingHabitsTable);
    await db.delete(savedTipsTable);
    await db.delete(achievementsTable);
    await db.delete(preferencesTable);
    await db.delete(usersTable);
  }

  /// Fermer la base de données
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// --- CONVERTISSEURS JSON ---

  Map<String, dynamic> _userToJson(User user) {
    return {
      'id': user.id,
      'email': user.email,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'profileImage': user.profileImage,
      'address': user.address,
      'phoneNumber': user.phoneNumber,
      'createdAt': user.createdAt.toIso8601String(),
      'updatedAt': user.updatedAt.toIso8601String(),
      'notificationsEnabled': user.notificationsEnabled ? 1 : 0,
      'sortingScore': user.sortingScore,
    };
  }

  User _jsonToUser(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      profileImage: json['profileImage'] as String?,
      address: json['address'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      notificationsEnabled: (json['notificationsEnabled'] as int?) == 1,
      sortingScore: json['sortingScore'] as int? ?? 0,
    );
  }

  Map<String, dynamic> _preferencesToJson(UserPreferences prefs) {
    return {
      'id': '${prefs.userId}-prefs',
      'userId': prefs.userId,
      'notificationsEnabled': prefs.notificationsEnabled ? 1 : 0,
      'emailReminders': prefs.emailReminders ? 1 : 0,
      'pushNotifications': prefs.pushNotifications ? 1 : 0,
      'preferredLanguage': prefs.preferredLanguage,
      'themeMode': prefs.themeMode.toString(),
      'shareStatistics': prefs.shareStatistics ? 1 : 0,
      'reminderTime': prefs.reminderTime,
      'interestedWasteTypes': prefs.interestedWasteTypes.join(','),
      'radiusKm': prefs.radiusKm,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  UserPreferences _jsonToUserPreferences(Map<String, dynamic> json) {
    return UserPreferences(
      userId: json['userId'] as String,
      notificationsEnabled: (json['notificationsEnabled'] as int?) == 1,
      emailReminders: (json['emailReminders'] as int?) == 1,
      pushNotifications: (json['pushNotifications'] as int?) == 1,
      preferredLanguage: json['preferredLanguage'] as String? ?? 'fr',
      themeMode: ThemeMode.values.firstWhere(
        (e) => e.toString() == json['themeMode'],
        orElse: () => ThemeMode.light,
      ),
      shareStatistics: (json['shareStatistics'] as int?) == 1,
      reminderTime: json['reminderTime'] as String? ?? '09:00',
      interestedWasteTypes: (json['interestedWasteTypes'] as String? ?? '')
          .split(',')
          .where((e) => e.isNotEmpty)
          .toList(),
      radiusKm: (json['radiusKm'] as num?)?.toDouble() ?? 5.0,
    );
  }

  Map<String, dynamic> _collectionToJson(WasteCollection collection) {
    return {
      'id': collection.id,
      'userId': collection.userId,
      'type': collection.type.toString(),
      'collectionDate': collection.collectionDate.toIso8601String(),
      'location': collection.location,
      'latitude': collection.latitude,
      'longitude': collection.longitude,
      'quantity': collection.quantity,
      'notes': collection.notes,
      'createdAt': collection.createdAt.toIso8601String(),
      'completed': collection.completed ? 1 : 0,
    };
  }

  WasteCollection _jsonToCollection(Map<String, dynamic> json) {
    return WasteCollection(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: WasteType.values.firstWhere(
        (type) => type.toString() == json['type'],
        orElse: () => WasteType.mixed,
      ),
      collectionDate: DateTime.parse(json['collectionDate'] as String),
      location: json['location'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      quantity: json['quantity'] as int? ?? 0,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completed: (json['completed'] as int?) == 1,
    );
  }

  Map<String, dynamic> _habitToJson(SortingHabit habit) {
    return {
      'id': habit.id,
      'userId': habit.userId,
      'totalCollections': habit.totalCollections,
      'totalWeight': habit.totalWeight,
      'wasteTypeCount': _mapToJson(habit.wasteTypeCount),
      'lastCollection': habit.lastCollection.toIso8601String(),
      'createdAt': habit.createdAt.toIso8601String(),
      'updatedAt': habit.updatedAt.toIso8601String(),
      'currentStreak': habit.currentStreak,
      'bestStreak': habit.bestStreak,
    };
  }

  SortingHabit _jsonToHabit(Map<String, dynamic> json) {
    final wasteTypeCountRaw = _jsonToMap(
      json['wasteTypeCount'] as String? ?? '',
    );
    final wasteTypeCount = wasteTypeCountRaw.map(
      (key, value) => MapEntry(key, (value as num).toInt()),
    );

    return SortingHabit(
      id: json['id'] as String,
      userId: json['userId'] as String,
      totalCollections: json['totalCollections'] as int? ?? 0,
      totalWeight: json['totalWeight'] as int? ?? 0,
      wasteTypeCount: wasteTypeCount,
      lastCollection: DateTime.parse(json['lastCollection'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      currentStreak: json['currentStreak'] as int? ?? 0,
      bestStreak: json['bestStreak'] as int? ?? 0,
    );
  }

  String _mapToJson(Map<String, int> map) {
    return map.entries.map((e) => '${e.key}:${e.value}').join(',');
  }

  Map<String, int> _jsonToMap(String jsonStr) {
    if (jsonStr.isEmpty) return {};
    return Map.fromEntries(
      jsonStr.split(',').map((entry) {
        final parts = entry.split(':');
        return MapEntry(parts[0], int.parse(parts[1]));
      }),
    );
  }
}
