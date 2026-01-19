# AI Coding Guidelines for "Played" Flutter App

## Architecture Overview
This Flutter app manages soccer team players with local SQLite storage and Riverpod state management. Key folders:
- `lib/dat/` - Data layer (DatabaseHelper singleton for sqflite)
- `lib/modele/` - Data models (e.g., `Joueur` with UUID IDs)
- `lib/providers/` - Riverpod StateNotifier providers (e.g., `joueursProvider` for player list)
- `lib/vue/` - Page widgets (e.g., `AjoutJoueurPage`, `GestionPresencePage`)
- `lib/widgets/` - Reusable UI components (e.g., `JoueurItem`, `ImagePrise`)

## State Management
Use Riverpod StateNotifier for mutable state. Example:
```dart
class JoueursProvider extends StateNotifier<List<Joueur>> {
  // Load from DB on init, update both state and DB
  Future<void> ajouterJoueur(Joueur nouveau) async {
    await _dbHelper.ajouterJoueur(nouveau);
    state = [...state, nouveau];
  }
}
```

## Data Persistence
- Local SQLite via `DatabaseHelper` singleton
- Models use `fromMap`/`toMap` for DB conversion
- Player images stored as file paths (not blobs)

## UI Patterns
- `ConsumerWidget`/`ConsumerStatefulWidget` for Riverpod integration
- Callbacks for child-to-parent communication (e.g., `onPresenceChange`)
- `copyWith` extensions on models for immutable updates
- Image picking via `ImagePicker` with camera/gallery options

## Conventions
- French variable names and comments (e.g., `joueurs`, `estPresent`)
- UUID for entity IDs
- File paths for images (validate existence in production)
- Presence as bool (stored as 0/1 in SQLite)

## Workflows
- Run: `flutter run`
- Test: `flutter test` (minimal tests present)
- Build: `flutter build apk` or `flutter build ios`
- Dependencies: `flutter pub get` (includes Firebase deps, but unused in code)

## Key Files
- `lib/main.dart` - App entry with ProviderScope
- `lib/providers/joueurs_provider.dart` - Main state provider
- `lib/dat/data.dart` - DB schema and operations
- `lib/modele/joueur.dart` - Player model with copyWith extension</content>
<parameter name="filePath">c:\Users\lomp\developementmobile\mes projets\played\.github\copilot-instructions.md