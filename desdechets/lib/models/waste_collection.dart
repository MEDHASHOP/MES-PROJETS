/// Énumération des types de déchets
enum WasteType {
  plastic, // Plastique
  glass, // Verre
  organic, // Organique
  paper, // Papier
  metal, // Métal
  electronic, // Électronique
  mixed, // Mélangé
}

extension WasteTypeExtension on WasteType {
  String get displayName {
    switch (this) {
      case WasteType.plastic:
        return 'Plastique';
      case WasteType.glass:
        return 'Verre';
      case WasteType.organic:
        return 'Organique';
      case WasteType.paper:
        return 'Papier';
      case WasteType.metal:
        return 'Métal';
      case WasteType.electronic:
        return 'Électronique';
      case WasteType.mixed:
        return 'Mélangé';
    }
  }

  String get icon {
    switch (this) {
      case WasteType.plastic:
        return '🟦';
      case WasteType.glass:
        return '🟩';
      case WasteType.organic:
        return '🟨';
      case WasteType.paper:
        return '🟫';
      case WasteType.metal:
        return '⬜';
      case WasteType.electronic:
        return '⚡';
      case WasteType.mixed:
        return '🎨';
    }
  }
}

/// Classe représentant une collecte de déchets
class WasteCollection {
  final String id;
  final String userId;
  final WasteType type;
  final DateTime collectionDate;
  final String? location;
  final double? latitude;
  final double? longitude;
  final int quantity; // En kilogrammes
  final String? notes;
  final DateTime createdAt;
  final bool completed;

  const WasteCollection({
    required this.id,
    required this.userId,
    required this.type,
    required this.collectionDate,
    this.location,
    this.latitude,
    this.longitude,
    this.quantity = 0,
    this.notes,
    required this.createdAt,
    this.completed = false,
  });

  /// Créer une copie avec modifications
  WasteCollection copyWith({
    String? id,
    String? userId,
    WasteType? type,
    DateTime? collectionDate,
    String? location,
    double? latitude,
    double? longitude,
    int? quantity,
    String? notes,
    DateTime? createdAt,
    bool? completed,
  }) {
    return WasteCollection(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      collectionDate: collectionDate ?? this.collectionDate,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      completed: completed ?? this.completed,
    );
  }

  /// Convertir en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.toString(),
      'collectionDate': collectionDate.toIso8601String(),
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'quantity': quantity,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'completed': completed,
    };
  }

  /// Créer depuis JSON
  factory WasteCollection.fromJson(Map<String, dynamic> json) {
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
      completed: json['completed'] as bool? ?? false,
    );
  }

  @override
  String toString() =>
      'WasteCollection(id: $id, type: ${type.displayName}, date: $collectionDate, completed: $completed)';
}
