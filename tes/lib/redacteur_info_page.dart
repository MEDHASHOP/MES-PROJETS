// lib/redacteur_info_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'supprimer_redacteur_page.dart'; // Import pour la navigation
import 'modifier_redacteur_page.dart'; // Import pour la navigation

/// Page affichant la liste des rédacteurs.
class RedacteurInfoPage extends StatelessWidget {
  const RedacteurInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore =
        FirebaseFirestore.instance; // Instance de Firestore

    return Scaffold(
      appBar: AppBar(title: const Text('Informations des Rédacteurs')),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('redacteurs')
            .snapshots(), // Écoute les changements en temps réel
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Aucun rédacteur trouvé.'));
          }

          final redacteurs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: redacteurs.length,
            itemBuilder: (context, index) {
              final redacteur = redacteurs[index];
              final redacteurId = redacteur.id; // Récupère l'ID du document
              final redacteurData =
                  redacteur.data()
                      as Map<String, dynamic>; // Récupère les données

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(redacteurData['nom'] ?? 'Nom inconnu'),
                  subtitle: Text(
                    redacteurData['specialite'] ?? 'Spécialité inconnue',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Navigue vers la page de modification
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ModifierRedacteurPage(
                                redacteurId: redacteurId,
                                redacteurData: redacteurData,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Navigue vers la page de suppression
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SupprimerRedacteurPage(
                                redacteurId: redacteurId,
                                nomRedacteur: redacteurData['nom'],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
