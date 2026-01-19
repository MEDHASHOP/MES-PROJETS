// lib/supprimer_redacteur_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

/// Page de confirmation pour la suppression d'un rédacteur.
class SupprimerRedacteurPage extends StatefulWidget {
  final String redacteurId; // L'ID du rédacteur à supprimer
  final String? nomRedacteur; // Le nom pour l'affichage

  const SupprimerRedacteurPage({
    super.key,
    required this.redacteurId,
    this.nomRedacteur,
  });

  @override
  State<SupprimerRedacteurPage> createState() => _SupprimerRedacteurPageState();
}

class _SupprimerRedacteurPageState extends State<SupprimerRedacteurPage> {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Instance de Firestore

  // Style personnalisé pour le bouton de suppression
  final ButtonStyle styleBoutonSupprimer = ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
  );

  /// Méthode appelée pour supprimer le rédacteur.
  void _supprimerRedacteur() async {
    try {
      // Supprime le document dans Firestore
      await _firestore
          .collection('redacteurs')
          .doc(widget.redacteurId)
          .delete();

      // Vérifie que le widget est toujours monté avant d'utiliser le context
      if (mounted) {
        // Affiche une boîte de dialogue de confirmation
        _afficherConfirmationDialog(context);
      }
    } catch (e) {
      // Vérifie que le widget est toujours monté avant d'utiliser le context
      if (mounted) {
        // Gestion d'erreur simple
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la suppression.')),
        );
      }
      debugPrint("Erreur Firestore: $e");
    }
  }

  /// Affiche une boîte de dialogue de confirmation.
  void _afficherConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rédacteur supprimé'),
          content: const Text('Le rédacteur a été supprimé avec succès.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
                // Vérifie que le widget est toujours monté avant de naviguer
                if (mounted) {
                  Navigator.of(
                    context,
                  ).pop(); // Retourne à la page précédente (RedacteurInfoPage)
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Supprimer le Rédacteur')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Êtes-vous sûr de vouloir supprimer le rédacteur "${widget.nomRedacteur ?? "Inconnu"}" ?',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: styleBoutonSupprimer,
              onPressed: _supprimerRedacteur,
              child: const Text('Supprimer le rédacteur'),
            ),
          ],
        ),
      ),
    );
  }
}
