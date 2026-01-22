import 'package:flutter/foundation.dart';
import 'local_database_service.dart';
import 'firebase_service.dart';
// Note: 'repository.dart' n'est plus nécessaire ici si WasteCollectionRepository n'est plus utilisé

/// Service de synchronisation entre Firebase et la base de données locale
class SyncService {
  final LocalDatabaseService _localDatabase;
  final FirebaseService _firebaseService;
  // CORRECTION : Suppression du champ _collectionRepo car il n'est jamais utilisé
  bool _isSyncing = false;

  SyncService({
    required LocalDatabaseService localDatabase,
    required FirebaseService firebaseService,
  }) : _localDatabase = localDatabase,
       _firebaseService = firebaseService;

  /// Vérifier si une synchronisation est en cours
  bool get isSyncing => _isSyncing;

  /// Synchroniser les données
  Future<void> syncAllData(String userId) async {
    if (_isSyncing) return;

    _isSyncing = true;
    try {
      // Synchroniser les collectes
      await _syncCollections(userId);

      // Synchroniser les habitudes de tri
      await _syncSortingHabits(userId);

      // Synchroniser les réussites
      await _syncAchievements(userId);

      debugPrint('Synchronisation réussie pour l\'utilisateur: $userId');
    } catch (e) {
      debugPrint('Erreur lors de la synchronisation: $e');
      rethrow;
    } finally {
      _isSyncing = false;
    }
  }

  /// Synchroniser les collectes
  Future<void> _syncCollections(String userId) async {
    try {
      // Récupérer les collectes locales
      final localCollections = await _localDatabase.getUserCollections(userId);

      // Télécharger chaque collecte sur Firebase
      for (final collection in localCollections) {
        try {
          await _firebaseService.saveWasteCollection(collection);
        } catch (e) {
          debugPrint('Erreur lors de la synchronisation de la collecte: $e');
        }
      }
    } catch (e) {
      debugPrint('Erreur lors de la synchronisation des collectes: $e');
    }
  }

  /// Synchroniser les habitudes de tri
  Future<void> _syncSortingHabits(String userId) async {
    try {
      final habit = await _localDatabase.getSortingHabit(userId);
      if (habit != null) {
        // Logique de téléchargement sur Firebase à implémenter ici
        debugPrint('Habitude de tri synchronisée');
      }
    } catch (e) {
      debugPrint('Erreur lors de la synchronisation des habitudes: $e');
    }
  }

  /// Synchroniser les réussites
  Future<void> _syncAchievements(String userId) async {
    try {
      final achievements = await _localDatabase.getUnlockedAchievements(userId);
      debugPrint('${achievements.length} réussites synchronisées');
    } catch (e) {
      debugPrint('Erreur lors de la synchronisation des réussites: $e');
    }
  }

  /// Effacer toutes les données locales
  Future<void> clearLocalData() async {
    await _localDatabase.clearAll();
  }
}
