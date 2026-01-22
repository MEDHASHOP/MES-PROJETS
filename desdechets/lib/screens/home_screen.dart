import 'package:flutter/material.dart';
import '../models/index.dart';

/// Classe représentant l'état et la logique de l'écran d'accueil
class HomeScreenState {
  final User? currentUser;
  final int upcomingCollections; // Collectes à venir
  final int totalPoints; // Points de collecte disponibles
  final RecyclingTip? featuredTip; // Conseil en avant
  final SortingHabit? sortingHabit;
  final bool isLoading;
  final String? error;

  const HomeScreenState({
    this.currentUser,
    this.upcomingCollections = 0,
    this.totalPoints = 0,
    this.featuredTip,
    this.sortingHabit,
    this.isLoading = false,
    this.error,
  });

  /// Créer une copie avec modifications
  HomeScreenState copyWith({
    User? currentUser,
    int? upcomingCollections,
    int? totalPoints,
    RecyclingTip? featuredTip,
    SortingHabit? sortingHabit,
    bool? isLoading,
    String? error,
  }) {
    return HomeScreenState(
      currentUser: currentUser ?? this.currentUser,
      upcomingCollections: upcomingCollections ?? this.upcomingCollections,
      totalPoints: totalPoints ?? this.totalPoints,
      featuredTip: featuredTip ?? this.featuredTip,
      sortingHabit: sortingHabit ?? this.sortingHabit,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'HomeScreenState(user: ${currentUser?.email}, upcomingCollections: $upcomingCollections)';
}

/// Widget pour la carte d'accès rapide
class QuickAccessCard {
  final String title;
  final String icon;
  final String route;
  final Color color;
  final String description;

  const QuickAccessCard({
    required this.title,
    required this.icon,
    required this.route,
    required this.color,
    required this.description,
  });
}

/// Données des cartes d'accès rapide pré-définies
class QuickAccessCards {
  static const List<QuickAccessCard> defaultCards = [
    QuickAccessCard(
      title: 'Calendrier',
      icon: '📅',
      route: '/calendar',
      color: Color(0xFF4CAF50),
      description: 'Consultez les jours de collecte',
    ),
    QuickAccessCard(
      title: 'Carte',
      icon: '🗺️',
      route: '/map',
      color: Color(0xFF2196F3),
      description: 'Trouvez les points de collecte',
    ),
    QuickAccessCard(
      title: 'Conseils',
      icon: '💡',
      route: '/tips',
      color: Color(0xFFFFC107),
      description: 'Apprenez à trier correctement',
    ),
  ];
}

/// Widget représentant une section de statistiques
class StatisticWidget {
  final String title;
  final String value;
  final String unit;
  final String icon;
  final Color color;

  const StatisticWidget({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  String toString() => 'StatisticWidget(title: $title, value: $value$unit)';
}
