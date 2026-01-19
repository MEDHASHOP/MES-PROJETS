// widgets/liste_joueurs.dart
import 'package:flutter/material.dart';
import '../modele/joueur.dart'; // Import du modèle Joueur
import 'joueur_item.dart'; // Import du widget JoueurItem

/// Widget Stateless affichant une liste de joueurs.
class ListeJoueurs extends StatelessWidget {
  final List<Joueur> joueurs;
  final void Function(Joueur)? onPresenceChange;
  final void Function(Joueur)? onButIncrement;
  final void Function(Joueur)? onPhotoChange;

  const ListeJoueurs({
    super.key,
    required this.joueurs,
    this.onPresenceChange,
    this.onButIncrement,
    this.onPhotoChange,
  });

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
            onPresenceChange: onPresenceChange ?? (joueur) {},
            onButIncrement: onButIncrement ?? (joueur) {},
            onPhotoChange: onPhotoChange ?? (joueur) {},
          );
        },
      );
    }
  }
}
