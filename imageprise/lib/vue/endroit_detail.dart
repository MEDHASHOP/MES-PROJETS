// lib/vue/endroit_detail.dart (VERSION CORRECTE)
import 'package:flutter/material.dart';
import '../modele/endroit.dart'; // Import de la classe Endroit

/// Widget Stateless affichant les détails d'un objet [Endroit].
class EndroitDetail extends StatelessWidget {
  // Le constructeur doit attendre un objet Endroit
  final Endroit endroit;

  const EndroitDetail({super.key, required this.endroit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          endroit.nom,
        ), // Accède à la propriété 'nom' de l'objet Endroit
      ),
      body: Center(
        child: Text(
          'Détails de l\'endroit : ${endroit.nom}',
        ), // Accède à la propriété 'nom' de l'objet Endroit
      ),
    );
  }
}
