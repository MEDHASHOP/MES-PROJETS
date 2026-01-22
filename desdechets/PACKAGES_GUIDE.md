# 📦 GUIDE COMPLET DES PACKAGES

Ce guide explique chaque package utilisé dans DésDéchets et comment les utiliser.

---

## 🏗️ ARCHITECTURE & STATE MANAGEMENT

### **riverpod** & **flutter_riverpod**
**Version** : `2.4.0`
**Utilité** : Gestion d'état moderne et réactive

#### Quand l'utiliser
- Gérer l'état global de l'application
- Créer des providers pour les données
- Mettre en cache les résultats

#### Exemple basique
```dart
// Créer un provider simple
final userNameProvider = StateProvider((ref) => 'Jean');

// Provider asynchrone (Firebase)
final userDataProvider = FutureProvider((ref) async {
  return await firebaseService.getUser();
});

// Utiliser dans un widget
@override
Widget build(BuildContext context, WidgetRef ref) {
  final userName = ref.watch(userNameProvider);
  return Text('Bonjour $userName');
}
```

#### Documentation
- [Riverpod.dev](https://riverpod.dev)
- Providers : `StateProvider`, `FutureProvider`, `StreamProvider`

---

## 🔥 FIREBASE & CLOUD

### **firebase_core**
**Version** : `2.24.0`
**Utilité** : Initialisation Firebase

#### Configuration
```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
```

### **cloud_firestore**
**Version** : `4.14.0`
**Utilité** : Base de données temps réel

#### Cas d'usage
- Calendrier partagé des collectes
- Points de collecte mis à jour en temps réel
- Conseils de recyclage
- Synchronisation multi-appareils

#### Exemple
```dart
// Sauvegarder une collecte
await FirebaseFirestore.instance
    .collection('waste_collections')
    .add({
      'userId': userId,
      'type': 'plastic',
      'date': DateTime.now(),
      'location': 'Paris',
    });

// Stream temps réel
FirebaseFirestore.instance
    .collection('waste_collections')
    .where('userId', isEqualTo: userId)
    .snapshots()
    .listen((snapshot) {
      // Mettre à jour l'UI
    });
```

### **firebase_auth**
**Version** : `4.13.0`
**Utilité** : Authentification utilisateurs

#### Fonctionnalités
- Sign up / Login
- Sign out
- Récupération de mot de passe
- Auth avec email/mot de passe

#### Exemple
```dart
final auth = FirebaseAuth.instance;

// Créer un compte
await auth.createUserWithEmailAndPassword(
  email: 'user@example.com',
  password: 'password123',
);

// Se connecter
await auth.signInWithEmailAndPassword(
  email: 'user@example.com',
  password: 'password123',
);

// Utilisateur actuel
final user = auth.currentUser;
print('ID: ${user?.uid}');
```

### **firebase_storage**
**Version** : `11.5.0`
**Utilité** : Stockage d'images et fichiers

#### Cas d'usage
- Photos de profil
- Images de conseils
- Pièces jointes

---

## 💾 STOCKAGE LOCAL

### **sqflite**
**Version** : `2.3.0`
**Utilité** : Base de données SQLite locale

#### Architecture Offline-First
```dart
// 1. Sauvegarder localement (immédiat)
await db.insert('collections', collectionData);

// 2. Uploader vers Firebase (background)
await firebaseService.saveCollection(collection);

// 3. Synchroniser après
await syncService.syncData();
```

#### Tables principales
| Table | Objectif | Clé primaire |
|-------|----------|--------------|
| `users` | Profils utilisateurs | id |
| `collections` | Historique tri | id |
| `preferences` | Paramètres locaux | userId |
| `sorting_habits` | Statistiques | userId |
| `saved_tips` | Favoris | id |
| `achievements` | Badges déverrouillés | id |

#### Exemple
```dart
final db = await database;

// Créer
await db.insert('collections', {
  'id': '123',
  'userId': 'user1',
  'type': 'plastic',
  'date': DateTime.now().toIso8601String(),
});

// Lire
final collections = await db.query('collections');

// Mettre à jour
await db.update(
  'collections',
  {'completed': 1},
  where: 'id = ?',
  whereArgs: ['123'],
);

// Supprimer
await db.delete('collections', where: 'id = ?', whereArgs: ['123']);
```

### **path** & **path_provider**
**Versions** : `1.8.3`, `2.1.0`
**Utilité** : Chemins fichiers système

#### Exemple
```dart
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

// Obtenir le répertoire application
final documentsDirectory = await getApplicationDocumentsDirectory();
final databasePath = join(documentsDirectory.path, 'desdechets.db');
```

---

## 🗺️ CARTES & GÉOLOCALISATION

### **google_maps_flutter**
**Version** : `2.5.0`
**Utilité** : Carte interactive pour les points de collecte

#### Fonctionnalités
- Afficher les points de collecte
- Localiser l'utilisateur
- Tracer des routes
- Clusters de marqueurs
- Géofencing

#### Exemple
```dart
GoogleMap(
  initialCameraPosition: CameraPosition(
    target: LatLng(48.8566, 2.3522), // Paris
    zoom: 14,
  ),
  markers: {
    Marker(
      markerId: MarkerId('point1'),
      position: LatLng(48.8566, 2.3522),
      infoWindow: const InfoWindow(title: 'Point collecte'),
    ),
  },
  onMapCreated: (GoogleMapController controller) {
    // Contrôler la carte
  },
)
```

### **geolocator**
**Version** : `9.0.2`
**Utilité** : Géolocalisation en temps réel

#### Permissions requises
- **Android** : `android/app/src/main/AndroidManifest.xml`
  ```xml
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
  ```
- **iOS** : `ios/Runner/Info.plist`
  ```xml
  <key>NSLocationWhenInUseUsageDescription</key>
  <string>Nous avons besoin de votre localisation</string>
  ```

#### Exemple
```dart
import 'package:geolocator/geolocator.dart';

// Obtenir position actuelle
final position = await Geolocator.getCurrentPosition();
print('Latitude: ${position.latitude}');
print('Longitude: ${position.longitude}');

// Streamer les changements
Geolocator.getPositionStream().listen((position) {
  print('Nouvelle position: ${position.latitude}, ${position.longitude}');
});

// Calculer distance (Haversine)
final distance = Geolocator.distanceBetween(
  lat1, lng1, // Position utilisateur
  lat2, lng2, // Point collecte
);
print('Distance: ${(distance / 1000).toStringAsFixed(2)} km');
```

### **google_maps_flutter_web**
**Version** : `0.4.2`
**Utilité** : Support cartes sur web

---

## 🔔 NOTIFICATIONS

### **flutter_local_notifications**
**Version** : `14.1.1`
**Utilité** : Rappels de collecte locale

#### Configuration
```dart
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// Initialiser
await flutterLocalNotificationsPlugin.initialize(
  const InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: DarwinInitializationSettings(),
  ),
);

// Afficher notification
await flutterLocalNotificationsPlugin.show(
  0,
  'Rappel collecte',
  'Plastique demain à 8h',
  const NotificationDetails(
    android: AndroidNotificationDetails(
      'collecte_channel',
      'Collectes',
      importance: Importance.high,
    ),
    iOS: DarwinNotificationDetails(),
  ),
);

// Programmer une notification
await flutterLocalNotificationsPlugin.zonedSchedule(
  0,
  'Rappel collecte',
  'Plastique demain',
  tz.TZDateTime.now(tz.local).add(const Duration(days: 1)),
  const NotificationDetails(...),
  androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
  uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
);
```

### **timezone**
**Version** : `0.9.2`
**Utilité** : Gestion des fuseaux horaires

---

## 🌐 HTTP & API

### **http**
**Version** : `1.1.0`
**Utilité** : Requêtes HTTP simples

#### Exemple
```dart
import 'package:http/http.dart' as http;

final response = await http.get(
  Uri.parse('https://api.example.com/tips'),
);

if (response.statusCode == 200) {
  print(response.body);
} else {
  throw Exception('Erreur API');
}
```

### **dio**
**Version** : `5.3.1`
**Utilité** : Client HTTP avancé (interceptors, retry, timeout)

#### Exemple
```dart
import 'package:dio/dio.dart';

final dio = Dio();
dio.options.connectTimeout = const Duration(seconds: 5);

// GET
final response = await dio.get('/tips');

// POST
await dio.post('/collections', data: {
  'type': 'plastic',
  'date': DateTime.now(),
});

// Interceptor pour auth
dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      options.headers['Authorization'] = 'Bearer $token';
      return handler.next(options);
    },
  ),
);
```

---

## 🖼️ IMAGES & MEDIA

### **cached_network_image**
**Version** : `3.3.0`
**Utilité** : Images en cache avec placeholder

#### Exemple
```dart
CachedNetworkImage(
  imageUrl: 'https://example.com/tip.jpg',
  placeholder: (context, url) => const CircularProgressIndicator(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
  width: 200,
  height: 200,
  fit: BoxFit.cover,
)
```

### **image_picker**
**Version** : `1.0.4`
**Utilité** : Sélectionner/prendre des photos

#### Exemple
```dart
final picker = ImagePicker();

// Galerie
final pickedFile = await picker.pickImage(
  source: ImageSource.gallery,
);

// Caméra
final cameraFile = await picker.pickImage(
  source: ImageSource.camera,
);

if (pickedFile != null) {
  final File imageFile = File(pickedFile.path);
  // Uploader vers Firebase Storage
}
```

---

## 📅 DATE & TIME

### **intl**
**Version** : `0.19.0`
**Utilité** : Localisation et format de dates

#### Exemple
```dart
import 'package:intl/intl.dart';

// Format français
final dateFormat = DateFormat('d MMM y', 'fr_FR');
print(dateFormat.format(DateTime.now())); // 21 janv. 2026

// Heure
final timeFormat = DateFormat('HH:mm', 'fr_FR');
print(timeFormat.format(DateTime.now())); // 14:30

// Jours
print(DateFormat('EEEE', 'fr_FR').format(DateTime.now())); // mercredi
```

---

## 🔍 LOGGING & DEBUG

### **logger**
**Version** : `2.0.1`
**Utilité** : Logs formatés avec couleurs

#### Exemple
```dart
import 'package:logger/logger.dart';

final logger = Logger();

logger.d('Debug message');
logger.i('Info message');
logger.w('Warning message');
logger.e('Error message');
logger.f('Fatal error');

// Sortie
// 💙 DEBUG
// 💙 INFO
// 🟡 WARNING
// ❌ ERROR
// 🔴 FATAL
```

---

## 🛠️ UTILITAIRES

### **get_it**
**Version** : `7.6.0`
**Utilité** : Injection de dépendances

#### Exemple
```dart
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

// Enregistrer
getIt.registerSingleton<FirebaseService>(FirebaseService());
getIt.registerSingleton<LocalDatabaseService>(LocalDatabaseService());

// Utiliser
final firebaseService = getIt<FirebaseService>();
```

### **vibration**
**Version** : `1.8.4`
**Utilité** : Retour haptique (vibrations)

#### Exemple
```dart
import 'package:vibration/vibration.dart';

// Vibration simple
await Vibration.vibrate(duration: 500);

// Pattern
await Vibration.vibrate(
  pattern: [500, 1000, 500, 2000],
);
```

---

## 📋 CHECKLIST D'INSTALLATION

```bash
# Obtenir tous les packages
flutter pub get

# Vérifier les versions
flutter pub outdated

# Mettre à jour
flutter pub upgrade

# Nettoyer le cache
flutter clean
```

### Permissions Android

Ajouter à `android/app/src/main/AndroidManifest.xml` :
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### Permissions iOS

Ajouter à `ios/Runner/Info.plist` :
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Nous avons besoin de votre localisation pour trouver les points de collecte</string>

<key>NSCameraUsageDescription</key>
<string>Nous avons besoin d'accès à votre caméra pour prendre des photos</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Nous avons besoin d'accès à votre galerie</string>
```

---

## 🚀 DÉMARRAGE RAPIDE

### 1. Cloner/Créer le projet
```bash
flutter create desdechets
cd desdechets
```

### 2. Mettre à jour `pubspec.yaml`
Copier les dépendances depuis [PACKAGES_GUIDE.md](PACKAGES_GUIDE.md)

### 3. Installer
```bash
flutter pub get
```

### 4. Vérifier
```bash
flutter doctor
```

### 5. Tester
```bash
flutter run
```

---

## 📊 RÉSUMÉ DES PACKAGES

| Catégorie | Package | Version | Utilité |
|-----------|---------|---------|---------|
| **State** | riverpod | 2.4.0 | État réactif |
| | flutter_riverpod | 2.4.0 | Riverpod Flutter |
| **Firebase** | firebase_core | 2.24.0 | Init Firebase |
| | cloud_firestore | 4.14.0 | BD temps réel |
| | firebase_auth | 4.13.0 | Authentification |
| | firebase_storage | 11.5.0 | Stockage fichiers |
| **Local DB** | sqflite | 2.3.0 | SQLite |
| | path | 1.8.3 | Chemins fichiers |
| | path_provider | 2.1.0 | Répertoires système |
| **Maps** | google_maps_flutter | 2.5.0 | Cartes interactives |
| | geolocator | 9.0.2 | Géolocalisation |
| | google_maps_flutter_web | 0.4.2 | Cartes web |
| **Notifications** | flutter_local_notifications | 14.1.1 | Rappels locaux |
| | timezone | 0.9.2 | Fuseaux horaires |
| **HTTP** | http | 1.1.0 | Requêtes HTTP |
| | dio | 5.3.1 | Client HTTP avancé |
| **Images** | cached_network_image | 3.3.0 | Images en cache |
| | image_picker | 1.0.4 | Sélectionner images |
| **Date** | intl | 0.19.0 | Localisation dates |
| **Debug** | logger | 2.0.1 | Logs formatés |
| **Utils** | get_it | 7.6.0 | Injection dépendances |
| | vibration | 1.8.4 | Retour haptique |

---

## ✅ VALIDATION

Après l'installation, vérifier :

```bash
# Tous les packages récupérés
flutter pub get

# Pas de conflit de version
flutter pub outdated

# App compile
flutter build apk --release

# Tests passent
flutter test
```

---

**Prochaines étapes** : Consultez [SETUP_GUIDE.md](SETUP_GUIDE.md) pour la configuration Firebase.

