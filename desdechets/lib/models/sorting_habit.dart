/// Classe représentant les habitudes de tri d'un utilisateur
class SortingHabit {
  final String id;
  final String userId;
  final int totalCollections; // Nombre total de collectes
  final int totalWeight; // Poids total trié en kg
  final Map<String, int> wasteTypeCount; // Compte par type de déchet
  final DateTime lastCollection;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int currentStreak; // Nombre de jours consécutifs de tri
  final int bestStreak; // Meilleure séquence

  const SortingHabit({
    required this.id,
    required this.userId,
    this.totalCollections = 0,
    this.totalWeight = 0,
    this.wasteTypeCount = const {},
    required this.lastCollection,
    required this.createdAt,
    required this.updatedAt,
    this.currentStreak = 0,
    this.bestStreak = 0,
  });

  /// Calculer le score de tri (basé sur les collections et le poids)
  int calculateScore() {
    return (totalCollections * 10) + (totalWeight ~/ 5);
  }

  /// Obtenir le type de déchet le plus trié
  String getMostCommonWasteType() {
    if (wasteTypeCount.isEmpty) return 'Aucun';
    final maxEntry = wasteTypeCount.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );
    return maxEntry.key;
  }

  /// Créer une copie avec modifications
  SortingHabit copyWith({
    String? id,
    String? userId,
    int? totalCollections,
    int? totalWeight,
    Map<String, int>? wasteTypeCount,
    DateTime? lastCollection,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? currentStreak,
    int? bestStreak,
  }) {
    return SortingHabit(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      totalCollections: totalCollections ?? this.totalCollections,
      totalWeight: totalWeight ?? this.totalWeight,
      wasteTypeCount: wasteTypeCount ?? this.wasteTypeCount,
      lastCollection: lastCollection ?? this.lastCollection,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
    );
  }

  /// Convertir en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'totalCollections': totalCollections,
      'totalWeight': totalWeight,
      'wasteTypeCount': wasteTypeCount,
      'lastCollection': lastCollection.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
    };
  }

  /// Créer depuis JSON
  factory SortingHabit.fromJson(Map<String, dynamic> json) {
    final wasteTypeCountRaw = json['wasteTypeCount'] as Map? ?? {};
    final wasteTypeCount = wasteTypeCountRaw.map(
      (key, value) => MapEntry(key as String, (value as num).toInt()),
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

  @override
  String toString() =>
      'SortingHabit(userId: $userId, totalCollections: $totalCollections, score: ${calculateScore()})';
}
