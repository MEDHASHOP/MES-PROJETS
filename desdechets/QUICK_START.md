# 🚀 DÉMARRAGE RAPIDE - DésDéchets

## ⏱️ 5 Minutes pour Comprendre l'Architecture

### 1️⃣ Structure (1 min)

```
lib/
├── models/          → Données métier (6 fichiers)
├── screens/         → État des écrans (5 fichiers)
├── services/        → Gestion des données (6 fichiers)
└── providers/       → État global Riverpod (2 fichiers)
```

### 2️⃣ Flux de Données (1 min)

```
Widget → Provider → Repository → Service (SQLite + Firebase)
```

**Exemple** : Récupérer des points de collecte
```dart
// Widget utilise le provider
final points = ref.watch(collectionPointsProvider);

// Provider appelle le repository
final repo = ref.watch(collectionPointRepositoryProvider);

// Repository accède au service
await firebaseService.getAllCollectionPoints();

// Service requête Firebase
Firestore → ☁️ → Local Cache
```

### 3️⃣ Données (1 min)

**Local (SQLite)** : Historique, préférences, cache
**Remote (Firebase)** : Points collecte, calendrier, conseils

### 4️⃣ Les 5 Écrans (1 min)

| Écran | État | Données |
|-------|------|---------|
| 🏠 Accueil | HomeScreenState | User + tips + stats |
| 📅 Calendrier | CalendarScreenState | Collections + events |
| 🗺️ Carte | MapScreenState | CollectionPoints + user position |
| 💡 Conseils | TipsScreenState | RecyclingTips + comments |
| 👤 Profil | ProfileScreenState | User + stats + achievements |

### 5️⃣ Modules Clés (1 min)

**Models** : Classes métier avec JSON
**Services** : Accès données local + remote
**Repositories** : Interface unique
**Providers** : Exposent données aux widgets
**Sync** : Synchronisation offline-first

---

## 📦 Installation (5 min)

### Étape 1 : Dépendances
```bash
cd desdechets
flutter pub get
```

### Étape 2 : Firebase
1. Créer projet sur Firebase Console
2. Télécharger `google-services.json` (Android)
3. Télécharger `GoogleService-Info.plist` (iOS)
4. Placer dans les bons dossiers

### Étape 3 : Configuration
```bash
# Android
android/app/google-services.json

# iOS (via Xcode)
ios/Runner/GoogleService-Info.plist
```

### Étape 4 : Lancer
```bash
flutter run
```

---

## 💻 Premiers Exemples de Code

### Exemple 1 : Afficher les points de collecte
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/index.dart';

class PointsWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(collectionPointsProvider);
    
    return points.when(
      data: (items) => ListView(
        children: items.map((p) => ListTile(
          title: Text(p.name),
          subtitle: Text(p.address),
        )).toList(),
      ),
      loading: () => CircularProgressIndicator(),
      error: (e, s) => Text('Erreur: $e'),
    );
  }
}
```

### Exemple 2 : Ajouter une collecte
```dart
final repo = ref.read(wasteCollectionRepositoryProvider);

final collection = WasteCollection(
  id: 'col_1',
  userId: 'user_123',
  type: WasteType.plastic,
  collectionDate: DateTime.now(),
  quantity: 5,
  createdAt: DateTime.now(),
);

await repo.saveCollection(collection);
```

### Exemple 3 : Écouter les changements temps réel
```dart
firebaseService.watchCollectionPoints().listen((points) {
  print('Points mis à jour: ${points.length}');
});
```

---

## 🔑 Points Clés à Retenir

| Concept | Explication | Exemple |
|---------|-------------|---------|
| **Model** | Classe métier | `User`, `WasteCollection` |
| **Service** | Accès données | `FirebaseService`, `LocalDatabaseService` |
| **Repository** | Interface unique | `CollectionPointRepository` |
| **Provider** | Expose données | `collectionPointsProvider` |
| **Sync** | Offline-first | Local d'abord, puis Firebase |
| **Stream** | Temps réel | `watchCollectionPoints()` |

---

## 🎯 Navigation dans le Code

### Pour comprendre les **modèles**
→ Voir [models/user.dart](lib/models/user.dart)

### Pour comprendre les **données**
→ Voir [services/DATA_MANAGEMENT.md](lib/services/DATA_MANAGEMENT.md)

### Pour comprendre les **providers**
→ Voir [providers/app_providers.dart](lib/providers/app_providers.dart)

### Pour voir des **exemples**
→ Voir [EXAMPLES.md](EXAMPLES.md)

### Pour la **configuration**
→ Voir [SETUP_GUIDE.md](SETUP_GUIDE.md)

### Pour l'**architecture complète**
→ Voir [ARCHITECTURE.md](ARCHITECTURE.md)

---

## 🔧 Commandes Utiles

```bash
# Formater le code
flutter format lib/

# Analyser le code
flutter analyze

# Tester
flutter test

# Build release
flutter build apk
flutter build ios
flutter build web
```

---

## ❓ FAQ Rapide

### Q: Comment ajouter une nouvelle collecte ?
**R:** Utiliser `WasteCollectionRepository.saveCollection()`

### Q: Comment récupérer les données d'un utilisateur ?
**R:** Utiliser `ref.watch(currentUserProvider)`

### Q: Comment écouter les changements ?
**R:** Utiliser `firebaseService.watch*()` (retourne un Stream)

### Q: Comment fonctionne la sync ?
**R:** Sauvegarde locale immédiate + upload Firebase asynchrone + fallback local

### Q: Où stocker les données ?
**R:** SQLite pour local, Firestore pour le cloud

### Q: Comment filtrer les points ?
**R:** `collectionPointRepository.getPointsByWasteType('plastic')`

### Q: Où ajouter un nouvel écran ?
**R:** Créer `ScreenNameState` dans `screens/screen_name.dart`

---

## 📊 Vue d'Ensemble Visuelle

```
┌─────────────────────────────────────────┐
│      APPLICATION DESDÉCHETS             │
├─────────────────────────────────────────┤
│ Écrans                                  │
│ ├─ 🏠 Accueil                          │
│ ├─ 📅 Calendrier                       │
│ ├─ 🗺️ Carte                           │
│ ├─ 💡 Conseils                         │
│ └─ 👤 Profil                           │
├─────────────────────────────────────────┤
│ Providers Riverpod (20+)                │
│ ├─ Service Providers                    │
│ ├─ Repository Providers                 │
│ └─ Data Providers                       │
├─────────────────────────────────────────┤
│ Repositories (8)                        │
│ ├─ CollectionPoint                      │
│ ├─ WasteCollection                      │
│ ├─ RecyclingTip                         │
│ ├─ User                                 │
│ ├─ SortingHabit                         │
│ ├─ Preferences                          │
│ ├─ Favorites                            │
│ └─ Achievements                         │
├─────────────────────────────────────────┤
│ Services                                │
│ ├─ LocalDatabase (SQLite)               │
│ ├─ Firebase (Firestore)                 │
│ └─ Sync (Offline-first)                 │
├─────────────────────────────────────────┤
│ Données                                 │
│ ├─ 📱 SQLite Local (6 tables)          │
│ └─ ☁️ Firestore (5 collections)        │
└─────────────────────────────────────────┘
```

---

## ✅ Checklist Démarrage

- [ ] Cloner/Créer le projet
- [ ] Exécuter `flutter pub get`
- [ ] Créer projet Firebase
- [ ] Ajouter `google-services.json` et `GoogleService-Info.plist`
- [ ] Exécuter `flutter run`
- [ ] Tester en émulateur
- [ ] Lire la documentation

---

## 📚 Documentation à Consulter (dans l'ordre)

1. **📖 Présent** (QUICK_START.md) - Vue rapide
2. **🏗️ [ARCHITECTURE.md](ARCHITECTURE.md)** - Vue d'ensemble
3. **💾 [DATA_MANAGEMENT.md](lib/services/DATA_MANAGEMENT.md)** - Données
4. **📋 [EXAMPLES.md](EXAMPLES.md)** - Code concret
5. **🔧 [SETUP_GUIDE.md](SETUP_GUIDE.md)** - Configuration
6. **✅ [CHECKLIST_VERIFICATION.md](CHECKLIST_VERIFICATION.md)** - Vérification

---

## 🎓 Prochain Pas

1. **Lire** l'architecture complète
2. **Créer** les premiers widgets UI
3. **Implémenter** l'authentification
4. **Tester** les repositories
5. **Déployer** en production

---

**🌱 Bienvenue dans DésDéchets ! Prêt à coder ? Let's go ! 🚀**

---

**Besoin d'aide ?** Consultez les fichiers documentation ou les exemples de code !
