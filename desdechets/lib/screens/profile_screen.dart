import 'package:flutter/material.dart';
import '../models/index.dart';

/// Classe représentant l'état de l'écran profil
class ProfileScreenState {
  final User? currentUser;
  final SortingHabit? sortingHabit;
  final List<WasteCollection> userCollections;
  final List<RecyclingTip> savedTips;
  final List<AchievementBadge> achievements;
  final Statistics statistics;
  final bool isLoading;
  final String? error;
  final bool isEditMode;

  const ProfileScreenState({
    this.currentUser,
    this.sortingHabit,
    this.userCollections = const [],
    this.savedTips = const [],
    this.achievements = const [],
    this.statistics = const Statistics(),
    this.isLoading = false,
    this.error,
    this.isEditMode = false,
  });

  /// Créer une copie avec modifications
  ProfileScreenState copyWith({
    User? currentUser,
    SortingHabit? sortingHabit,
    List<WasteCollection>? userCollections,
    List<RecyclingTip>? savedTips,
    List<AchievementBadge>? achievements,
    Statistics? statistics,
    bool? isLoading,
    String? error,
    bool? isEditMode,
  }) {
    return ProfileScreenState(
      currentUser: currentUser ?? this.currentUser,
      sortingHabit: sortingHabit ?? this.sortingHabit,
      userCollections: userCollections ?? this.userCollections,
      savedTips: savedTips ?? this.savedTips,
      achievements: achievements ?? this.achievements,
      statistics: statistics ?? this.statistics,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isEditMode: isEditMode ?? this.isEditMode,
    );
  }

  @override
  String toString() =>
      'ProfileScreenState(user: ${currentUser?.email}, collectionsCount: ${userCollections.length})';
}

/// Classe pour les statistiques utilisateur
class Statistics {
  final int totalCollections;
  final int totalWeightKg;
  final int currentStreak;
  final int bestStreak;
  final int level;
  final int totalPoints;
  final Map<String, int> wasteBreakdown; // Répartition par type
  final double co2Saved; // CO2 économisé en kg
  final int treesEquivalent; // Nombre d'arbres équivalent

  const Statistics({
    this.totalCollections = 0,
    this.totalWeightKg = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.level = 1,
    this.totalPoints = 0,
    this.wasteBreakdown = const {},
    this.co2Saved = 0.0,
    this.treesEquivalent = 0,
  });

  /// Calculer le niveau basé sur les points
  int calculateLevel() {
    return (totalPoints / 1000).floor() + 1;
  }

  /// Créer une copie avec modifications
  Statistics copyWith({
    int? totalCollections,
    int? totalWeightKg,
    int? currentStreak,
    int? bestStreak,
    int? level,
    int? totalPoints,
    Map<String, int>? wasteBreakdown,
    double? co2Saved,
    int? treesEquivalent,
  }) {
    return Statistics(
      totalCollections: totalCollections ?? this.totalCollections,
      totalWeightKg: totalWeightKg ?? this.totalWeightKg,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      level: level ?? this.level,
      totalPoints: totalPoints ?? this.totalPoints,
      wasteBreakdown: wasteBreakdown ?? this.wasteBreakdown,
      co2Saved: co2Saved ?? this.co2Saved,
      treesEquivalent: treesEquivalent ?? this.treesEquivalent,
    );
  }

  @override
  String toString() =>
      'Statistics(collections: $totalCollections, weight: ${totalWeightKg}kg, level: $level)';
}

/// Classe pour un badge/réussite
class AchievementBadge {
  final String id;
  final String title;
  final String description;
  final String icon;
  final AchievementCategory category;
  final bool isUnlocked;
  final DateTime? unlockedDate;
  final double progress; // 0.0 à 1.0
  final String requirement; // Description du besoin

  const AchievementBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    this.isUnlocked = false,
    this.unlockedDate,
    this.progress = 0.0,
    required this.requirement,
  });

  /// Obtenir le pourcentage de progrès
  int get progressPercent => (progress * 100).toInt();

  /// Créer une copie avec modifications
  AchievementBadge copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    AchievementCategory? category,
    bool? isUnlocked,
    DateTime? unlockedDate,
    double? progress,
    String? requirement,
  }) {
    return AchievementBadge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedDate: unlockedDate ?? this.unlockedDate,
      progress: progress ?? this.progress,
      requirement: requirement ?? this.requirement,
    );
  }

  @override
  String toString() =>
      'AchievementBadge(id: $id, title: $title, isUnlocked: $isUnlocked)';
}

/// Catégories de badges
enum AchievementCategory {
  collections, // Nombre de collectes
  weight, // Poids total trié
  streaks, // Jours consécutifs
  wasteTypes, // Types de déchets
  learning, // Apprentissage
  community, // Communauté
  milestones, // Jalons
}

/// Prédéfinition des badges par défaut
class DefaultAchievements {
  static const List<AchievementBadge> badges = [
    AchievementBadge(
      id: 'first_collection',
      title: 'Première collecte',
      description: 'Effectuez votre première collecte de déchets',
      icon: '🌱',
      category: AchievementCategory.collections,
      requirement: 'Faire 1 collecte',
    ),
    AchievementBadge(
      id: 'week_streak',
      title: 'Une semaine consistante',
      description: 'Collectez des déchets pendant 7 jours consécutifs',
      icon: '🔥',
      category: AchievementCategory.streaks,
      requirement: '7 jours consécutifs',
    ),
    AchievementBadge(
      id: 'hundred_kg',
      title: 'Century Sorter',
      description: 'Triez 100 kg de déchets',
      icon: '💪',
      category: AchievementCategory.weight,
      requirement: '100 kg de déchets',
    ),
    AchievementBadge(
      id: 'all_types',
      title: 'Trieur polyvalent',
      description: 'Collectez tous les types de déchets',
      icon: '🎯',
      category: AchievementCategory.wasteTypes,
      requirement: 'Tous les types',
    ),
    AchievementBadge(
      id: 'tip_master',
      title: 'Expert en conseils',
      description: 'Consultez 50 conseils de recyclage',
      icon: '📚',
      category: AchievementCategory.learning,
      requirement: '50 conseils consultés',
    ),
  ];
}

/// Classe pour une activité récente
class RecentActivity {
  final String id;
  final String title;
  final String description;
  final ActivityType type;
  final DateTime timestamp;
  final String? icon;
  final Map<String, dynamic>? metadata; // Données supplémentaires

  const RecentActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
    this.icon,
    this.metadata,
  });

  /// Obtenir le texte du temps écoulé
  String get timeAgoText {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inHours < 1) {
      return 'Il y a ${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays}j';
    } else {
      return timestamp.toString().split(' ')[0];
    }
  }

  @override
  String toString() => 'RecentActivity(id: $id, title: $title, type: $type)';
}

/// Type d'activité
enum ActivityType {
  collection, // Collecte réalisée
  achievement, // Badge débloqué
  milestone, // Jalon atteint
  tip, // Conseil consulté
  badge, // Badge débloqué
  login, // Connexion
  profileUpdate, // Mise à jour profil
}

/// Classe pour les paramètres/préférences utilisateur
class UserPreferences {
  final String userId;
  final bool notificationsEnabled;
  final bool emailReminders;
  final bool pushNotifications;
  final String preferredLanguage;
  final ThemeMode themeMode;
  final bool shareStatistics;
  final String reminderTime; // Format "HH:mm"
  final List<String> interestedWasteTypes;
  final double radiusKm; // Rayon pour afficher les points de collecte

  const UserPreferences({
    required this.userId,
    this.notificationsEnabled = true,
    this.emailReminders = true,
    this.pushNotifications = true,
    this.preferredLanguage = 'fr',
    this.themeMode = ThemeMode.light,
    this.shareStatistics = false,
    this.reminderTime = '09:00',
    this.interestedWasteTypes = const [],
    this.radiusKm = 5.0,
  });

  /// Créer une copie avec modifications
  UserPreferences copyWith({
    String? userId,
    bool? notificationsEnabled,
    bool? emailReminders,
    bool? pushNotifications,
    String? preferredLanguage,
    ThemeMode? themeMode,
    bool? shareStatistics,
    String? reminderTime,
    List<String>? interestedWasteTypes,
    double? radiusKm,
  }) {
    return UserPreferences(
      userId: userId ?? this.userId,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailReminders: emailReminders ?? this.emailReminders,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      themeMode: themeMode ?? this.themeMode,
      shareStatistics: shareStatistics ?? this.shareStatistics,
      reminderTime: reminderTime ?? this.reminderTime,
      interestedWasteTypes: interestedWasteTypes ?? this.interestedWasteTypes,
      radiusKm: radiusKm ?? this.radiusKm,
    );
  }

  @override
  String toString() =>
      'UserPreferences(userId: $userId, language: $preferredLanguage, theme: $themeMode)';
}
