// lib/ui/notes_list_screen.dart
import 'package:flutter/material.dart';
import '../modele/note.dart';
import '../service/databasemanager.dart';
import 'note_edit_screen.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  late Future<List<Note>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _refreshNotesList();
  }

  void _refreshNotesList() {
    setState(() {
      _notesFuture = DatabaseManager.instance.getAllNotes();
    });
  }

  void _ajouterNote() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NoteEditScreen()),
    ).then((_) => _refreshNotesList());
  }

  void _modifierNote(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteEditScreen(note: note)),
    ).then((_) => _refreshNotesList());
  }

  void _confirmerSuppression(Note note) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmation'),
        content: Text(
          'Voulez-vous vraiment supprimer la note "${note.titre}" ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              await DatabaseManager.instance.deleteNote(note.id!);
              _refreshNotesList();
              if (!mounted) return;
              Navigator.of(context).pop();
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Notes'),
        backgroundColor: const Color.fromARGB(255, 14, 11, 227),
        foregroundColor: Colors.white,
        // Couleur du texte et des icônes (facultatif, si besoin de contraste)
      ),
      body: Column(
        children: [
          // Bouton d'ajout
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _ajouterNote,
              icon: const Icon(Icons.add),
              label: const Text(
                'Ajouter une Note',
                style: TextStyle(fontSize: 18), // Agrandir la taille du texte
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(
                  255,
                  4,
                  27,
                  237,
                ), // Changer la couleur de fond
                foregroundColor:
                    Colors.white, // Changer la couleur du texte et de l'icône
                shape: RoundedRectangleBorder(
                  // Pour arrondir les coins
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ), // Rayon de l'arrondi
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ), // Ajuster le padding pour agrandir le bouton
              ),
            ),
          ),
          const Divider(),
          // Liste des notes
          Expanded(
            child: FutureBuilder<List<Note>>(
              future: _notesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erreur : ${snapshot.error}'));
                }
                final notes = snapshot.data ?? [];

                if (notes.isEmpty) {
                  return const Center(child: Text('Aucune note enregistrée.'));
                }

                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(note.titre),
                        subtitle: Text(
                          note.contenu.substring(
                                0,
                                note.contenu.length > 50
                                    ? 50
                                    : note.contenu.length,
                              ) +
                              (note.contenu.length > 50 ? '...' : ''),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _modifierNote(note),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmerSuppression(note),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
