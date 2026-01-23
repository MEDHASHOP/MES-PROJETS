class Utilisateur {
  final String id;
  final String nomUtilisateur;
  final String email;
  final String avatarUrl;
  final String ville;
  final String pays;
  final int quantiteTriee;
  final Map<String, int> repartitionDechets;
  final List<String> badges;
  final DateTime dateCreation;
  final Map<String, int> progressionMensuelle; // Mois (ex: "Janvier 2024") -> quantité triée
  final List<BadgeObtenu> historiqueBadges;

  Utilisateur({
    required this.id,
    required this.nomUtilisateur,
    required this.email,
    required this.avatarUrl,
    required this.ville,
    required this.pays,
    required this.quantiteTriee,
    required this.repartitionDechets,
    required this.badges,
    required this.dateCreation,
    this.progressionMensuelle = const {},
    this.historiqueBadges = const [],
  });

  /// 🔄 Méthode pour copier et mettre à jour facilement
  Utilisateur copyWith({
    String? nomUtilisateur,
    String? email,
    String? avatarUrl,
    String? ville,
    String? pays,
    int? quantiteTriee,
    Map<String, int>? repartitionDechets,
    List<String>? badges,
    DateTime? dateCreation,
    Map<String, int>? progressionMensuelle,
    List<BadgeObtenu>? historiqueBadges,
  }) {
    return Utilisateur(
      id: id,
      nomUtilisateur: nomUtilisateur ?? this.nomUtilisateur,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      ville: ville ?? this.ville,
      pays: pays ?? this.pays,
      quantiteTriee: quantiteTriee ?? this.quantiteTriee,
      repartitionDechets: repartitionDechets ?? this.repartitionDechets,
      badges: badges ?? this.badges,
      dateCreation: dateCreation ?? this.dateCreation,
      progressionMensuelle: progressionMensuelle ?? this.progressionMensuelle,
      historiqueBadges: historiqueBadges ?? this.historiqueBadges,
    );
  }

  /// 🔄 Conversion vers Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomUtilisateur': nomUtilisateur,
      'email': email,
      'avatarUrl': avatarUrl,
      'ville': ville,
      'pays': pays,
      'quantiteTriee': quantiteTriee,
      'repartitionDechets': repartitionDechets,
      'badges': badges,
      'dateCreation': dateCreation.toIso8601String(),
      'progressionMensuelle': progressionMensuelle,
      'historiqueBadges': historiqueBadges.map((badge) => badge.toMap()).toList(),
    };
  }

  /// 🔄 Conversion depuis Map (Firestore → Objet)
  factory Utilisateur.fromMap(Map<String, dynamic> data, String docId) {
    return Utilisateur(
      id: docId,
      nomUtilisateur: data['nomUtilisateur'] ?? '',
      email: data['email'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
      ville: data['ville'] ?? '',
      pays: data['pays'] ?? '',
      quantiteTriee: data['quantiteTriee'] ?? 0,
      repartitionDechets:
          Map<String, int>.from(data['repartitionDechets'] ?? {}),
      badges: List<String>.from(data['badges'] ?? []),
      dateCreation:
          DateTime.tryParse(data['dateCreation'] ?? '') ?? DateTime.now(),
      progressionMensuelle:
          Map<String, int>.from(data['progressionMensuelle'] ?? {}),
      historiqueBadges: (data['historiqueBadges'] as List<dynamic>?)
              ?.map((item) => BadgeObtenu.fromMap(item))
              .toList() ??
          [],
    );
  }
}

// Classe pour représenter un badge obtenu avec sa date
class BadgeObtenu {
  final String nom;
  final String description;
  final DateTime dateObtention;

  BadgeObtenu({
    required this.nom,
    required this.description,
    required this.dateObtention,
  });

  // Méthode pour créer un BadgeObtenu depuis un Map
  factory BadgeObtenu.fromMap(Map<String, dynamic> data) {
    return BadgeObtenu(
      nom: data['nom'] ?? '',
      description: data['description'] ?? '',
      dateObtention: DateTime.tryParse(data['dateObtention'] ?? '') ?? DateTime.now(),
    );
  }

  // Méthode pour convertir un BadgeObtenu en Map
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'description': description,
      'dateObtention': dateObtention.toIso8601String(),
    };
  }
}

// Utilisateur par défaut (konepichor)
// NOTE: Cet utilisateur est défini ici pour éviter une dépendance circulaire
// Les données réelles devraient provenir de Firebase
final utilisateur = Utilisateur(
  id: 'default_user',
  nomUtilisateur: 'Utilisateur par défaut',
  email: 'default@desdechets.ci',
  avatarUrl: 'assets/images/default_avatar.png',
  ville: 'Abidjan',
  pays: 'Côte d\'Ivoire',
  quantiteTriee: 95,
  repartitionDechets: {
    'Plastique': 30,
    'Papier': 25,
    'Verre': 20,
    'Métal': 20,
  },
  badges: ['Écolo débutant', 'Tri expert'],
  dateCreation: DateTime.now(),
  progressionMensuelle: {
    'Janvier 2024': 15,
    'Février 2024': 20,
    'Mars 2024': 18,
    'Avril 2024': 22,
    'Mai 2024': 20,
  },
  historiqueBadges: [
    BadgeObtenu(
      nom: 'Écolo débutant',
      description: 'Premiers pas dans le recyclage',
      dateObtention: DateTime(2024, 1, 15),
    ),
    BadgeObtenu(
      nom: 'Tri expert',
      description: '100 kg de déchets triés',
      dateObtention: DateTime(2024, 3, 22),
    ),
  ],
);
