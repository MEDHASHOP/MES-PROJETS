// lib/modifier_redacteur_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

/// Page pour modifier les informations d'un rédacteur.
class ModifierRedacteurPage extends StatefulWidget {
  final String redacteurId; // L'ID du rédacteur à modifier
  final Map<String, dynamic> redacteurData; // Les données actuelles

  const ModifierRedacteurPage({
    super.key,
    required this.redacteurId,
    required this.redacteurData,
  });

  @override
  State<ModifierRedacteurPage> createState() => _ModifierRedacteurPageState();
}

class _ModifierRedacteurPageState extends State<ModifierRedacteurPage> {
  late final TextEditingController _nomController;
  late final TextEditingController _specialiteController;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Instance de Firestore

  @override
  void initState() {
    super.initState();
    // Initialise les contrôleurs avec les données existantes
    _nomController = TextEditingController(text: widget.redacteurData['nom']);
    _specialiteController = TextEditingController(
      text: widget.redacteurData['specialite'],
    );
  }

  @override
  void dispose() {
    _nomController.dispose();
    _specialiteController.dispose();
    super.dispose();
  }

  /// Méthode appelée pour enregistrer les modifications.
  void _enregistrerModifications() async {
    try {
      // Met à jour le document dans Firestore
      await _firestore.collection('redacteurs').doc(widget.redacteurId).update({
        'nom': _nomController.text.trim(),
        'specialite': _specialiteController.text.trim(),
      });

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
          const SnackBar(content: Text('Erreur lors de la modification.')),
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
          title: const Text('Modifications enregistrées'),
          content: const Text(
            'Les informations du rédacteur ont été modifiées avec succès.',
          ),
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
      appBar: AppBar(title: const Text('Modifier le Rédacteur')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nomController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _specialiteController,
              decoration: const InputDecoration(
                labelText: 'Spécialité',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _enregistrerModifications,
              child: const Text('Enregistrer les modifications'),
            ),
          ],
        ),
      ),
    );
  }
}
