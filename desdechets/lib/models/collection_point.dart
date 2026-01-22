/// Classe représentant un point de collecte
class CollectionPoint {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String postalCode;
  final List<String> acceptedWasteTypes; // Types de déchets acceptés
  final String? phoneNumber;
  final String? email;
  final String? website;
  final CollectionPointSchedule? schedule;
  final double rating; // Note de 0 à 5
  final int reviewCount;
  final String? imageUrl;
  final DateTime updatedAt;
  final bool isActive;
  final double? distanceKm; // Distance en km (calculée dynamiquement)

  const CollectionPoint({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.acceptedWasteTypes,
    this.phoneNumber,
    this.email,
    this.website,
    this.schedule,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.imageUrl,
    required this.updatedAt,
    this.isActive = true,
    this.distanceKm,
  });

  /// Obtenir le texte pour les distances
  String get distanceText {
    if (distanceKm == null) return 'Distance inconnue';
    if (distanceKm! < 1) {
      return '${(distanceKm! * 1000).toStringAsFixed(0)} m';
    }
    return '${distanceKm!.toStringAsFixed(1)} km';
  }

  /// Vérifier si le point accepte un type de déchet
  bool acceptsWasteType(String wasteType) {
    return acceptedWasteTypes.any(
      (type) => type.toLowerCase() == wasteType.toLowerCase(),
    );
  }

  /// Créer une copie avec modifications
  CollectionPoint copyWith({
    String? id,
    String? name,
    String? description,
    double? latitude,
    double? longitude,
    String? address,
    String? city,
    String? postalCode,
    List<String>? acceptedWasteTypes,
    String? phoneNumber,
    String? email,
    String? website,
    CollectionPointSchedule? schedule,
    double? rating,
    int? reviewCount,
    String? imageUrl,
    DateTime? updatedAt,
    bool? isActive,
    double? distanceKm,
  }) {
    return CollectionPoint(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      acceptedWasteTypes: acceptedWasteTypes ?? this.acceptedWasteTypes,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      website: website ?? this.website,
      schedule: schedule ?? this.schedule,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      imageUrl: imageUrl ?? this.imageUrl,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }

  /// Convertir en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'postalCode': postalCode,
      'acceptedWasteTypes': acceptedWasteTypes,
      'phoneNumber': phoneNumber,
      'email': email,
      'website': website,
      'schedule': schedule?.toJson(),
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrl': imageUrl,
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  /// Créer depuis JSON
  factory CollectionPoint.fromJson(Map<String, dynamic> json) {
    return CollectionPoint(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      city: json['city'] as String,
      postalCode: json['postalCode'] as String,
      acceptedWasteTypes: List<String>.from(json['acceptedWasteTypes'] as List),
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      schedule: json['schedule'] != null
          ? CollectionPointSchedule.fromJson(json['schedule'])
          : null,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String?,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  @override
  String toString() =>
      'CollectionPoint(id: $id, name: $name, city: $city, types: ${acceptedWasteTypes.join(", ")})';
}

/// Classe représentant l'horaire d'un point de collecte
class CollectionPointSchedule {
  final String monday;
  final String tuesday;
  final String wednesday;
  final String thursday;
  final String friday;
  final String saturday;
  final String sunday;
  final List<String> holidays; // Jours fériés fermés

  const CollectionPointSchedule({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
    this.holidays = const [],
  });

  /// Obtenir l'horaire pour un jour spécifique (0 = lundi, 6 = dimanche)
  String getScheduleForDay(int dayOfWeek) {
    switch (dayOfWeek) {
      case 0:
        return monday;
      case 1:
        return tuesday;
      case 2:
        return wednesday;
      case 3:
        return thursday;
      case 4:
        return friday;
      case 5:
        return saturday;
      case 6:
        return sunday;
      default:
        return 'Inconnu';
    }
  }

  /// Vérifier si le point est ouvert aujourd'hui
  bool isOpenToday() {
    final today = DateTime.now();
    final scheduleForToday = getScheduleForDay(today.weekday - 1);
    return scheduleForToday.toLowerCase() != 'fermé';
  }

  /// Créer depuis JSON
  factory CollectionPointSchedule.fromJson(Map<String, dynamic> json) {
    return CollectionPointSchedule(
      monday: json['monday'] as String? ?? 'Fermé',
      tuesday: json['tuesday'] as String? ?? 'Fermé',
      wednesday: json['wednesday'] as String? ?? 'Fermé',
      thursday: json['thursday'] as String? ?? 'Fermé',
      friday: json['friday'] as String? ?? 'Fermé',
      saturday: json['saturday'] as String? ?? 'Fermé',
      sunday: json['sunday'] as String? ?? 'Fermé',
      holidays: List<String>.from(json['holidays'] as List? ?? []),
    );
  }

  /// Convertir en JSON
  Map<String, dynamic> toJson() {
    return {
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday,
      'sunday': sunday,
      'holidays': holidays,
    };
  }

  @override
  String toString() =>
      'CollectionPointSchedule(monday: $monday, ..., isOpenToday: ${isOpenToday()})';
}
