// lib/page_accueil.dart
import 'package:flutter/material.dart';
import 'ajout_redacteur_page.dart'; // Import pour la navigation
import 'redacteur_info_page.dart'; // Import pour la navigation

/// Page d'accueil de l'application.
class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Magazine Infos')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Magazine Infos',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Ajouter un Rédacteur'),
              onTap: () {
                Navigator.of(context).pop(); // Ferme le drawer
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AjoutRedacteurPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Informations des Rédacteurs'),
              onTap: () {
                Navigator.of(context).pop(); // Ferme le drawer
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const RedacteurInfoPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenue sur Magazine Infos !',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Utilisez le menu pour gérer les rédacteurs.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
