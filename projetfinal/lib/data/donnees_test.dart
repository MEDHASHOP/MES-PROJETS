import '../models/index.dart';

/// Données de test pour l'application DésDéchets

// Utilisateurs
final utilisateurExemple = Utilisateur(
  id: 'user001',
  nomUtilisateur: 'konepichor',
  email: 'konepichor@desdechets.ci',
  avatarUrl: 'assets/images/konepichor.png',
  ville: 'Abidjan',
  pays: 'Côte d\'Ivoire',
  quantiteTriee: 120,
  repartitionDechets: {
    'plastique': 50,
    'papier': 30,
    'verre': 25,
    'organique': 15,
  },
  badges: ['100 kg triés', 'Tri complet 7 jours'],
  dateCreation: DateTime(2025, 9, 15),
);

final utilisateurAmina = Utilisateur(
  id: 'user002',
  nomUtilisateur: 'amina_bouaké',
  email: 'amina@desdechets.ci',
  avatarUrl: 'assets/images/amina.png',
  ville: 'Bouaké',
  pays: 'Côte d\'Ivoire',
  quantiteTriee: 80,
  repartitionDechets: {
    'plastique': 40,
    'papier': 20,
    'verre': 25,
    'organique': 15,
  },
  badges: ['Tri régulier'],
  dateCreation: DateTime(2025, 10, 10),
);

final utilisateurYves = Utilisateur(
  id: 'user003',
  nomUtilisateur: 'yves_yakro',
  email: 'yves@desdechets.ci',
  avatarUrl: 'assets/images/yves.png',
  ville: 'Yamoussoukro',
  pays: 'Côte d\'Ivoire',
  quantiteTriee: 150,
  repartitionDechets: {
    'plastique': 30,
    'papier': 25,
    'verre': 20,
    'organique': 25,
  },
  badges: ['Champion du tri', '150 kg triés'],
  dateCreation: DateTime(2025, 8, 5),
);

final utilisateurFatou = Utilisateur(
  id: 'user004',
  nomUtilisateur: 'fatou_sanpedro',
  email: 'fatou@desdechets.ci',
  avatarUrl: 'assets/images/fatou.png',
  ville: 'San Pedro',
  pays: 'Côte d\'Ivoire',
  quantiteTriee: 60,
  repartitionDechets: {
    'plastique': 45,
    'papier': 15,
    'verre': 20,
    'organique': 20,
  },
  badges: ['Débutante active'],
  dateCreation: DateTime(2025, 11, 20),
);

// Points de collecte
final pointPlateau = PointCollecte(
  id: 'point001',
  nom: 'Centre de recyclage – Plateau',
  typeDechetsAcceptes: ['plastique', 'verre', 'papier'],
  latitude: 5.3485,
  longitude: -4.0078,
  horaires: '8h – 18h',
  ville: 'Abidjan',
);

final pointBouake = PointCollecte(
  id: 'point002',
  nom: 'Décharge municipale – Bouaké',
  typeDechetsAcceptes: ['organique', 'plastique'],
  latitude: 7.6881,
  longitude: -5.0265,
  horaires: '7h – 17h',
  ville: 'Bouaké',
);

final pointYamoussoukro = PointCollecte(
  id: 'point003',
  nom: 'Station de tri – Yamoussoukro',
  typeDechetsAcceptes: ['papier', 'verre'],
  latitude: 6.8261,
  longitude: -5.2828,
  horaires: '8h – 18h',
  ville: 'Yamoussoukro',
);

final pointSanPedro = PointCollecte(
  id: 'point004',
  nom: 'Coopérative verte – San Pedro',
  typeDechetsAcceptes: ['organique', 'plastique', 'verre'],
  latitude: 4.7492,
  longitude: -6.6608,
  horaires: '7h – 19h',
  ville: 'San Pedro',
);

// Collectes
final collecteExemple = Collecte(
  id: 'collecte001',
  date: DateTime(2026, 1, 20),
  typeDechets: 'plastique',
  lieu: pointPlateau,
  utilisateur: utilisateurExemple,
);

final collecteAmina = Collecte(
  id: 'collecte002',
  date: DateTime(2026, 1, 18),
  typeDechets: 'papier',
  lieu: pointBouake,
  utilisateur: utilisateurAmina,
);

final collecteYves = Collecte(
  id: 'collecte003',
  date: DateTime(2026, 1, 15),
  typeDechets: 'verre',
  lieu: pointYamoussoukro,
  utilisateur: utilisateurYves,
);

final collecteFatou = Collecte(
  id: 'collecte004',
  date: DateTime(2026, 1, 12),
  typeDechets: 'organique',
  lieu: pointSanPedro,
  utilisateur: utilisateurFatou,
);

// Conseils de recyclage
final conseilPlastique = ConseilRecyclage(
  id: 'conseil001',
  titre: 'Plastique',
  description:
      'Évitez les sachets plastiques, privilégiez les bouteilles réutilisables.',
  icone: '♳',
  categorie: 'plastique',
);

final conseilPapier = ConseilRecyclage(
  id: 'conseil002',
  titre: 'Papier',
  description: 'Recyclez journaux, cahiers et cartons propres.',
  icone: '📄',
  categorie: 'papier',
);

final conseilVerre = ConseilRecyclage(
  id: 'conseil003',
  titre: 'Verre',
  description: 'Déposez bouteilles et bocaux sans bouchon.',
  icone: '🥛',
  categorie: 'verre',
);

final conseilOrganique = ConseilRecyclage(
  id: 'conseil004',
  titre: 'Organique',
  description: 'Compostez les épluchures pour fertiliser vos plantes.',
  icone: '🌱',
  categorie: 'organique',
);

// Habitudes de tri
final habitudeKonepichor = HabitudeTri(
  id: 'habitude001',
  utilisateur: utilisateurExemple,
  frequence: 3,
  derniereActivite: DateTime(2026, 1, 22),
  scoreEcologique: 85,
);

final habitudeAmina = HabitudeTri(
  id: 'habitude002',
  utilisateur: utilisateurAmina,
  frequence: 2,
  derniereActivite: DateTime(2026, 1, 21),
  scoreEcologique: 70,
);

final habitudeYves = HabitudeTri(
  id: 'habitude003',
  utilisateur: utilisateurYves,
  frequence: 4,
  derniereActivite: DateTime(2026, 1, 22),
  scoreEcologique: 95,
);

final habitudeFatou = HabitudeTri(
  id: 'habitude004',
  utilisateur: utilisateurFatou,
  frequence: 1,
  derniereActivite: DateTime(2026, 1, 19),
  scoreEcologique: 60,
);

// Listes de test
final List<PointCollecte> pointsCollecteTest = [
  pointPlateau,
  pointBouake,
  pointYamoussoukro,
  pointSanPedro,
];

final List<Utilisateur> utilisateursTest = [
  utilisateurExemple,
  utilisateurAmina,
  utilisateurYves,
  utilisateurFatou,
];

// Liste de conseils de recyclage
final List<ConseilRecyclage> conseilsTest = [
  conseilPlastique,
  conseilPapier,
  conseilVerre,
  conseilOrganique,
];
