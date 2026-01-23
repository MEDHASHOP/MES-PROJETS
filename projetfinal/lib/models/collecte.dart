import 'point_collecte.dart';
import 'utilisateur.dart';

class Collecte {
  final String id;
  final DateTime date;
  final String typeDechets;
  final PointCollecte lieu;
  final Utilisateur utilisateur;

  Collecte({
    required this.id,
    required this.date,
    required this.typeDechets,
    required this.lieu,
    required this.utilisateur,
  });
}