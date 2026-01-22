# Exemples d'Utilisation - DésDéchets

## 1. Utiliser les Repositories

### Exemple 1 : Récupérer les points de collecte

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/index.dart';
import 'models/index.dart';

// Utiliser le provider
final collectionPoints = ref.watch(collectionPointsProvider);

collectionPoints.when(
  data: (points) {
    // Afficher les points
    ListView.builder(
      itemCount: points.length,
      itemBuilder: (context, index) {
        final point = points[index];
        return ListTile(
          title: Text(point.name),
          subtitle: Text(point.address),
          trailing: Text(point.distanceText),
        );
      },
    );
  },
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Erreur: $err'),
);
```

### Exemple 2 : Sauvegarder une collecte

```dart
// Dans un notifier ou un widget
final collectionRepo = ref.read(wasteCollectionRepositoryProvider);

final collection = WasteCollection(
  id: 'collection_${DateTime.now().millisecondsSinceEpoch}',
  userId: currentUser.id,
  type: WasteType.plastic,
  collectionDate: DateTime.now(),
  location: 'Ma maison',
  quantity: 5,
  createdAt: DateTime.now(),
);

await collectionRepo.saveCollection(collection);
```

## 2. Gestion d'État avec Riverpod

### Exemple 3 : Charger l'utilisateur courant

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Accéder à l'utilisateur courant
    final userAsync = ref.watch(currentUserProvider);

    // Charger l'utilisateur
    ref.read(currentUserProvider.notifier).loadUser('user_123');

    return userAsync.when(
      data: (user) {
        if (user == null) return Text('Pas d\'utilisateur');
        return Text('Bienvenue ${user.fullName}');
      },
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Erreur: $err'),
    );
  }
}
```

### Exemple 4 : Écouter les changements en temps réel

```dart
class CollectionsStream extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = 'user_123';
    final collectionRepo = ref.watch(wasteCollectionRepositoryProvider);

    // Créer un stream provider pour les collectes
    final collectionsStream = StreamProvider.family<List<WasteCollection>, String>(
      (ref, uid) => collectionRepo.watchUserCollections(uid),
    );

    final collections = ref.watch(collectionsStream(userId));

    return collections.when(
      data: (items) => ListView(
        children: items.map((col) => ListTile(
          title: Text(col.type.displayName),
          subtitle: Text(col.collectionDate.toString()),
        )).toList(),
      ),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Erreur: $err'),
    );
  }
}
```

## 3. Utiliser la Base de Données Locale

### Exemple 5 : Sauvegarder les préférences

```dart
final dbService = LocalDatabaseService();
final preferences = UserPreferences(
  userId: 'user_123',
  notificationsEnabled: true,
  preferredLanguage: 'fr',
  reminderTime: '09:00',
  radiusKm: 10.0,
);

await dbService.saveUserPreferences(preferences);

// Récupérer les préférences
final prefs = await dbService.getUserPreferences('user_123');
```

### Exemple 6 : Obtenir les collectes du mois

```dart
final dbService = LocalDatabaseService();
final now = DateTime.now();

final collections = await dbService.getCollectionsForMonth('user_123', now);

// Grouper par type
final grouped = <WasteType, List<WasteCollection>>{};
for (final col in collections) {
  grouped.putIfAbsent(col.type, () => []).add(col);
}

grouped.forEach((type, cols) {
  print('${type.displayName}: ${cols.length} collectes');
});
```

## 4. Utiliser Firebase Firestore

### Exemple 7 : Écouter les points de collecte en temps réel

```dart
final firebaseService = FirebaseService();

firebaseService.watchCollectionPoints().listen(
  (points) {
    print('Points mis à jour: ${points.length}');
    // Mettre à jour l'UI
  },
  onError: (error) {
    print('Erreur: $error');
  },
);
```

### Exemple 8 : Ajouter un commentaire à un conseil

```dart
final firebaseService = FirebaseService();

await firebaseService.addTipComment(
  tipId: 'tip_001',
  userId: 'user_123',
  comment: 'Très utile, merci!',
  rating: 5.0,
);
```

## 5. Synchronisation

### Exemple 9 : Synchroniser les données

```dart
final syncService = SyncService(
  localDatabase: dbService,
  firebaseService: firebaseService,
  collectionRepo: collectionRepo,
);

try {
  await syncService.syncAllData('user_123');
  print('Synchronisation réussie');
} catch (e) {
  print('Erreur de synchronisation: $e');
}
```

## 6. Filtrage et Tri

### Exemple 10 : Filtrer et trier les points de collecte

```dart
final collectionPointRepo = ref.watch(collectionPointRepositoryProvider);

// Récupérer les points acceptant le plastique
final plasticPoints = await collectionPointRepo.getPointsByWasteType('plastic');

// Trier par distance
plasticPoints.sort((a, b) {
  final aDist = a.distanceKm ?? double.maxFinite;
  final bDist = b.distanceKm ?? double.maxFinite;
  return aDist.compareTo(bDist);
});
```

### Exemple 11 : Filtrer les conseils

```dart
final tipRepo = ref.watch(recyclingTipRepositoryProvider);

// Récupérer les conseils sur le plastique
final plasticTips = await tipRepo.getTipsByCategory('plastic');

// Trier par difficulté
plasticTips.sort((a, b) => a.difficulty.compareTo(b.difficulty));

// Filtrer les faciles (difficulté <= 2)
final easyTips = plasticTips.where((t) => t.difficulty <= 2).toList();
```

## 7. Créer des Widgets Riverpod

### Exemple 12 : Widget avec gestion d'état

```dart
class UserStatsWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = 'user_123';
    
    // Obtenir les statistiques
    final habitAsync = ref.watch(userSortingHabitProvider(userId));
    final prefsAsync = ref.watch(userPreferencesProvider(userId));

    return habitAsync.when(
      data: (habit) {
        if (habit == null) return Text('Pas de données');
        
        return Column(
          children: [
            Text('Collectes: ${habit.totalCollections}'),
            Text('Poids: ${habit.totalWeight} kg'),
            Text('Streak: ${habit.currentStreak} jours'),
          ],
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Erreur: $err'),
    );
  }
}
```

### Exemple 13 : Formulaire de collecte

```dart
class AddCollectionForm extends ConsumerStatefulWidget {
  @override
  ConsumerState<AddCollectionForm> createState() => _AddCollectionFormState();
}

class _AddCollectionFormState extends ConsumerState<AddCollectionForm> {
  WasteType? selectedType;
  int quantity = 0;
  String? notes;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          DropdownButton<WasteType>(
            value: selectedType,
            items: WasteType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text('${type.icon} ${type.displayName}'),
              );
            }).toList(),
            onChanged: (value) => setState(() => selectedType = value),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Quantité (kg)'),
            keyboardType: TextInputType.number,
            onChanged: (value) => quantity = int.tryParse(value) ?? 0,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Notes'),
            onChanged: (value) => notes = value,
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedType == null) return;
              
              final collection = WasteCollection(
                id: 'col_${DateTime.now().millisecondsSinceEpoch}',
                userId: 'user_123',
                type: selectedType!,
                collectionDate: DateTime.now(),
                quantity: quantity,
                notes: notes,
                createdAt: DateTime.now(),
              );

              final repo = ref.read(wasteCollectionRepositoryProvider);
              await repo.saveCollection(collection);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Collecte ajoutée')),
              );
            },
            child: Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}
```

## 8. Gestion des Erreurs

### Exemple 14 : Gestion robuste des erreurs

```dart
class SafeDataWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(collectionPointsProvider);

    return dataAsync.when(
      data: (points) {
        if (points.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_off, size: 64),
                SizedBox(height: 16),
                Text('Aucun point de collecte trouvé'),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: points.length,
          itemBuilder: (context, index) => PointTile(points[index]),
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) {
        print('Erreur: $error');
        print('Stack: $stack');
        
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text('Erreur: $error'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(collectionPointsProvider),
                child: Text('Réessayer'),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

## 9. Pagination

### Exemple 15 : Implémenter la pagination

```dart
class PaginatedTipsWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<PaginatedTipsWidget> createState() => _PaginatedTipsWidgetState();
}

class _PaginatedTipsWidgetState extends ConsumerState<PaginatedTipsWidget> {
  int currentPage = 1;
  final pageSize = 10;

  @override
  Widget build(BuildContext context) {
    final tipsAsync = ref.watch(recyclingTipsProvider);

    return tipsAsync.when(
      data: (allTips) {
        final startIndex = (currentPage - 1) * pageSize;
        final endIndex = (startIndex + pageSize).clamp(0, allTips.length);
        final pageTips = allTips.sublist(startIndex, endIndex);

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: pageTips.length,
                itemBuilder: (context, index) => TipTile(pageTips[index]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: currentPage > 1 
                    ? () => setState(() => currentPage--)
                    : null,
                  child: Text('Précédent'),
                ),
                Text('Page $currentPage'),
                ElevatedButton(
                  onPressed: endIndex < allTips.length
                    ? () => setState(() => currentPage++)
                    : null,
                  child: Text('Suivant'),
                ),
              ],
            ),
          ],
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Erreur: $err'),
    );
  }
}
```

---

**Ces exemples couvrent les cas d'usage principaux de l'application ! 🚀**
