// providers/joueurs_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../modele/joueur.dart'; // Import de la classe Joueur
import '../dat/data.dart'; // Import du service de base de données

/// Classe StateNotifier gérant la liste des [Joueur].
class JoueursProvider extends StateNotifier<List<Joueur>> {
  final DatabaseHelper _dbHelper = DatabaseHelper(); // Instance du helper

  JoueursProvider() : super(const []) {
    _chargerJoueurs(); // Charge les joueurs depuis la base au démarrage
  }

  /// Charge les joueurs depuis la base de données et met à jour l'état.
  Future<void> _chargerJoueurs() async {
    final joueurs = await _dbHelper.lireTousLesJoueurs();
    state = joueurs;
  }

  /// Méthode pour ajouter un nouveau joueur à la liste ET à la base de données.
  Future<void> ajouterJoueur(Joueur nouveauJoueur) async {
    await _dbHelper.ajouterJoueur(nouveauJoueur);
    state = [...state, nouveauJoueur]; // Ajoute à l'état local
  }

  /// Méthode pour mettre à jour un joueur existant dans la liste ET la base de données.
  Future<void> mettreAJourJoueur(Joueur joueurModifie) async {
    await _dbHelper.mettreAJourJoueur(joueurModifie);
    state = state
        .map((j) => j.id == joueurModifie.id ? joueurModifie : j)
        .toList();
  }

  /// Méthode pour supprimer un joueur de la liste ET la base de données (optionnel).
  Future<void> supprimerJoueur(String id) async {
    await _dbHelper.supprimerJoueur(id);
    state = state.where((j) => j.id != id).toList();
  }
}

/// Provider Riverpod utilisant le StateNotifier [JoueursProvider].
final joueursProvider = StateNotifierProvider<JoueursProvider, List<Joueur>>(
  (ref) => JoueursProvider(),
);
