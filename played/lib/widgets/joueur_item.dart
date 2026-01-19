// widgets/joueur_item.dart
import 'package:flutter/material.dart';
import 'dart:io'; // <-- Import manquant pour utiliser File
import 'package:image_picker/image_picker.dart'; // Pour sélectionner une image
import '../modele/joueur.dart'; // Import de la classe Joueur
import '../vue/edition_joueur.dart'; // Import pour EditionJoueurPage

/// Widget Stateful affichant un joueur et permettant de modifier sa présence et photo.
class JoueurItem extends StatefulWidget {
  final Joueur joueur;
  final void Function(Joueur joueur)?
  onPresenceChange; // Callback pour la présence
  final void Function(Joueur joueur)? onButIncrement; // Callback pour les buts
  final void Function(Joueur joueur)?
  onPhotoChange; // Callback pour changer la photo

  const JoueurItem({
    super.key,
    required this.joueur,
    this.onPresenceChange,
    this.onButIncrement,
    this.onPhotoChange,
  });

  @override
  State<JoueurItem> createState() => _JoueurItemState();
}

class _JoueurItemState extends State<JoueurItem> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final updatedJoueur = widget.joueur.copyWith(cheminImage: image.path);
      widget.onPhotoChange?.call(updatedJoueur);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Affichage de la photo du joueur avec bouton pour changer
            GestureDetector(
              onTap: widget.onPhotoChange != null ? _pickImage : null,
              child: Stack(
                children: [
                  if (widget.joueur.cheminImage != null)
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: FileImage(
                        File(widget.joueur.cheminImage!),
                      ),
                    )
                  else
                    const CircleAvatar(radius: 25, child: Icon(Icons.person)),
                  if (widget.onPhotoChange != null)
                    const Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.edit, size: 12, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.joueur.nom,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    widget.joueur.poste,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text('Buts: ${widget.joueur.nbButs}'),
                  Text('Cotisation: ${widget.joueur.cotisation}€'),
                  Text(
                    'Présences: ${widget.joueur.presences.where((p) => p).length}/${widget.joueur.presences.length}',
                  ),
                ],
              ),
            ),
            // Case à cocher pour la présence
            if (widget.onPresenceChange != null)
              Checkbox(
                value: widget.joueur.estPresent,
                onChanged: (bool? newValue) {
                  if (newValue != null) {
                    widget.onPresenceChange!(
                      widget.joueur.copyWith(estPresent: newValue),
                    );
                  }
                },
              )
            else
              Checkbox(value: widget.joueur.estPresent, onChanged: null),
            // Bouton pour éditer le joueur
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        EditionJoueurPage(joueur: widget.joueur),
                  ),
                );
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
    double? cotisation,
    List<bool>? presences,
  }) {
    return Joueur(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      poste: poste ?? this.poste,
      prenoms: prenoms ?? this.prenoms,
      cheminImage: cheminImage ?? this.cheminImage,
      nbButs: nbButs ?? this.nbButs,
      estPresent: estPresent ?? this.estPresent,
      cotisation: cotisation ?? this.cotisation,
      presences: presences ?? this.presences,
    );
  }
}
