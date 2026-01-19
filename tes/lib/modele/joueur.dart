// modele/joueur
import 'package:uuid/uuid.dart'; // Pour générer des IDs uniques

// Créer une constante instance de la classe Uuid
const uuid = Uuid();

/// Modèle de données pour un joueur de l'équipe.
class Joueur {
  final String id;
  final String nom;
  final String prenoms;
  final String poste;
  final String?
  cheminImage; // Stocke le chemin de l'image, pas l'objet File directement
  int nbButs; // Utilisez 'int' pour le compteur de buts
  bool estPresent; // Utilisez 'bool' pour la présence

  /// Constructeur pour un joueur existant (chargé de la base de données)
  Joueur({
    String? id,
    required this.nom,
    required this.poste,
    required this.prenoms,
    this.cheminImage,
    this.nbButs = 0, // Valeur par défaut
    this.estPresent = false, // Valeur par défaut
  }) : id = id ?? uuid.v4(); // Génère un ID si non fourni

  /// Constructeur nommé pour créer un joueur à partir d'une Map (depuis la base de données)
  Joueur.fromMap(Map<String, dynamic> map)
    : id = map['id'] as String,
      nom = map['nom'] as String,
      poste = map['poste'] as String,
      prenoms = map['prenoms'] as String,
      cheminImage = map['chemin_image'] as String?,
      nbButs = map['nb_buts'] as int,
      estPresent =
          map['est_present'] == 1; // SQLite stocke booléen comme int (0 ou 1)

  /// Méthode pour convertir un joueur en Map (pour l'insérer dans la base de données)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'poste': poste,
      'prenoms': prenoms,
      'chemin_image': cheminImage,
      'nb_buts': nbButs,
      'est_present': estPresent ? 1 : 0, // Convertit booléen en int pour SQLite
    };
  }
}
