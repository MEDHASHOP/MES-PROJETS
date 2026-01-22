/// Classe représentant un conseil de recyclage
class RecyclingTip {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String category; // ex: "plastique", "verre", "tri", "conseils"
  final int difficulty; // 1 à 5 (1 = facile, 5 = difficile)
  final List<String> tags;
  final String? videoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int viewCount;
  final double rating; // Note de 0 à 5

  const RecyclingTip({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.category,
    this.difficulty = 2,
    this.tags = const [],
    this.videoUrl,
    required this.createdAt,
    required this.updatedAt,
    this.viewCount = 0,
    this.rating = 0.0,
  });

  /// Obtenir un emoji selon la catégorie
  String get categoryEmoji {
    switch (category.toLowerCase()) {
      case 'plastique':
        return '🟦';
      case 'verre':
        return '🟩';
      case 'organique':
        return '🟨';
      case 'papier':
        return '📄';
      case 'métal':
        return '🔧';
      case 'conseil':
        return '💡';
      case 'astuces':
        return '⭐';
      default:
        return '♻️';
    }
  }

  /// Obtenir le niveau de difficulté en texte
  String get difficultyText {
    switch (difficulty) {
      case 1:
        return 'Très facile';
      case 2:
        return 'Facile';
      case 3:
        return 'Moyen';
      case 4:
        return 'Difficile';
      case 5:
        return 'Très difficile';
      default:
        return 'Inconnu';
    }
  }

  /// Créer une copie avec modifications
  RecyclingTip copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? category,
    int? difficulty,
    List<String>? tags,
    String? videoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? viewCount,
    double? rating,
  }) {
    return RecyclingTip(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
      videoUrl: videoUrl ?? this.videoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      viewCount: viewCount ?? this.viewCount,
      rating: rating ?? this.rating,
    );
  }

  /// Convertir en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'difficulty': difficulty,
      'tags': tags,
      'videoUrl': videoUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'viewCount': viewCount,
      'rating': rating,
    };
  }

  /// Créer depuis JSON
  factory RecyclingTip.fromJson(Map<String, dynamic> json) {
    return RecyclingTip(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String,
      difficulty: json['difficulty'] as int? ?? 2,
      tags: List<String>.from(json['tags'] as List? ?? []),
      videoUrl: json['videoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      viewCount: json['viewCount'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  String toString() =>
      'RecyclingTip(id: $id, title: $title, category: $category, difficulty: $difficultyText)';
}
