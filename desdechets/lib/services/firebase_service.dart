import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/index.dart';

/// Service pour la gestion de Firebase Firestore
class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Noms des collections Firestore
  static const String usersCollection = 'users';
  static const String collectionsPointCollection = 'collection_points';
  static const String wasteCollectionsCollection = 'waste_collections';
  static const String recyclingTipsCollection = 'recycling_tips';
  static const String sharedCalendarCollection = 'shared_calendars';
  static const String reviewsCollection = 'reviews';

  /// --- MÉTHODES POUR LES POINTS DE COLLECTE ---

  /// Sauvegarder ou mettre à jour un point de collecte
  Future<void> saveCollectionPoint(CollectionPoint point) async {
    try {
      await _firestore
          .collection(collectionsPointCollection)
          .doc(point.id)
          .set(_collectionPointToJson(point), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Erreur lors de la sauvegarde du point: $e');
    }
  }

  /// Obtenir tous les points de collecte
  Future<List<CollectionPoint>> getAllCollectionPoints() async {
    try {
      final snapshot = await _firestore
          .collection(collectionsPointCollection)
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => _jsonToCollectionPoint(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des points: $e');
    }
  }

  /// Obtenir les points de collecte filtrés par type de déchet
  Future<List<CollectionPoint>> getCollectionPointsByWasteType(
    String wasteType,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(collectionsPointCollection)
          .where('acceptedWasteTypes', arrayContains: wasteType)
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => _jsonToCollectionPoint(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des points par type: $e');
    }
  }

  /// Écouter les changements en temps réel des points de collecte
  Stream<List<CollectionPoint>> watchCollectionPoints() {
    return _firestore
        .collection(collectionsPointCollection)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => _jsonToCollectionPoint(doc.data()))
              .toList(),
        );
  }

  /// Obtenir un point de collecte spécifique
  Future<CollectionPoint?> getCollectionPoint(String pointId) async {
    try {
      final doc = await _firestore
          .collection(collectionsPointCollection)
          .doc(pointId)
          .get();

      if (!doc.exists) return null;
      return _jsonToCollectionPoint(doc.data()!);
    } catch (e) {
      throw Exception('Erreur lors de la récupération du point: $e');
    }
  }

  /// --- MÉTHODES POUR LE CALENDRIER PARTAGÉ ---

  /// Sauvegarder une collecte planifiée
  Future<void> saveWasteCollection(WasteCollection collection) async {
    try {
      await _firestore
          .collection(wasteCollectionsCollection)
          .doc(collection.id)
          .set(_wasteCollectionToJson(collection), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Erreur lors de la sauvegarde de la collecte: $e');
    }
  }

  /// Obtenir les collectes d'un utilisateur
  Future<List<WasteCollection>> getUserWasteCollections(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(wasteCollectionsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('collectionDate', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => _jsonToWasteCollection(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des collectes: $e');
    }
  }

  /// Obtenir les collectes pour une période donnée
  Future<List<WasteCollection>> getCollectionsForDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(wasteCollectionsCollection)
          .where('userId', isEqualTo: userId)
          .where('collectionDate', isGreaterThanOrEqualTo: startDate)
          .where('collectionDate', isLessThanOrEqualTo: endDate)
          .orderBy('collectionDate', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => _jsonToWasteCollection(doc.data()))
          .toList();
    } catch (e) {
      throw Exception(
        'Erreur lors de la récupération des collectes pour la période: $e',
      );
    }
  }

  /// Écouter les changements du calendrier partagé
  Stream<List<WasteCollection>> watchUserWasteCollections(String userId) {
    return _firestore
        .collection(wasteCollectionsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('collectionDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => _jsonToWasteCollection(doc.data()))
              .toList(),
        );
  }

  /// Mettre à jour le statut d'une collecte
  Future<void> updateCollectionStatus(
    String collectionId,
    bool completed,
  ) async {
    try {
      await _firestore
          .collection(wasteCollectionsCollection)
          .doc(collectionId)
          .update({'completed': completed, 'updatedAt': DateTime.now()});
    } catch (e) {
      throw Exception(
        'Erreur lors de la mise à jour du statut de la collecte: $e',
      );
    }
  }

  /// Supprimer une collecte
  Future<void> deleteWasteCollection(String collectionId) async {
    try {
      await _firestore
          .collection(wasteCollectionsCollection)
          .doc(collectionId)
          .delete();
    } catch (e) {
      throw Exception('Erreur lors de la suppression de la collecte: $e');
    }
  }

  /// --- MÉTHODES POUR LES CONSEILS ---

  /// Obtenir tous les conseils
  Future<List<RecyclingTip>> getAllRecyclingTips() async {
    try {
      final snapshot = await _firestore
          .collection(recyclingTipsCollection)
          .get();

      return snapshot.docs
          .map((doc) => _jsonToRecyclingTip(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des conseils: $e');
    }
  }

  /// Obtenir les conseils par catégorie
  Future<List<RecyclingTip>> getRecyclingTipsByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection(recyclingTipsCollection)
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs
          .map((doc) => _jsonToRecyclingTip(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des conseils: $e');
    }
  }

  /// Écouter les changements des conseils
  Stream<List<RecyclingTip>> watchRecyclingTips() {
    return _firestore
        .collection(recyclingTipsCollection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => _jsonToRecyclingTip(doc.data()))
              .toList(),
        );
  }

  /// Obtenir un conseil spécifique
  Future<RecyclingTip?> getRecyclingTip(String tipId) async {
    try {
      final doc = await _firestore
          .collection(recyclingTipsCollection)
          .doc(tipId)
          .get();

      if (!doc.exists) return null;
      return _jsonToRecyclingTip(doc.data()!);
    } catch (e) {
      throw Exception('Erreur lors de la récupération du conseil: $e');
    }
  }

  /// Incrémenter le nombre de vues d'un conseil
  Future<void> incrementTipViewCount(String tipId) async {
    try {
      await _firestore.collection(recyclingTipsCollection).doc(tipId).update({
        'viewCount': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour des vues: $e');
    }
  }

  /// Ajouter un commentaire à un conseil
  Future<void> addTipComment(
    String tipId,
    String userId,
    String comment,
    double rating,
  ) async {
    try {
      await _firestore
          .collection(recyclingTipsCollection)
          .doc(tipId)
          .collection(reviewsCollection)
          .add({
            'userId': userId,
            'comment': comment,
            'rating': rating,
            'createdAt': DateTime.now(),
            'likes': 0,
          });
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout du commentaire: $e');
    }
  }

  /// --- MÉTHODES POUR LES UTILISATEURS ---

  /// Sauvegarder ou mettre à jour un utilisateur
  Future<void> saveUser(User user) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(user.id)
          .set(_userToJson(user), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Erreur lors de la sauvegarde de l\'utilisateur: $e');
    }
  }

  /// Obtenir un utilisateur
  Future<User?> getUser(String userId) async {
    try {
      final doc = await _firestore
          .collection(usersCollection)
          .doc(userId)
          .get();

      if (!doc.exists) return null;
      return _jsonToUser(doc.data()!);
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'utilisateur: $e');
    }
  }

  /// --- CONVERTISSEURS JSON ---

  Map<String, dynamic> _collectionPointToJson(CollectionPoint point) {
    return {
      'id': point.id,
      'name': point.name,
      'description': point.description,
      'latitude': point.latitude,
      'longitude': point.longitude,
      'address': point.address,
      'city': point.city,
      'postalCode': point.postalCode,
      'acceptedWasteTypes': point.acceptedWasteTypes,
      'phoneNumber': point.phoneNumber,
      'email': point.email,
      'website': point.website,
      'schedule': point.schedule?.toJson(),
      'rating': point.rating,
      'reviewCount': point.reviewCount,
      'imageUrl': point.imageUrl,
      'updatedAt': point.updatedAt,
      'isActive': point.isActive,
    };
  }

  CollectionPoint _jsonToCollectionPoint(Map<String, dynamic> json) {
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
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> _wasteCollectionToJson(WasteCollection collection) {
    return {
      'id': collection.id,
      'userId': collection.userId,
      'type': collection.type.toString(),
      'collectionDate': collection.collectionDate,
      'location': collection.location,
      'latitude': collection.latitude,
      'longitude': collection.longitude,
      'quantity': collection.quantity,
      'notes': collection.notes,
      'createdAt': collection.createdAt,
      'completed': collection.completed,
    };
  }

  WasteCollection _jsonToWasteCollection(Map<String, dynamic> json) {
    return WasteCollection(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: WasteType.values.firstWhere(
        (type) => type.toString() == json['type'],
        orElse: () => WasteType.mixed,
      ),
      collectionDate: (json['collectionDate'] as Timestamp).toDate(),
      location: json['location'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      quantity: json['quantity'] as int? ?? 0,
      notes: json['notes'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      completed: json['completed'] as bool? ?? false,
    );
  }

  RecyclingTip _jsonToRecyclingTip(Map<String, dynamic> json) {
    return RecyclingTip(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String,
      difficulty: json['difficulty'] as int? ?? 2,
      tags: List<String>.from(json['tags'] as List? ?? []),
      videoUrl: json['videoUrl'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      viewCount: json['viewCount'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> _userToJson(User user) {
    return {
      'id': user.id,
      'email': user.email,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'profileImage': user.profileImage,
      'address': user.address,
      'phoneNumber': user.phoneNumber,
      'createdAt': user.createdAt,
      'updatedAt': user.updatedAt,
      'notificationsEnabled': user.notificationsEnabled,
      'sortingScore': user.sortingScore,
    };
  }

  User _jsonToUser(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      profileImage: json['profileImage'] as String?,
      address: json['address'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      sortingScore: json['sortingScore'] as int? ?? 0,
    );
  }
}
