// lib/vue/ajout_endroit.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/image_prise.dart';
import '../modele/endroit.dart';
import '../providers/endroits_provider.dart'; // Assurez-vous que le nom est correct

class AjoutEndroitPage extends ConsumerStatefulWidget {
  const AjoutEndroitPage({super.key});

  @override
  ConsumerState<AjoutEndroitPage> createState() => _AjoutEndroitPageState();
}

class _AjoutEndroitPageState extends ConsumerState<AjoutEndroitPage> {
  final TextEditingController _nomController = TextEditingController();
  File? _image;

  void _onPhotoSelectionnee(File image) {
    // Corrigez le nom de la fonction ici aussi
    setState(() {
      _image = image;
    });
  }

  void _enregistreEndroit() {
    final nom = _nomController.text.trim();
    if (nom.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Veuillez saisir un nom')));
      return;
    }

    // Créez l'objet Endroit complet
    final endroit = Endroit(nom: nom, image: _image);

    // Passez l'objet Endroit au provider, PAS juste le nom
    ref.read(endroitsProvider.notifier).ajoutEndroit(endroit);

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _nomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajout d'un nouveau endroit")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(
                labelText: "Nom d'endroit",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ImagePrise(
              onPhotoSelectionnee:
                  _onPhotoSelectionnee, // Utilisez le nom correct ici
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _enregistreEndroit,
              icon: const Icon(Icons.add),
              label: const Text("Ajouter un nouveau endroit"),
            ),
          ],
        ),
      ),
    );
  }
}
