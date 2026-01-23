import 'utilisateur.dart';

class HabitudeTri {
  final String id;
  final Utilisateur utilisateur;
  final int frequence; // collectes par semaine
  final DateTime derniereActivite;
  final int scoreEcologique;

  HabitudeTri({
    required this.id,
    required this.utilisateur,
    required this.frequence,
    required this.derniereActivite,
    required this.scoreEcologique,
  });
}