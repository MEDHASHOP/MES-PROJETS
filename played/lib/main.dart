// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import pour ProviderScope
import 'vue/ajout_joueur.dart'; // Import pour la navigation
import 'vue/gestion_presence.dart'; // Import pour la navigation vers la gestion
import 'widgets/liste_joueur.dart'; // Import pour afficher la liste
import 'providers/joueurs_provider.dart'; // Import du provider

void main() {
  runApp(
    // ProviderScope est nécessaire pour que Riverpod fonctionne
    ProviderScope(child: MonApplication()),
  );
}

/// Classe principale de l'application.
class MonApplication extends StatelessWidget {
  const MonApplication({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion d\'équipe de foot',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const EquipeInterface(), // Page d'accueil
    );
  }
}

/// Widget principal affichant la liste des joueurs et les boutons d'action.
class EquipeInterface extends ConsumerWidget {
  const EquipeInterface({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Surveille les changements du provider joueursProvider
    final joueurs = ref.watch(joueursProvider);

    return Scaffold(
      backgroundColor: Colors.blue.shade50, // Arrière-plan bleu clair
      appBar: AppBar(
        title: const Text('Mon Équipe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt), // Icône pour la gestion
            onPressed: () {
              // Navigue vers la page de gestion de présence et stats
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const GestionPresencePage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigue vers la page d'ajout de joueur
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AjoutJoueurPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListeJoueurs(joueurs: joueurs), // Affiche la liste
      ),
    );
  }
}
