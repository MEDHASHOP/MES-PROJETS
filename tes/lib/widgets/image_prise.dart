// lib/widgets/image_prise.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import du package
import 'dart:io'; // Import pour le type File

/// Widget StatefulWidget pour prendre ou sélectionner une photo.
class ImagePrise extends StatefulWidget {
  // Le paramètre 'onPhotoSelectionnee' est une fonction de rappel (callback)
  // Elle sera appelée par ce widget lorsqu'une image sera sélectionnée/take.
  // Elle attend un objet de type File en argument.
  final void Function(File image) onPhotoSelectionnee;

  // Constructeur de la classe ImagePrise
  // Le paramètre 'onPhotoSelectionnee' est requis.
  const ImagePrise({super.key, required this.onPhotoSelectionnee});

  @override
  State<ImagePrise> createState() => _ImagePriseState();
}

class _ImagePriseState extends State<ImagePrise> {
  // Variable d'instance pour stocker l'image sélectionnée
  // File? signifie que c'est un objet File ou null
  File? _photoSelectionnee;

  /// Méthode appelée pour prendre une photo via la caméra.
  void _prendrePhoto() async {
    // Crée une instance du picker
    final imagePicker = ImagePicker();
    // Lance le picker pour prendre une photo
    final photoPrise = await imagePicker.pickImage(source: ImageSource.camera);

    // Vérifie si une photo a été prise (l'utilisateur n'a pas annulé)
    if (photoPrise != null) {
      // Convertit XFile en File standard
      final imageFile = File(photoPrise.path);
      // Met à jour l'état local avec la nouvelle image
      setState(() {
        _photoSelectionnee = imageFile;
      });
      // Appelle la fonction de rappel passée depuis le widget parent (ex: AjoutEndroitPage)
      // pour transmettre l'image sélectionnée.
      // Ici, on appelle la méthode/fonction passée via le paramètre 'onPhotoSelectionnee'.
      widget.onPhotoSelectionnee(imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250, // Hauteur fixe pour l'affichage
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _photoSelectionnee == null
          ? TextButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Prendre photo'),
              onPressed:
                  _prendrePhoto, // Appelle la méthode locale _prendrePhoto
            )
          : GestureDetector(
              onTap:
                  _prendrePhoto, // Permet de reprendre une photo en tapant sur l'affiche
              child: Image.file(
                _photoSelectionnee!, // L'image sélectionnée est affichée ici
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
    );
  }
}
