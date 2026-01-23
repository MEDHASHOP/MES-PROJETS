class PointCollecte {
  final String id;
  final String nom;
  final List<String> typeDechetsAcceptes;
  final double latitude;
  final double longitude;
  final String horaires;
  final String ville;

  PointCollecte({
    required this.id,
    required this.nom,
    required this.typeDechetsAcceptes,
    required this.latitude,
    required this.longitude,
    required this.horaires,
    required this.ville,
  });
}