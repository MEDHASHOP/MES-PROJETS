# Gestion des Données - DésDéchets

## Architecture

L'application utilise une architecture en couches pour la gestion des données :

```
UI (Widgets Flutter)
    ↓
Providers (Riverpod) - Gestion d'état
    ↓
Repositories - Abstraction des données
    ↓
Services (Local DB + Firebase)
    ↓
Données (SQLite + Firestore)
```

## 1. Base de Données Locale (SQLite) - sqflite

### Description
Stockage des données locales pour :
- ✅ Préférences utilisateur
- ✅ Historique de tri
- ✅ Cache des données Firebase
- ✅ Réussites débloquées
- ✅ Conseils favoris

### Tables

#### `users`
```dart
- id (TEXT PRIMARY KEY)
- email (TEXT UNIQUE)
- firstName, lastName
- profileImage, address, phoneNumber
- createdAt, updatedAt
- notificationsEnabled, sortingScore
```

#### `preferences`
```dart
- id (TEXT PRIMARY KEY)
- userId (FOREIGN KEY)
- notificationsEnabled, emailReminders, pushNotifications
- preferredLanguage, themeMode
- shareStatistics
- reminderTime, interestedWasteTypes, radiusKm
- createdAt, updatedAt
```

#### `collections`
```dart
- id (TEXT PRIMARY KEY)
- userId (FOREIGN KEY)
- type, collectionDate, location
- latitude, longitude
- quantity, notes
- createdAt, completed
```

#### `sorting_habits`
```dart
- id (TEXT PRIMARY KEY)
- userId (FOREIGN KEY)
- totalCollections, totalWeight
- wasteTypeCount (JSON)
- lastCollection
- currentStreak, bestStreak
- createdAt, updatedAt
```

#### `saved_tips` (Favoris)
```dart
- id (TEXT PRIMARY KEY)
- tipId, userId
- savedAt
```

#### `achievements` (Réussites)
```dart
- id (TEXT PRIMARY KEY)
- userId, achievementId
- unlockedAt, progress
```

### Utilisation

```dart
final dbService = LocalDatabaseService();

// Sauvegarder un utilisateur
await dbService.saveUser(user);

// Obtenir un utilisateur
final user = await dbService.getUser(userId);

// Obtenir les collectes du mois
final collections = await dbService.getCollectionsForMonth(userId, month);

// Ajouter aux favoris
await dbService.saveTipAsFavorite(userId, tipId);
```

## 2. Firebase Firestore - Données en Temps Réel

### Collections et Schémas

#### `collection_points`
Points de collecte mis à jour en temps réel
```json
{
  "id": "point_1",
  "name": "Déchetterie Centre-Ville",
  "description": "Centre de tri principal",
  "latitude": 48.8566,
  "longitude": 2.3522,
  "address": "123 Rue de la Paix",
  "city": "abidjan",
  "postalCode": "75001",
  "acceptedWasteTypes": ["plastic", "glass", "organic"],
  "schedule": {
    "monday": "08:00-18:00",
    "tuesday": "08:00-18:00",
    ...
  },
  "rating": 4.5,
  "reviewCount": 42,
  "isActive": true,
  "updatedAt": "2026-01-21T10:30:00Z"
}
```

#### `waste_collections`
Calendrier partagé des collectes
```json
{
  "id": "collection_1",
  "userId": "user_123",
  "type": "plastic",
  "collectionDate": "2026-01-25T10:00:00Z",
  "location": "Rue de la Paix",
  "quantity": 5,
  "completed": false,
  "createdAt": "2026-01-21T10:00:00Z"
}
```

#### `recycling_tips`
Conseils de recyclage avec sous-collection `reviews`
```json
{
  "id": "tip_1",
  "title": "Comment trier le plastique",
  "description": "Guide complet...",
  "category": "plastic",
  "difficulty": 2,
  "tags": ["plastique", "tri", "recyclage"],
  "viewCount": 150,
  "rating": 4.8,
  "createdAt": "2026-01-01T00:00:00Z",
  "updatedAt": "2026-01-21T10:00:00Z"
}
```

#### `users`
Profils utilisateurs
```json
{
  "id": "user_123",
  "email": "user@example.com",
  "firstName": "Jean",
  "lastName": "Dupont",
  "address": "123 Rue de la Paix",
  "notificationsEnabled": true,
  "sortingScore": 1250,
  "createdAt": "2025-01-01T00:00:00Z",
  "updatedAt": "2026-01-21T10:00:00Z"
}
```

### Index Firestore Recommandés

Créer les index suivants dans la console Firebase :

1. **collection_points**
   - isActive (Ascending)
   - updatedAt (Descending)

2. **waste_collections**
   - userId (Ascending), collectionDate (Descending)
   - userId (Ascending), completed (Ascending)

3. **recycling_tips**
   - category (Ascending), updatedAt (Descending)

### Utilisation

```dart
final firebaseService = FirebaseService();

// Obtenir tous les points de collecte
final points = await firebaseService.getAllCollectionPoints();

// Écouter les changements en temps réel
firebaseService.watchCollectionPoints().listen((points) {
  // Mise à jour en temps réel
});

// Sauvegarder une collecte
await firebaseService.saveWasteCollection(collection);

// Obtenir les conseils par catégorie
final tips = await firebaseService.getRecyclingTipsByCategory('plastic');
```

## 3. Repositories - Abstraction des Données

Les repositories fournissent une couche d'abstraction uniforme :

```dart
// Collection Points
final collectionPointRepo = CollectionPointRepository(...);
final points = await collectionPointRepo.getAllPoints();

// Waste Collections
final collectionRepo = WasteCollectionRepository(...);
await collectionRepo.saveCollection(collection);
final collections = await collectionRepo.getUserCollections(userId);

// Recycling Tips
final tipRepo = RecyclingTipRepository(...);
final tips = await tipRepo.getAllTips();

// Users
final userRepo = UserRepository(...);
await userRepo.saveUser(user);

// Preferences
final prefRepo = PreferencesRepository(...);
await prefRepo.savePreferences(preferences);
```

## 4. Service de Synchronisation

Le `SyncService` assure la synchronisation automatique entre Firebase et le cache local :

```dart
final syncService = SyncService(
  localDatabase: dbService,
  firebaseService: firebaseService,
  collectionRepo: collectionRepo,
);

// Synchroniser toutes les données
await syncService.syncAllData(userId);
```

### Stratégie de Synchronisation

1. **Optimiste** : Sauvegarder localement immédiatement
2. **Asynchrone** : Synchroniser avec Firebase en arrière-plan
3. **Fallback** : Utiliser les données locales si Firebase est inaccessible

## 5. Gestion d'État avec Riverpod

### Providers Disponibles

```dart
// Services
localDatabaseProvider
firebaseServiceProvider
syncServiceProvider

// Repositories
collectionPointRepositoryProvider
wasteCollectionRepositoryProvider
recyclingTipRepositoryProvider
userRepositoryProvider
preferencesRepositoryProvider
favoritesRepositoryProvider

// State
currentUserProvider
collectionPointsProvider
recyclingTipsProvider
userCollectionsProvider(userId)
userSortingHabitProvider(userId)
userPreferencesProvider(userId)
favoriteTipsIdsProvider(userId)
```

### Utilisation dans les Widgets

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Accéder à un provider
    final user = ref.watch(currentUserProvider);
    final collections = ref.watch(userCollectionsProvider(userId));
    
    // Appeler une fonction depuis un provider
    ref.read(currentUserProvider.notifier).loadUser(userId);
    
    return Container();
  }
}
```

## 6. Règles de Sécurité Firestore

Les règles de sécurité sont définies dans `firestore_config.dart` :

- Utilisateurs ne peuvent lire que leurs propres collectes
- Utilisateurs ne peuvent lire les conseils (publics)
- Utilisateurs ne peuvent lire les points de collecte (publics)
- Seuls les admins peuvent modifier les données
- Chacun gère son profil individuellement

## 7. Dépendances Requises

Ajoutez à votre `pubspec.yaml` :

```yaml
dependencies:
  sqflite: ^2.3.0
  path: ^1.8.3
  firebase_core: ^2.24.0
  cloud_firestore: ^4.14.0
  riverpod: ^2.4.0
  flutter_riverpod: ^2.4.0
```

## 8. Initialisation

```dart
// Dans main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser Firebase
  await Firebase.initializeApp();
  
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

## 9. Migration et Mises à Jour

### Ajouter une Migration SQLite

```dart
// Dans _onUpgrade
Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    // Migration vers version 2
    await db.execute('ALTER TABLE users ADD COLUMN newField TEXT');
  }
}
```

## 10. Performances et Optimisation

### Bonnes Pratiques

- ✅ Utilisez les index Firestore
- ✅ Paginez les résultats pour les grandes listes
- ✅ Mettez en cache localement les données fréquemment accédées
- ✅ Utilisez `Stream` pour les changements en temps réel
- ✅ Évitez les requêtes N+1
- ✅ Fermez les connexions de base de données correctement

### Exemple de Pagination

```dart
// À implémenter avec QueryDocumentSnapshot
final firstBatch = await _firestore
    .collection('collection_points')
    .limit(10)
    .get();

final nextBatch = await _firestore
    .collection('collection_points')
    .startAfterDocument(firstBatch.docs.last)
    .limit(10)
    .get();
```

---

**Auteur** : Assistant IA  
**Dernière mise à jour** : 21 janvier 2026
