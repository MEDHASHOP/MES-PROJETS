// vue/edition_joueur.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/image_prise.dart';
import '../widgets/joueur_item.dart'; // Pour l'extension copyWith
import '../modele/joueur.dart';
import '../providers/joueurs_provider.dart';

class EditionJoueurPage extends ConsumerStatefulWidget {
  final Joueur joueur;

  const EditionJoueurPage({super.key, required this.joueur});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditionJoueurPageState();
}

class _EditionJoueurPageState extends ConsumerState<EditionJoueurPage> {
  late TextEditingController _nomController;
  late TextEditingController _prenomsController;
  late TextEditingController _posteController;
  late TextEditingController _cotisationController;
  File? _photoSelectionnee;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.joueur.nom);
    _prenomsController = TextEditingController(text: widget.joueur.prenoms);
    _posteController = TextEditingController(text: widget.joueur.poste);
    _cotisationController = TextEditingController(
      text: widget.joueur.cotisation.toString(),
    );
    _photoSelectionnee = widget.joueur.cheminImage != null
        ? File(widget.joueur.cheminImage!)
        : null;
  }

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

  void _sauvegarderJoueur() {
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

    final joueurModifie = widget.joueur.copyWith(
      nom: nomSaisi,
      prenoms: prenomsSaisi,
      poste: posteSaisi,
      cheminImage: _photoSelectionnee?.path,
      cotisation: cotisationSaisie,
    );

    ref.read(joueursProvider.notifier).mettreAJourJoueur(joueurModifie);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50, // Arrière-plan bleu clair
      appBar: AppBar(title: const Text('Éditer le joueur')),
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
              onPressed: _sauvegarderJoueur,
              icon: const Icon(Icons.save),
              label: const Text('Sauvegarder'),
            ),
          ],
        ),
      ),
    );
  }
}
