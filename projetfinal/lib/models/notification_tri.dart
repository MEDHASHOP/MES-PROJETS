import 'utilisateur.dart';

class NotificationTri {
  final String id;
  final String titre;
  final String message;
  final DateTime dateEnvoi;
  final Utilisateur utilisateur;

  NotificationTri({
    required this.id,
    required this.titre,
    required this.message,
    required this.dateEnvoi,
    required this.utilisateur,
  });
}