// lib/ajout_redacteur_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

/// Page pour ajouter un nouveau rédacteur.
class AjoutRedacteurPage extends StatefulWidget {
  const AjoutRedacteurPage({super.key});

  @override
  State<AjoutRedacteurPage> createState() => _AjoutRedacteurPageState();
}

class _AjoutRedacteurPageState extends State<AjoutRedacteurPage> {
  final _formKey = GlobalKey<FormState>(); // Clé pour le formulaire
  final _nomController = TextEditingController();
  final _specialiteController = TextEditingController();

  final _firestore = FirebaseFirestore.instance; // Instance de Firestore

  // Style pour le bouton
  final ButtonStyle styleBouton = ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  );

  /// Méthode appelée lors de la soumission du formulaire.
  void _ajouterRedacteur() async {
    if (_formKey.currentState!.validate()) {
      // Valide le formulaire
      try {
        // Ajoute un nouveau document à la collection 'redacteurs'
        await _firestore.collection('redacteurs').add({
          'nom': _nomController.text.trim(),
          'specialite': _specialiteController.text.trim(),
        });

        // Vérifie que le widget est toujours monté avant d'utiliser le context
        if (mounted) {
          // Affiche une boîte de dialogue de succès
          _afficherSuccesDialog(context);
        }
      } catch (e) {
        // Vérifie que le widget est toujours monté avant d'utiliser le context
        if (mounted) {
          // Gestion d'erreur simple (vous pouvez améliorer cela)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de l\'ajout du rédacteur.'),
            ),
          );
        }
        debugPrint("Erreur Firestore: $e");
      }
    }
  }

  /// Affiche une boîte de dialogue de confirmation de succès.
  void _afficherSuccesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Succès'),
          content: const Text('Le rédacteur a été ajouté avec succès.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
                // Vérifie que le widget est toujours monté avant de naviguer
                if (mounted) {
                  Navigator.of(
                    context,
                  ).pop(); // Retourne à la page précédente (PageAccueil)
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
  void dispose() {
    _nomController.dispose();
    _specialiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un Rédacteur')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Associe la clé au formulaire
          child: Column(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _specialiteController,
                decoration: const InputDecoration(
                  labelText: 'Spécialité',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une spécialité';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: styleBouton,
                onPressed: _ajouterRedacteur,
                child: const Text('Ajouter le rédacteur'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
