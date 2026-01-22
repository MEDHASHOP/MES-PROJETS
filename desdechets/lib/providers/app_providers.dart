import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';
import '../models/index.dart';
import '../services/index.dart';
import '../screens/profile_screen.dart';

/// Providers pour la gestion d'état avec Riverpod

// === SERVICES PROVIDERS ===

/// Provider pour le service de base de données locale
final localDatabaseProvider = Provider<LocalDatabaseService>((ref) {
  return LocalDatabaseService();
});

/// Provider pour le service Firebase
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

/// Provider pour le service de synchronisation
final syncServiceProvider = Provider<SyncService>((ref) {
  final localDb = ref.watch(localDatabaseProvider);
  final firebase = ref.watch(firebaseServiceProvider);

  return SyncService(localDatabase: localDb, firebaseService: firebase);
});

// === REPOSITORY PROVIDERS ===

/// Provider pour le repository des points de collecte
final collectionPointRepositoryProvider = Provider<CollectionPointRepository>((
  ref,
) {
  final firebaseService = ref.watch(firebaseServiceProvider);

  return CollectionPointRepository(firebaseService: firebaseService);
});

/// Provider pour le repository des collectes
final wasteCollectionRepositoryProvider = Provider<WasteCollectionRepository>((
  ref,
) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  final localDatabase = ref.watch(localDatabaseProvider);

  return WasteCollectionRepository(
    firebaseService: firebaseService,
    localDatabase: localDatabase,
  );
});

/// Provider pour le repository des conseils
final recyclingTipRepositoryProvider = Provider<RecyclingTipRepository>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);

  return RecyclingTipRepository(firebaseService: firebaseService);
});

/// Provider pour le repository des utilisateurs
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  final localDatabase = ref.watch(localDatabaseProvider);

  return UserRepository(
    firebaseService: firebaseService,
    localDatabase: localDatabase,
  );
});

/// Provider pour le repository des habitudes de tri
final sortingHabitRepositoryProvider = Provider<SortingHabitRepository>((ref) {
  final localDatabase = ref.watch(localDatabaseProvider);

  return SortingHabitRepository(localDatabase: localDatabase);
});

/// Provider pour le repository des préférences
final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  final localDatabase = ref.watch(localDatabaseProvider);

  return PreferencesRepository(localDatabase: localDatabase);
});

/// Provider pour le repository des favoris
final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  final localDatabase = ref.watch(localDatabaseProvider);

  return FavoritesRepository(localDatabase: localDatabase);
});

/// Provider pour le repository des réussites
final achievementsRepositoryProvider = Provider<AchievementsRepository>((ref) {
  final localDatabase = ref.watch(localDatabaseProvider);

  return AchievementsRepository(localDatabase: localDatabase);
});

// === STATE PROVIDERS ===

/// Provider pour l'utilisateur courant (StateNotifier)
final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, User?>((
  ref,
) {
  return CurrentUserNotifier(ref.watch(userRepositoryProvider));
});

/// Provider pour les points de collecte
final collectionPointsProvider = FutureProvider<List<CollectionPoint>>((ref) {
  final repo = ref.watch(collectionPointRepositoryProvider);
  return repo.getAllPoints();
});

/// Provider pour les conseils
final recyclingTipsProvider = FutureProvider<List<RecyclingTip>>((ref) {
  final repo = ref.watch(recyclingTipRepositoryProvider);
  return repo.getAllTips();
});

/// Provider pour les collectes de l'utilisateur
final userCollectionsProvider =
    FutureProvider.family<List<WasteCollection>, String>((ref, userId) {
      final repo = ref.watch(wasteCollectionRepositoryProvider);
      return repo.getUserCollections(userId);
    });

/// Provider pour les habitudes de tri
final userSortingHabitProvider = FutureProvider.family<SortingHabit?, String>((
  ref,
  userId,
) {
  final repo = ref.watch(sortingHabitRepositoryProvider);
  return repo.getSortingHabit(userId);
});

/// Provider pour les préférences de l'utilisateur
final userPreferencesProvider = FutureProvider.family<UserPreferences?, String>(
  (ref, userId) {
    final repo = ref.watch(preferencesRepositoryProvider);
    return repo.getPreferences(userId);
  },
);

/// Provider pour les IDs des conseils favoris
final favoriteTipsIdsProvider = FutureProvider.family<List<String>, String>((
  ref,
  userId,
) {
  final repo = ref.watch(favoritesRepositoryProvider);
  return repo.getFavoriteTipsIds(userId);
});

/// Provider pour les réussites débloquées
final unlockedAchievementsProvider =
    FutureProvider.family<List<String>, String>((ref, userId) {
      final repo = ref.watch(achievementsRepositoryProvider);
      return repo.getUnlockedAchievements(userId);
    });

// === STATE NOTIFIERS ===

/// Notifier pour gérer l'utilisateur courant
class CurrentUserNotifier extends StateNotifier<User?> {
  final UserRepository _userRepository;

  CurrentUserNotifier(this._userRepository) : super(null);

  /// Charger l'utilisateur
  Future<void> loadUser(String userId) async {
    try {
      final user = await _userRepository.getUser(userId);
      state = user;
    } catch (e) {
      debugPrint('Erreur lors du chargement de l\'utilisateur: $e');
    }
  }

  /// Sauvegarder l'utilisateur
  Future<void> saveUser(User user) async {
    try {
      await _userRepository.saveUser(user);
      state = user;
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde de l\'utilisateur: $e');
    }
  }
}
