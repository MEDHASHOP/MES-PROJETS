import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/index.dart';

/// Classe représentant l'état de l'écran carte
class MapScreenState {
  final List<CollectionPoint> collectionPoints;
  final CollectionPoint? selectedPoint;
  final double? userLatitude;
  final double? userLongitude;
  final double zoomLevel;
  final List<String> selectedWasteFilters; // Filtres par type de déchet
  final bool isLoading;
  final bool showCluster; // Afficher les points regroupés
  final String? error;
  final SortOption sortOption;

  const MapScreenState({
    this.collectionPoints = const [],
    this.selectedPoint,
    this.userLatitude,
    this.userLongitude,
    this.zoomLevel = 15.0,
    this.selectedWasteFilters = const [],
    this.isLoading = false,
    this.showCluster = true,
    this.error,
    this.sortOption = SortOption.distance,
  });

  /// Obtenir les points filtrés
  List<CollectionPoint> getFilteredPoints() {
    if (selectedWasteFilters.isEmpty) return collectionPoints;

    return collectionPoints
        .where(
          (point) => point.acceptedWasteTypes.any(
            (type) => selectedWasteFilters.any(
              (filter) => type.toLowerCase() == filter.toLowerCase(),
            ),
          ),
        )
        .toList();
  }

  /// Obtenir les points triés
  List<CollectionPoint> getSortedPoints() {
    final filtered = getFilteredPoints();

    switch (sortOption) {
      case SortOption.distance:
        return filtered..sort((a, b) {
          final aDist = a.distanceKm ?? double.maxFinite;
          final bDist = b.distanceKm ?? double.maxFinite;
          return aDist.compareTo(bDist);
        });
      case SortOption.rating:
        return filtered..sort((a, b) => b.rating.compareTo(a.rating));
      case SortOption.name:
        return filtered..sort((a, b) => a.name.compareTo(b.name));
      case SortOption.openNow:
        return filtered..sort((a, b) {
          final aOpen = (a.schedule?.isOpenToday() ?? false) ? 0 : 1;
          final bOpen = (b.schedule?.isOpenToday() ?? false) ? 0 : 1;
          return aOpen.compareTo(bOpen);
        });
    }
  }

  /// Créer une copie avec modifications
  MapScreenState copyWith({
    List<CollectionPoint>? collectionPoints,
    CollectionPoint? selectedPoint,
    double? userLatitude,
    double? userLongitude,
    double? zoomLevel,
    List<String>? selectedWasteFilters,
    bool? isLoading,
    bool? showCluster,
    String? error,
    SortOption? sortOption,
  }) {
    return MapScreenState(
      collectionPoints: collectionPoints ?? this.collectionPoints,
      selectedPoint: selectedPoint ?? this.selectedPoint,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      selectedWasteFilters: selectedWasteFilters ?? this.selectedWasteFilters,
      isLoading: isLoading ?? this.isLoading,
      showCluster: showCluster ?? this.showCluster,
      error: error ?? this.error,
      sortOption: sortOption ?? this.sortOption,
    );
  }

  @override
  String toString() =>
      'MapScreenState(pointsCount: ${collectionPoints.length}, selectedPoint: ${selectedPoint?.name})';
}

/// Options de tri des points de collecte
enum SortOption {
  distance, // Par distance
  rating, // Par notation
  name, // Par nom
  openNow, // Ouverts maintenant
}

/// Classe représentant un marqueur sur la carte
class MapMarker {
  final String id;
  final double latitude;
  final double longitude;
  final String title;
  final String? snippet; // Description courte
  final MarkerType type;
  final String? imageUrl;
  final Color color;

  const MapMarker({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.title,
    this.snippet,
    required this.type,
    this.imageUrl,
    required this.color,
  });

  /// Créer depuis un CollectionPoint
  factory MapMarker.fromCollectionPoint(CollectionPoint point) {
    return MapMarker(
      id: point.id,
      latitude: point.latitude,
      longitude: point.longitude,
      title: point.name,
      snippet: point.address,
      type: MarkerType.collectionPoint,
      imageUrl: point.imageUrl,
      color: Colors.blue,
    );
  }

  /// Créer pour la localisation de l'utilisateur
  factory MapMarker.userLocation({
    required double latitude,
    required double longitude,
  }) {
    return MapMarker(
      id: 'user_location',
      latitude: latitude,
      longitude: longitude,
      title: 'Ma localisation',
      type: MarkerType.userLocation,
      color: Colors.green,
    );
  }

  @override
  String toString() =>
      'MapMarker(id: $id, title: $title, lat: $latitude, lng: $longitude)';
}

/// Type de marqueur
enum MarkerType {
  collectionPoint, // Point de collecte
  userLocation, // Localisation utilisateur
  cluster, // Point regroupé
}

/// Classe pour les clusters de points
class PointCluster {
  final String id;
  final double latitude;
  final double longitude;
  final List<CollectionPoint> points;
  final int count;

  const PointCluster({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.points = const [],
    required this.count,
  });

  /// Créer une copie avec modifications
  PointCluster copyWith({
    String? id,
    double? latitude,
    double? longitude,
    List<CollectionPoint>? points,
    int? count,
  }) {
    return PointCluster(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      points: points ?? this.points,
      count: count ?? this.count,
    );
  }

  @override
  String toString() =>
      'PointCluster(id: $id, count: $count, lat: $latitude, lng: $longitude)';
}

/// Classe pour les itinéraires entre deux points
class Route {
  final String id;
  final MapMarker origin;
  final MapMarker destination;
  final List<LatLng> polylinePoints;
  final int distanceMeters;
  final int durationSeconds;
  final String? transportMode;

  const Route({
    required this.id,
    required this.origin,
    required this.destination,
    this.polylinePoints = const [],
    required this.distanceMeters,
    required this.durationSeconds,
    this.transportMode, // "driving", "walking", "transit"
  });

  /// Obtenir la distance en km
  String get distanceKm => '${(distanceMeters / 1000).toStringAsFixed(1)} km';

  /// Obtenir la durée formatée
  String get durationFormatted {
    if (durationSeconds < 60) {
      return '${durationSeconds}s';
    } else if (durationSeconds < 3600) {
      final minutes = (durationSeconds / 60).toStringAsFixed(0);
      return '${minutes}m';
    } else {
      final hours = (durationSeconds / 3600).toStringAsFixed(0);
      final minutes = (((durationSeconds % 3600) / 60).toStringAsFixed(0));
      return '${hours}h ${minutes}m';
    }
  }

  @override
  String toString() =>
      'Route(id: $id, distance: $distanceKm, duration: $durationFormatted)';
}

/// Classe pour les coordonnées
class LatLng {
  final double latitude;
  final double longitude;

  const LatLng({required this.latitude, required this.longitude});

  /// Calculer la distance entre deux points (formule Haversine)
  double distanceTo(LatLng other) {
    const earthRadius = 6371000; // en mètres
    final lat1Rad = _toRad(latitude);
    final lat2Rad = _toRad(other.latitude);
    final deltaLatRad = _toRad(other.latitude - latitude);
    final deltaLngRad = _toRad(other.longitude - longitude);

    final a =
        math.sin(deltaLatRad / 2) * math.sin(deltaLatRad / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(deltaLngRad / 2) *
            math.sin(deltaLngRad / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRad(double degree) => degree * 3.14159265359 / 180;

  @override
  String toString() => 'LatLng($latitude, $longitude)';
}
