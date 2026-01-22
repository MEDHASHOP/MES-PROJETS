# Guide d'Initialisation - DésDéchets

## 1. Configuration Firebase

### Étape 1 : Créer un projet Firebase

1. Aller sur [Firebase Console](https://console.firebase.google.com/)
2. Cliquer sur "Créer un projet"
3. Nommer le projet "DésDéchets"
4. Activer Google Analytics
5. Créer le projet

### Étape 2 : Configurer Firestore

1. Dans la console Firebase, aller à "Firestore Database"
2. Cliquer sur "Créer une base de données"
3. Choisir "Mode de test" (pour développement)
4. Sélectionner la région `europe-west1` (Frankfurt)
5. Créer la base

### Étape 3 : Configurer l'authentification

1. Aller à "Authentication"
2. Cliquer sur "Activer un nouveau mode de connexion"
3. Activer :
   - Email/Mot de passe
   - Google (optionnel)
   - Anonymous (optionnel)

### Étape 4 : Récupérer les credentials

1. Aller à "Paramètres du projet"
2. Cliquer sur "Ajouter une application"
3. Choisir "Flutter"
4. Suivre les instructions pour télécharger :
   - `google-services.json` (Android)
   - `GoogleService-Info.plist` (iOS)
   - `google-services.json` (Web)

## 2. Configuration Android

### Ajouter google-services.json

```
android/app/google-services.json
```

### Configurer build.gradle

```gradle
// android/build.gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}

// android/app/build.gradle
apply plugin: 'com.google.gms.google-services'
```

## 3. Configuration iOS

### Ajouter GoogleService-Info.plist

1. Ouvrir `ios/Runner.xcworkspace` dans Xcode
2. Ajouter le fichier `GoogleService-Info.plist`
3. Sélectionner tous les targets (Runner, RunnerTests, etc.)
4. Sauvegarder

### Pod install

```bash
cd ios
pod install
cd ..
```

## 4. Configuration Web

### Ajouter à index.html

```html
<!-- web/index.html -->
<script src="https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/10.7.0/firebase-firestore-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/10.7.0/firebase-auth-compat.js"></script>

<script>
  var firebaseConfig = {
    apiKey: "YOUR_API_KEY",
    authDomain: "your-project.firebaseapp.com",
    projectId: "your-project",
    storageBucket: "your-project.appspot.com",
    messagingSenderId: "123456789",
    appId: "1:123456789:web:abcdef123456"
  };

  firebase.initializeApp(firebaseConfig);
</script>
```

## 5. Installer les dépendances

```bash
# Installer les dépendances Flutter
flutter pub get

# Générer les fichiers (pour json_serializable)
flutter pub run build_runner build

# Configuration pour iOS
cd ios && pod install && cd ..
```

## 6. Initialiser l'application

### Créer main.dart

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DésDéchets',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DésDéchets')),
      body: Center(child: Text('Bienvenue!')),
    );
  }
}
```

## 7. Configurer les règles de sécurité Firestore

### Dans Firebase Console

1. Aller à "Firestore Database"
2. Cliquer sur "Règles"
3. Remplacer les règles par :

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Points de collecte - publics en lecture
    match /collection_points/{document=**} {
      allow read: if request.auth != null;
      allow write: if request.auth.token.admin == true;
    }

    // Collectes de l'utilisateur
    match /waste_collections/{document=**} {
      allow read: if request.auth != null && resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update, delete: if request.auth != null && resource.data.userId == request.auth.uid;
    }

    // Conseils - publics en lecture
    match /recycling_tips/{document=**} {
      allow read: if request.auth != null;
      allow write: if request.auth.token.admin == true;
      
      match /reviews/{review=**} {
        allow read: if request.auth != null;
        allow create: if request.auth != null;
        allow update, delete: if request.auth != null && resource.data.userId == request.auth.uid;
      }
    }

    // Profil utilisateur
    match /users/{uid} {
      allow read: if request.auth != null && uid == request.auth.uid;
      allow write: if request.auth != null && uid == request.auth.uid;
    }
  }
}
```

4. Cliquer sur "Publier"

## 8. Lancer l'application

```bash
# Mode debug
flutter run

# Mode release
flutter run --release

# iOS
flutter run -d ios

# Android
flutter run -d android

# Web
flutter run -d chrome
```

## 9. Structures de données Firestore

### Collection: collection_points

```json
{
  "id": "point_001",
  "name": "Déchetterie Centre-Ville",
  "description": "Point de collecte principal",
  "latitude": 48.8566,
  "longitude": 2.3522,
  "address": "123 Rue de la Paix",
  "city": "Paris",
  "postalCode": "75001",
  "acceptedWasteTypes": ["plastic", "glass", "organic", "paper"],
  "phoneNumber": "+33 1 23 45 67 89",
  "email": "contact@dechetterie.fr",
  "website": "www.dechetterie.fr",
  "schedule": {
    "monday": "08:00-18:00",
    "tuesday": "08:00-18:00",
    "wednesday": "08:00-18:00",
    "thursday": "08:00-18:00",
    "friday": "08:00-19:00",
    "saturday": "08:00-17:00",
    "sunday": "Fermé",
    "holidays": ["2026-01-01", "2026-07-14"]
  },
  "rating": 4.5,
  "reviewCount": 42,
  "isActive": true,
  "updatedAt": "2026-01-21T10:30:00Z"
}
```

### Collection: waste_collections

```json
{
  "id": "collection_001",
  "userId": "user_123",
  "type": "plastic",
  "collectionDate": "2026-01-25T10:00:00Z",
  "location": "Rue de la Paix",
  "latitude": 48.8566,
  "longitude": 2.3522,
  "quantity": 5,
  "notes": "Collecte des bouteilles en plastique",
  "completed": false,
  "createdAt": "2026-01-21T10:00:00Z"
}
```

### Collection: recycling_tips

```json
{
  "id": "tip_001",
  "title": "Comment trier le plastique correctement",
  "description": "Guide complet pour trier le plastique...",
  "imageUrl": "https://...",
  "category": "plastic",
  "difficulty": 2,
  "tags": ["plastique", "tri", "recyclage", "environnement"],
  "videoUrl": "https://...",
  "createdAt": "2026-01-01T00:00:00Z",
  "updatedAt": "2026-01-21T10:00:00Z",
  "viewCount": 150,
  "rating": 4.8
}
```

## 10. Commandes utiles

```bash
# Nettoyer le projet
flutter clean

# Obtenir les dépendances
flutter pub get

# Générer les fichiers (json_serializable, riverpod_generator)
flutter pub run build_runner build --delete-conflicting-outputs

# Vérifier les dépendances
flutter pub outdated

# Analyser le code
flutter analyze

# Formater le code
flutter format lib/

# Tests
flutter test
```

## 11. Dépannage

### Problème: "Cannot find plugin_path"

```bash
flutter pub get
flutter pub upgrade
flutter clean
```

### Problème: "Build failures on iOS"

```bash
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
```

### Problème: "Firebase initialization error"

- Vérifier que `google-services.json` est au bon emplacement
- Vérifier les credentials Firebase
- Vérifier la version de `firebase_core`

---

**Prêt à développer !** 🚀
