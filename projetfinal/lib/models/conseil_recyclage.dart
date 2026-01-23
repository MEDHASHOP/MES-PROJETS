/// Modèle représentant un conseil de recyclage
class ConseilRecyclage {
  /// Identifiant unique du conseil
  final String id;

  /// Titre du conseil
  final String titre;

  /// Description détaillée du conseil
  final String description;

  /// Icône associée au conseil
  final String icone;

  /// Catégorie du conseil (ex: plastique, papier, verre, organique)
  final String categorie;

  /// Constructeur de la classe ConseilRecyclage
  ConseilRecyclage({
    required this.id,
    required this.titre,
    required this.description,
    required this.icone,
    required this.categorie,
  });

  /// Crée une copie de l'objet avec des champs optionnels modifiés
  ConseilRecyclage copyWith({
    String? id,
    String? titre,
    String? description,
    String? icone,
    String? categorie,
  }) {
    return ConseilRecyclage(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      description: description ?? this.description,
      icone: icone ?? this.icone,
      categorie: categorie ?? this.categorie,
    );
  }

  /// Convertit l'objet en Map pour le stockage ou la transmission
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'icone': icone,
      'categorie': categorie,
    };
  }

  /// Crée un objet à partir d'un Map
  factory ConseilRecyclage.fromMap(Map<String, dynamic> map) {
    return ConseilRecyclage(
      id: map['id'] ?? '',
      titre: map['titre'] ?? '',
      description: map['description'] ?? '',
      icone: map['icone'] ?? '',
      categorie: map['categorie'] ?? '',
    );
  }

  @override
  String toString() {
    return 'ConseilRecyclage(id: $id, titre: $titre, description: $description, icone: $icone, categorie: $categorie)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConseilRecyclage &&
        other.id == id &&
        other.titre == titre &&
        other.description == description &&
        other.icone == icone &&
        other.categorie == categorie;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        titre.hashCode ^
        description.hashCode ^
        icone.hashCode ^
        categorie.hashCode;
  }
}