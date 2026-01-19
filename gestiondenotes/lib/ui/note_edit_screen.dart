// lib/ui/note_edit_screen.dart
import 'package:flutter/material.dart';
import '../modele/note.dart';
import '../service/databasemanager.dart';

class NoteEditScreen extends StatefulWidget {
  final Note? note; // Note optionnelle : si null, c'est une création

  const NoteEditScreen({super.key, this.note});

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final _titreController = TextEditingController();
  final _contenuController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Si on a une note, pré-remplir les champs
    if (widget.note != null) {
      _titreController.text = widget.note!.titre;
      _contenuController.text = widget.note!.contenu;
    }
  }

  void _enregistrerNote() async {
    if (_titreController.text.isEmpty || _contenuController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }

    Note note;
    if (widget.note != null) {
      // Modification
      note = Note(
        id: widget.note!.id,
        titre: _titreController.text.trim(),
        contenu: _contenuController.text.trim(),
        dateCreation: widget.note!.dateCreation,
      );
      await DatabaseManager.instance.updateNote(note);
    } else {
      // Création
      note = Note.sansId(
        titre: _titreController.text.trim(),
        contenu: _contenuController.text.trim(),
      );
      await DatabaseManager.instance.insertNote(note);
    }

    // ✅ Correction : vérifier si le widget est encore monté avant d'utiliser le contexte
    if (!mounted) return;
    Navigator.pop(context); // Retourner à la liste des notes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Nouvelle Note' : 'Modifier la Note'),
        backgroundColor: const Color.fromARGB(
          255,
          6,
          27,
          255,
        ), // Couleur de fond de l'AppBar
        foregroundColor:
            Colors.white, // Couleur du texte et des icônes de l'AppBar
      ),
      backgroundColor: const Color.fromARGB(
        255,
        36,
        2,
        255,
      ), // Couleur de fond du Scaffold
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titreController,
              decoration: const InputDecoration(
                labelText: 'Titre',
                labelStyle: TextStyle(
                  color:
                      Colors.white, // Couleur du label (blanc pour contraste)
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white, // Ligne de soulignement quand focus
                  ),
                ),
              ),
              style: const TextStyle(
                color: Colors
                    .white, // Couleur du texte saisi (blanc pour contraste)
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contenuController,
                decoration: const InputDecoration(
                  labelText: 'Contenu',
                  labelStyle: TextStyle(
                    color:
                        Colors.white, // Couleur du label (blanc pour contraste)
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors
                          .white, // Ligne de soulignement quand focus (blanc pour contraste)
                    ),
                  ),
                ),
                style: const TextStyle(
                  color: Colors
                      .white, // Couleur du texte saisi (blanc pour contraste)
                ),
                maxLines: null,
                expands: true,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                      255,
                      9,
                      13,
                      252,
                    ), // Couleur de fond du bouton Annuler
                    foregroundColor:
                        Colors.white, // Couleur du texte du bouton Annuler
                  ),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: _enregistrerNote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                      255,
                      5,
                      43,
                      235,
                    ), // Couleur de fond du bouton Enregistrer
                    foregroundColor:
                        Colors.white, // Couleur du texte du bouton Enregistrer
                  ),
                  child: const Text('Enregistrer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
