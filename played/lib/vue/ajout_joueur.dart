// vue/ajout_joueur.dart
import 'dart:io'; // Pour le type File
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Pour ConsumerStatefulWidget
import '../widgets/image_prise.dart'; // Import du widget ImagePrise
import '../modele/joueur.dart'; // Import de la classe Joueur
import '../providers/joueurs_provider.dart'; // Import du provider

/// Widget basé sur Riverpod pour ajouter un nouveau joueur.
class AjoutJoueurPage extends ConsumerStatefulWidget {
  const AjoutJoueurPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AjoutJoueurPageState();
}

class _AjoutJoueurPageState extends ConsumerState<AjoutJoueurPage> {
  final _nomController = TextEditingController();
  final _prenomsController = TextEditingController();
  final _posteController = TextEditingController();
  final _cotisationController = TextEditingController();
  File? _photoSelectionnee;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomsController.dispose();
    _posteController.dispose();
    _cotisationController.dispose();
    super.dispose();
  }

  void _onPhotoSelectionnee(File image) {
    setState(() {
      _photoSelectionnee = image;
    });
  }

  /// Méthode appelée lors de l'appui sur le bouton "Ajouter".
  void _enregistreJoueur() {
    final nomSaisi = _nomController.text.trim();
    final posteSaisi = _posteController.text.trim();
    final prenomsSaisi = _prenomsController.text.trim();
    final cotisationSaisie =
        double.tryParse(_cotisationController.text.trim()) ?? 0.0;

    if (nomSaisi.isEmpty || posteSaisi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir le nom et le poste.')),
      );
      return;
    }

    // Crée un objet Joueur avec les données du formulaire
    final nouveauJoueur = Joueur(
      nom: nomSaisi,
      poste: posteSaisi,
      prenoms: prenomsSaisi,
      cheminImage: _photoSelectionnee?.path, // Enregistre le chemin de l'image
      cotisation: cotisationSaisie,
    );

    // Appelle la méthode d'ajout du provider
    ref.read(joueursProvider.notifier).ajouterJoueur(nouveauJoueur);

    Navigator.of(context).pop(); // Ferme la page d'ajout
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50, // Arrière-plan bleu clair
      appBar: AppBar(title: const Text('Ajouter un joueur')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(labelText: 'Nom du joueur'),
            ),
            TextField(
              controller: _prenomsController,
              decoration: const InputDecoration(labelText: 'Prénoms du joueur'),
            ),
            TextField(
              controller: _posteController,
              decoration: const InputDecoration(labelText: 'Poste'),
            ),
            TextField(
              controller: _cotisationController,
              decoration: const InputDecoration(labelText: 'Cotisation (cfa)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ImagePrise(onPhotoSelectionnee: _onPhotoSelectionnee),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _enregistreJoueur,
              icon: const Icon(Icons.person_add),
              label: const Text('Ajouter le joueur'),
            ),
          ],
        ),
      ),
    );
  }
}
