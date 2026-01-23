import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart'; // Pour debugPrint

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Télécharger une image vers Firebase Storage
  /// Retourne l'URL de téléchargement et le chemin interne
  Future<Map<String, String>> uploadImage(File imageFile, String userId) async {
    try {
      // Créer un chemin unique pour l'image de profil
      String fileName =
          'profil_images/$userId/${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';
      Reference reference = _storage.ref().child(fileName);

      UploadTask uploadTask = reference.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Retourner à la fois l’URL publique et le chemin interne
      return {
        'url': downloadUrl,
        'path': fileName,
      };
    } catch (e) {
      throw Exception('Erreur lors du téléchargement de l\'image: $e');
    }
  }

  /// Supprimer une ancienne image de profil via son chemin interne
  Future<void> deleteImage(String? imagePath) async {
    if (imagePath != null && imagePath.isNotEmpty) {
      try {
        Reference reference = _storage.ref().child(imagePath);
        await reference.delete();
      } catch (e) {
        debugPrint('Erreur lors de la suppression de l\'ancienne image: $e');
      }
    }
  }
}
