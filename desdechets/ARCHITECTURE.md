# Architecture Complète - DésDéchets

## 📁 Structure du Projet

```
lib/
├── main.dart                          # Point d'entrée
├── models/                            # Modèles métier
│   ├── user.dart                     # Utilisateur
│   ├── waste_collection.dart         # Collectes
│   ├── recycling_tip.dart            # Conseils
│   ├── collection_point.dart         # Points de collecte
│   ├── sorting_habit.dart            # Habitudes de tri
│   ├── api_response.dart             # Réponses API
│   └── index.dart                    # Export
├── screens/                          # États des écrans
│   ├── home_screen.dart              # Accueil
│   ├── calendar_screen.dart          # Calendrier
│   ├── map_screen.dart               # Carte
│   ├── tips_screen.dart              # Conseils
│   ├── profile_screen.dart           # Profil
│   └── index.dart                    # Export
├── services/                         # Services de données
│   ├── local_database_service.dart   # SQLite
│   ├── firebase_service.dart         # Firestore
│   ├── repository.dart               # Repositories
│   ├── sync_service.dart             # Synchronisation
│   ├── firestore_config.dart         # Configuration Firebase
│   ├── DATA_MANAGEMENT.md            # Documentation
│   └── index.dart                    # Export
└── providers/                        # Gestion d'état (Riverpod)
    ├── app_providers.dart            # Tous les providers
    └── index.dart                    # Export
```

## 🔄 Flux de Données

```
┌─────────────────┐
│  UI (Widgets)   │
└────────┬────────┘
         │ (watch/listen)
         ↓
┌─────────────────────────────┐
│  Riverpod Providers         │
│  - FutureProvider           │
│  - StateNotifierProvider    │
└────────┬────────────────────┘
         │ (appel async)
         ↓
┌─────────────────────────────┐
│  Repositories               │
│  - CollectionPointRepo      │
│  - WasteCollectionRepo      │
│  - RecyclingTipRepo         │
│  - UserRepo                 │
└────────┬────────────────────┘
         │
    ┌────┴────┐
    ↓         ↓
┌─────────┐ ┌──────────────┐
│ SQLite  │ │ Firebase     │
│ (Local) │ │ (Remote)     │
└─────────┘ └──────────────┘
```

## 📊 Modèles de Données

### User
```dart
User {
  id, email, firstName, lastName
  profileImage, address, phoneNumber
  createdAt, updatedAt
  notificationsEnabled, sortingScore
}
```

### WasteCollection
```dart
WasteCollection {
  id, userId
  type (enum WasteType)
  collectionDate, location
  latitude, longitude
  quantity, notes
  createdAt, completed
}
```

### RecyclingTip
```dart
RecyclingTip {
  id, title, description
  imageUrl, category
  difficulty (1-5)
  tags, videoUrl
  createdAt, updatedAt
  viewCount, rating
}
```

### CollectionPoint
```dart
CollectionPoint {
  id, name, description
  latitude, longitude
  address, city, postalCode
  acceptedWasteTypes[]
  phoneNumber, email, website
  schedule (CollectionPointSchedule)
  rating, reviewCount
  imageUrl, updatedAt
  isActive, distanceKm
}
```

### SortingHabit
```dart
SortingHabit {
  id, userId
  totalCollections, totalWeight
  wasteTypeCount{}
  lastCollection
  currentStreak, bestStreak
  createdAt, updatedAt
}
```

## 🗄️ Base de Données

### SQLite Tables

| Table | Objectif |
|-------|----------|
| `users` | Cache des profils utilisateurs |
| `preferences` | Préférences et paramètres locaux |
| `collections` | Historique des collectes |
| `sorting_habits` | Habitudes et statistiques de tri |
| `saved_tips` | Conseils favoris |
| `achievements` | Réussites débloquées |

### Firestore Collections

| Collection | Objectif |
|------------|----------|
| `collection_points` | Points de collecte (temps réel) |
| `waste_collections` | Calendrier partagé |
| `recycling_tips` | Conseils et articles |
| `users` | Profils utilisateurs |
| `reviews` (sub) | Commentaires sur conseils |

## 🔐 Sécurité

### Règles Firestore

```
- Users lisent uniquement leurs données
- Points de collecte sont publics (lecture)
- Conseils sont publics (lecture)
- Seuls les admins peuvent écrire
- Chacun gère son profil
```

## 📱 Écrans

### 1. Home Screen
- Bienvenue utilisateur
- Accès rapide (Calendrier, Carte, Conseils)
- Statistiques rapides
- Conseil en avant

### 2. Calendar Screen
- Vue calendrier mensuelle
- Collectes du jour
- Filtres par type
- Vue liste alternative

### 3. Map Screen
- Points de collecte
- Géolocalisation utilisateur
- Filtres par type de déchet
- Tri (distance, notation, nom, ouvert)

### 4. Tips Screen
- Conseils filtrés
- Catégories
- Quizz interactifs
- Favoris
- Commentaires

### 5. Profile Screen
- Informations utilisateur
- Statistiques de tri
- Badges et réussites
- Historique d'activité
- Préférences

## 🔄 Synchronisation

### Stratégie Offline-First

1. **Sauvegarde locale** : données sauvegardées immédiatement en SQLite
2. **Upload asynchrone** : synchronisation avec Firebase en arrière-plan
3. **Fallback** : si Firebase indisponible, utiliser le cache local
4. **Merge** : lors de la reconnexion, fusionner les données

### Conflits

- Dernière écriture gagne (Last-Write-Wins)
- Horodatage pour la résolution
- Logs de synchronisation

## 📦 Dépendances Principales

| Package | Rôle |
|---------|------|
| `sqflite` | Base de données locale |
| `firebase_core` | Initialisation Firebase |
| `cloud_firestore` | Firestore en temps réel |
| `riverpod` | Gestion d'état |
| `geolocator` | Géolocalisation |
| `google_maps_flutter` | Cartes |
| `flutter_local_notifications` | Notifications |

## 🚀 Déploiement

### Buildrelease

```bash
# Android
flutter build apk
flutter build appbundle

# iOS
flutter build ios

# Web
flutter build web
```

## ✨ Fonctionnalités Principales

- ✅ **Calendrier** : Collectes planifiées par jour/type
- ✅ **Carte Interactive** : Points de collecte en temps réel
- ✅ **Conseils** : Fiches interactives et quizz
- ✅ **Profil** : Suivi des habitudes et réussites
- ✅ **Notifications** : Rappels de collecte
- ✅ **Sync** : Offline-first avec synchronisation
- ✅ **Analytics** : Statistiques de tri
- ✅ **Favoris** : Conseils et points favoris

## 📈 Métriques Suivi

- Collections effectuées (total, par type)
- Poids trié (total, par type)
- Jours consécutifs de tri
- Score global
- CO2 économisé
- Niveau d'utilisateur

## 🎯 États des Écrans

Chaque écran a un `ScreenState` avec :
- ✅ Données
- ✅ État de chargement
- ✅ Gestion des erreurs
- ✅ Filtres et tri
- ✅ Pagination

## 🔗 Intégrations

- 🗺️ **Google Maps** : Cartographie
- 📱 **Géolocalisation** : Position utilisateur
- 🔔 **Notifications** : Rappels locaux
- 💾 **SQLite** : Stockage local
- ☁️ **Firestore** : Données temps réel
- 🔐 **Firebase Auth** : Authentification

## 📚 Documentation

- `DATA_MANAGEMENT.md` : Gestion des données
- `SETUP_GUIDE.md` : Guide d'initialisation
- `PUBSPEC_DEPENDENCIES.txt` : Configuration pubspec.yaml
- `ARCHITECTURE.md` : Vue d'ensemble architecturale

---

**Prêt à développer une application éco-responsable ! 🌱**
