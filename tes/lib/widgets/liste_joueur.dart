// widgets/liste_joueurs.dart
import 'package:flutter/material.dart';
import '../modele/joueur.dart'; // Import du modèle Joueur
import 'joueur_item.dart'; // Import du widget JoueurItem

/// Widget Stateless affichant une liste de joueurs.
class ListeJoueurs extends StatelessWidget {
  final List<Joueur> joueurs;

  const ListeJoueurs({super.key, required this.joueurs});

  @override
  Widget build(BuildContext context) {
    if (joueurs.isEmpty) {
      return const Center(child: Text('Aucun joueur enregistré.'));
    } else {
      return ListView.builder(
        itemCount: joueurs.length,
        itemBuilder: (context, index) {
          return JoueurItem(
            joueur: joueurs[index],
            onPresenceChange: (joueur) {
              // Cette fonction sera probablement vide ou appellera une méthode du provider
              // pour mettre à jour la présence dans l'état global et la base de données.
              // Exemple : ref.read(joueursProvider.notifier).mettreAJourJoueur(joueur);
            },
            onButIncrement: (joueur) {
              // Cette fonction sera probablement vide ou appellera une méthode du provider
              // pour mettre à jour les buts dans l'état global et la base de données.
              // Exemple : ref.read(joueursProvider.notifier).mettreAJourJoueur(joueur);
            },
          );
        },
      );
    }
  }
}
