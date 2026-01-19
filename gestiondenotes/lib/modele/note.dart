// lib/modele/note.dart
class Note {
  final int? id;
  final String titre;
  final String contenu;
  final DateTime dateCreation;

  Note({
    this.id,
    required this.titre,
    required this.contenu,
    required this.dateCreation,
  });

  // Constructeur pour créer une nouvelle note sans ID (pour l'insertion)
  factory Note.sansId({required String titre, required String contenu}) {
    return Note(
      id: null,
      titre: titre,
      contenu: contenu,
      dateCreation: DateTime.now(),
    );
  }

  // Convertir l'objet en Map pour la base de données
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'contenu': contenu,
      'date_creation': dateCreation.toIso8601String(),
    };
  }

  // Créer un objet Note à partir d'un Map (de la base de données)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      titre: map['titre'] as String,
      contenu: map['contenu'] as String,
      dateCreation: DateTime.parse(map['date_creation'] as String),
    );
  }
}
