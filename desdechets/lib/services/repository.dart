import 'package:flutter/material.dart';

import '../models/index.dart';
import '../screens/profile_screen.dart';
import 'local_database_service.dart';
import 'firebase_service.dart';

/// Service pour les repositories - couche d'abstraction entre l'UI et les services de données
/// Cette architecture permet de changer facilement les sources de données

/// Repository pour les points de collecte
class CollectionPointRepository {
  final FirebaseService _firebaseService;

  CollectionPointRepository({required FirebaseService firebaseService})
    : _firebaseService = firebaseService;

  /// Obtenir tous les points de collecte (priorité: Firebase, fallback: Local)
  Future<List<CollectionPoint>> getAllPoints() async {
    try {
      return await _firebaseService.getAllCollectionPoints();
    } catch (e) {
      // Fallback sur la base de données locale en cas d'erreur
      debugPrint('Erreur Firebase, utilisation du cache local: $e');
      return [];
    }
  }

  /// Écouter les changements en temps réel
  Stream<List<CollectionPoint>> watchAllPoints() {
    return _firebaseService.watchCollectionPoints();
  }

  /// Obtenir les points filtrés par type de déchet
  Future<List<CollectionPoint>> getPointsByWasteType(String wasteType) async {
    try {
      return await _firebaseService.getCollectionPointsByWasteType(wasteType);
    } catch (e) {
      debugPrint('Erreur lors de la récupération des points: $e');
      return [];
    }
  }

  /// Sauvegarder un point (pour les administrateurs)
  Future<void> savePoint(CollectionPoint point) async {
    await _firebaseService.saveCollectionPoint(point);
  }
}

/// Repository pour les collectes
class WasteCollectionRepository {
  final FirebaseService _firebaseService;
  final LocalDatabaseService _localDatabase;

  WasteCollectionRepository({
    required FirebaseService firebaseService,
    required LocalDatabaseService localDatabase,
  }) : _firebaseService = firebaseService,
       _localDatabase = localDatabase;

  /// Sauvegarder une collecte (local + Firebase)
  Future<void> saveCollection(WasteCollection collection) async {
    // Sauvegarder en local d'abord
    await _localDatabase.saveCollection(collection);

    // Puis synchroniser avec Firebase
    try {
      await _firebaseService.saveWasteCollection(collection);
    } catch (e) {
      debugPrint('Erreur lors de la synchronisation avec Firebase: $e');
      // L'données reste en local et sera synchronisée plus tard
    }
  }

  /// Obtenir les collectes d'un utilisateur
  Future<List<WasteCollection>> getUserCollections(String userId) async {
    try {
      // Essayer Firebase d'abord
      return await _firebaseService.getUserWasteCollections(userId);
    } catch (e) {
      // Fallback sur le local
      debugPrint('Erreur Firebase, utilisation du cache local: $e');
      return await _localDatabase.getUserCollections(userId);
    }
  }

  /// Obtenir les collectes pour une plage de dates
  Future<List<WasteCollection>> getCollectionsForDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      return await _firebaseService.getCollectionsForDateRange(
        userId,
        startDate,
        endDate,
      );
    } catch (e) {
      debugPrint('Erreur lors de la récupération des collectes: $e');
      return [];
    }
  }

  /// Écouter les changements en temps réel
  Stream<List<WasteCollection>> watchUserCollections(String userId) {
    return _firebaseService.watchUserWasteCollections(userId);
  }

  /// Marquer une collecte comme complétée
  Future<void> markAsCompleted(String collectionId) async {
    await _firebaseService.updateCollectionStatus(collectionId, true);
  }

  /// Supprimer une collecte
  Future<void> deleteCollection(String collectionId) async {
    await _localDatabase.deleteCollection(collectionId);
    try {
      await _firebaseService.deleteWasteCollection(collectionId);
    } catch (e) {
      debugPrint('Erreur lors de la suppression: $e');
    }
  }

  /// Obtenir les collectes d'un jour spécifique
  Future<List<WasteCollection>> getCollectionsForDate(
    String userId,
    DateTime date,
  ) async {
    return await _localDatabase.getCollectionsForDate(userId, date);
  }

  /// Obtenir les collectes du mois
  Future<List<WasteCollection>> getCollectionsForMonth(
    String userId,
    DateTime month,
  ) async {
    return await _localDatabase.getCollectionsForMonth(userId, month);
  }
}

/// Repository pour les conseils
class RecyclingTipRepository {
  final FirebaseService _firebaseService;

  RecyclingTipRepository({required FirebaseService firebaseService})
    : _firebaseService = firebaseService;

  /// Obtenir tous les conseils
  Future<List<RecyclingTip>> getAllTips() async {
    try {
      return await _firebaseService.getAllRecyclingTips();
    } catch (e) {
      debugPrint('Erreur lors de la récupération des conseils: $e');
      return [];
    }
  }

  /// Obtenir les conseils par catégorie
  Future<List<RecyclingTip>> getTipsByCategory(String category) async {
    try {
      return await _firebaseService.getRecyclingTipsByCategory(category);
    } catch (e) {
      debugPrint('Erreur lors de la récupération des conseils: $e');
      return [];
    }
  }

  /// Écouter les changements en temps réel
  Stream<List<RecyclingTip>> watchAllTips() {
    return _firebaseService.watchRecyclingTips();
  }

  /// Incrémenter les vues d'un conseil
  Future<void> incrementViewCount(String tipId) async {
    try {
      await _firebaseService.incrementTipViewCount(tipId);
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour des vues: $e');
    }
  }

  /// Ajouter un commentaire
  Future<void> addComment(
    String tipId,
    String userId,
    String comment,
    double rating,
  ) async {
    try {
      await _firebaseService.addTipComment(tipId, userId, comment, rating);
    } catch (e) {
      debugPrint('Erreur lors de l\'ajout du commentaire: $e');
    }
  }
}

/// Repository pour les utilisateurs
class UserRepository {
  final FirebaseService _firebaseService;
  final LocalDatabaseService _localDatabase;

  UserRepository({
    required FirebaseService firebaseService,
    required LocalDatabaseService localDatabase,
  }) : _firebaseService = firebaseService,
       _localDatabase = localDatabase;

  /// Sauvegarder un utilisateur
  Future<void> saveUser(User user) async {
    await _localDatabase.saveUser(user);
    try {
      await _firebaseService.saveUser(user);
    } catch (e) {
      debugPrint('Erreur lors de la synchronisation utilisateur: $e');
    }
  }

  /// Obtenir un utilisateur
  Future<User?> getUser(String userId) async {
    try {
      return await _firebaseService.getUser(userId);
    } catch (e) {
      debugPrint('Erreur Firebase, utilisation du cache local: $e');
      return await _localDatabase.getUser(userId);
    }
  }
}

/// Repository pour les habitudes de tri
class SortingHabitRepository {
  final LocalDatabaseService _localDatabase;

  SortingHabitRepository({required LocalDatabaseService localDatabase})
    : _localDatabase = localDatabase;

  /// Sauvegarder les habitudes de tri
  Future<void> saveSortingHabit(SortingHabit habit) async {
    await _localDatabase.saveSortingHabit(habit);
  }

  /// Obtenir les habitudes de tri
  Future<SortingHabit?> getSortingHabit(String userId) async {
    return await _localDatabase.getSortingHabit(userId);
  }
}

/// Repository pour les préférences utilisateur
class PreferencesRepository {
  final LocalDatabaseService _localDatabase;

  PreferencesRepository({required LocalDatabaseService localDatabase})
    : _localDatabase = localDatabase;

  /// Sauvegarder les préférences
  Future<void> savePreferences(UserPreferences preferences) async {
    await _localDatabase.saveUserPreferences(preferences);
  }

  /// Obtenir les préférences
  Future<UserPreferences?> getPreferences(String userId) async {
    return await _localDatabase.getUserPreferences(userId);
  }
}

/// Repository pour les favoris
class FavoritesRepository {
  final LocalDatabaseService _localDatabase;

  FavoritesRepository({required LocalDatabaseService localDatabase})
    : _localDatabase = localDatabase;

  /// Ajouter aux favoris
  Future<void> addToFavorites(String userId, String tipId) async {
    await _localDatabase.saveTipAsFavorite(userId, tipId);
  }

  /// Retirer des favoris
  Future<void> removeFromFavorites(String userId, String tipId) async {
    await _localDatabase.removeTipFromFavorites(userId, tipId);
  }

  /// Obtenir les IDs des favoris
  Future<List<String>> getFavoriteTipsIds(String userId) async {
    return await _localDatabase.getSavedTipsIds(userId);
  }
}

/// Repository pour les réussites
class AchievementsRepository {
  final LocalDatabaseService _localDatabase;

  AchievementsRepository({required LocalDatabaseService localDatabase})
    : _localDatabase = localDatabase;

  /// Débloquer une réussite
  Future<void> unlockAchievement(String userId, String achievementId) async {
    await _localDatabase.unlockAchievement(userId, achievementId);
  }

  /// Obtenir les réussites débloquées
  Future<List<String>> getUnlockedAchievements(String userId) async {
    return await _localDatabase.getUnlockedAchievements(userId);
  }
}
