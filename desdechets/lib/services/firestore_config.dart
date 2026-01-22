/// Configuration pour Firestore
class FirestoreConfig {
  /// Schéma de la collection "collection_points"
  /// - id (String) : identifiant unique
  /// - name (String) : nom du point de collecte
  /// - description (String) : description
  /// - latitude (Number) : latitude GPS
  /// - longitude (Number) : longitude GPS
  /// - address (String) : adresse complète
  /// - city (String) : ville
  /// - postalCode (String) : code postal
  /// - acceptedWasteTypes (Array) : types de déchets acceptés
  /// - phoneNumber (String, optional) : numéro de téléphone
  /// - email (String, optional) : email de contact
  /// - website (String, optional) : site web
  /// - schedule (Map, optional) : horaires d'ouverture
  ///   - monday (String) : horaires lundi
  ///   - tuesday (String) : horaires mardi
  ///   - wednesday (String) : horaires mercredi
  ///   - thursday (String) : horaires jeudi
  ///   - friday (String) : horaires vendredi
  ///   - saturday (String) : horaires samedi
  ///   - sunday (String) : horaires dimanche
  ///   - holidays (Array) : jours fériés
  /// - rating (Number) : note de 0 à 5
  /// - reviewCount (Number) : nombre d'avis
  /// - imageUrl (String, optional) : URL de l'image
  /// - updatedAt (Timestamp) : date de mise à jour
  /// - isActive (Boolean) : si le point est actif

  /// Schéma de la collection "waste_collections"
  /// - id (String) : identifiant unique
  /// - userId (String) : ID de l'utilisateur
  /// - type (String) : type de déchet (enum)
  /// - collectionDate (Timestamp) : date de collecte
  /// - location (String, optional) : lieu de collecte
  /// - latitude (Number, optional) : latitude GPS
  /// - longitude (Number, optional) : longitude GPS
  /// - quantity (Number) : quantité en kg
  /// - notes (String, optional) : notes supplémentaires
  /// - createdAt (Timestamp) : date de création
  /// - completed (Boolean) : si la collecte est complétée

  /// Schéma de la collection "recycling_tips"
  /// - id (String) : identifiant unique
  /// - title (String) : titre du conseil
  /// - description (String) : description complète
  /// - imageUrl (String, optional) : URL de l'image
  /// - category (String) : catégorie du conseil
  /// - difficulty (Number) : niveau de difficulté 1-5
  /// - tags (Array) : tags du conseil
  /// - videoUrl (String, optional) : URL de la vidéo
  /// - createdAt (Timestamp) : date de création
  /// - updatedAt (Timestamp) : date de mise à jour
  /// - viewCount (Number) : nombre de vues
  /// - rating (Number) : note de 0 à 5
  /// - reviews (SubCollection) : avis et commentaires
  ///   - userId (String)
  ///   - comment (String)
  ///   - rating (Number)
  ///   - createdAt (Timestamp)
  ///   - likes (Number)

  /// Schéma de la collection "users"
  /// - id (String) : identifiant unique (UID Firebase)
  /// - email (String) : adresse email
  /// - firstName (String) : prénom
  /// - lastName (String) : nom
  /// - profileImage (String, optional) : URL de la photo de profil
  /// - address (String) : adresse
  /// - phoneNumber (String, optional) : numéro de téléphone
  /// - createdAt (Timestamp) : date de création du compte
  /// - updatedAt (Timestamp) : date de dernière mise à jour
  /// - notificationsEnabled (Boolean) : si les notifications sont activées
  /// - sortingScore (Number) : score de tri

  /// Schéma de la collection "shared_calendars"
  /// - id (String) : identifiant unique
  /// - userId (String) : ID de l'utilisateur propriétaire
  /// - events (Array) : liste des événements de collecte
  /// - sharedWith (Array) : liste des IDs d'utilisateurs avec accès
  /// - createdAt (Timestamp) : date de création
  /// - updatedAt (Timestamp) : date de mise à jour

  /// Index Firestore recommandés
  /// 1. collection_points: isActive, updatedAt (DESC)
  /// 2. waste_collections: userId, collectionDate (DESC)
  /// 3. waste_collections: userId, completed
  /// 4. recycling_tips: category, updatedAt (DESC)
  /// 5. recycling_tips: category, difficulty (ASC)

  static const String collectionsPointsCollection = 'collection_points';
  static const String wasteCollectionsCollection = 'waste_collections';
  static const String recyclingTipsCollection = 'recycling_tips';
  static const String usersCollection = 'users';
  static const String sharedCalendarsCollection = 'shared_calendars';
  static const String reviewsCollection = 'reviews';

  /// Règles de sécurité Firestore
  static const String firestoreRules = '''
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permettre aux utilisateurs de lire les points de collecte publics
    match /collection_points/{document=**} {
      allow read: if request.auth != null;
      allow write: if request.auth.token.admin == true;
    }

    // Permettre aux utilisateurs de gérer leurs propres collectes
    match /waste_collections/{document=**} {
      allow read: if request.auth != null && resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update, delete: if request.auth != null && resource.data.userId == request.auth.uid;
    }

    // Permettre aux utilisateurs de lire les conseils
    match /recycling_tips/{document=**} {
      allow read: if request.auth != null;
      allow write: if request.auth.token.admin == true;
      
      // Permettre les commentaires
      match /reviews/{review=**} {
        allow read: if request.auth != null;
        allow create: if request.auth != null;
        allow update, delete: if request.auth != null && resource.data.userId == request.auth.uid;
      }
    }

    // Permettre aux utilisateurs de gérer leur profil
    match /users/{uid} {
      allow read: if request.auth != null && uid == request.auth.uid;
      allow write: if request.auth != null && uid == request.auth.uid;
    }
  }
}
''';
}
