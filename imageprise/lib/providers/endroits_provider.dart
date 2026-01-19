// lib/providers/endroits_utilisateurs.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../modele/endroit.dart'; // Import de la classe Endroit (modifiée pour inclure image)

/// Classe StateNotifier gérant la liste des [Endroit].
class EndroitsUtilisateur extends StateNotifier<List<Endroit>> {
  EndroitsUtilisateur() : super(const []); // État initial : liste vide

  /// Méthode pour ajouter un nouvel endroit (complet, avec nom et image) à la liste.
  /// Le paramètre est maintenant de type [Endroit].
  void ajoutEndroit(Endroit nouvelEndroit) {
    // Ajoute le nouvel objet Endroit directement à la liste
    state = [nouvelEndroit, ...state];
  }
}

/// Provider Riverpod utilisant le StateNotifier [EndroitsUtilisateur].
final endroitsProvider =
    StateNotifierProvider<EndroitsUtilisateur, List<Endroit>>(
      (ref) => EndroitsUtilisateur(),
    );
