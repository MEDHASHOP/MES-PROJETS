// vue/gestion_presence.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/liste_joueur.dart'; // Import pour afficher la liste
import '../providers/joueurs_provider.dart'; // Import du provider

/// Widget basé sur Riverpod pour gérer la présence et les stats des joueurs.
class GestionPresencePage extends ConsumerWidget {
  const GestionPresencePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Surveille les changements du provider joueursProvider
    final joueurs = ref.watch(joueursProvider);

    return Scaffold(
      backgroundColor: Colors.blue.shade50, // Arrière-plan bleu clair
      appBar: AppBar(title: const Text('Gestion Présence & Stats')),
      body: ListeJoueurs(
        joueurs: joueurs,
        onPresenceChange: (joueur) =>
            ref.read(joueursProvider.notifier).mettreAJourJoueur(joueur),
        onButIncrement: (joueur) =>
            ref.read(joueursProvider.notifier).mettreAJourJoueur(joueur),
        onPhotoChange: (joueur) =>
            ref.read(joueursProvider.notifier).mettreAJourJoueur(joueur),
      ), // Affiche la liste avec les widgets interactifs
    );
  }
}
