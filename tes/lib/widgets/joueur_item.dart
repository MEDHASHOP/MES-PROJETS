// widgets/joueur_item.dart
import 'package:flutter/material.dart';
import 'dart:io'; // <-- Import manquant pour utiliser File
import '../modele/joueur.dart'; // Import de la classe Joueur

/// Widget Stateless affichant un joueur et permettant de modifier sa présence.
class JoueurItem extends StatelessWidget {
  final Joueur joueur;
  final void Function(Joueur joueur)
  onPresenceChange; // Callback pour la présence
  final void Function(Joueur joueur) onButIncrement; // Callback pour les buts

  const JoueurItem({
    super.key,
    required this.joueur,
    required this.onPresenceChange,
    required this.onButIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Affichage de la photo du joueur
            if (joueur.cheminImage != null)
              CircleAvatar(
                radius: 25, // Propriété spécifique à CircleAvatar
                backgroundImage: FileImage(
                  // ATTENTION : File(joueur.cheminImage!) est risqué si le fichier n'existe plus
                  // En production, vérifiez l'existence du fichier ou utilisez des chemins relatifs.
                  File(joueur.cheminImage!),
                ),
              )
            else
              const CircleAvatar(
                radius: 25, // Propriété spécifique à CircleAvatar
                child: Icon(Icons.person), // 'child' est maintenant à la fin
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    joueur.nom,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    joueur.poste,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text('Buts: ${joueur.nbButs}'),
                ],
              ),
            ),
            // Case à cocher pour la présence
            Checkbox(
              value: joueur.estPresent,
              onChanged: (bool? newValue) {
                if (newValue != null) {
                  // Appelle la fonction de rappel passée depuis le parent (ex: GestionPresencePage)
                  onPresenceChange(joueur.copyWith(estPresent: newValue));
                }
              },
            ),
            // Bouton pour incrémenter les buts
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Appelle la fonction de rappel passée depuis le parent (ex: GestionPresencePage)
                onButIncrement(joueur.copyWith(nbButs: joueur.nbButs + 1));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Extension pour créer facilement une copie modifiée d'un joueur
extension JoueurCopyWith on Joueur {
  Joueur copyWith({
    String? id,
    String? nom,
    String? prenoms,
    String? poste,
    String? cheminImage,
    int? nbButs,
    bool? estPresent,
  }) {
    return Joueur(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      poste: poste ?? this.poste,
      prenoms: prenoms ?? this.prenoms,
      cheminImage: cheminImage ?? this.cheminImage,
      nbButs: nbButs ?? this.nbButs,
      estPresent: estPresent ?? this.estPresent,
    );
  }
}
