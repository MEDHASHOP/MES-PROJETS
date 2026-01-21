import 'package:flutter/material.dart';

void main() {
  runApp(const MonApplication());
}

// Classe corrigée : ajout des propriétés 'nom' et 'moyenne' avec accès final
// et constructeur const pour optimiser la performance
class Etudiant {
  final String nom;
  final double moyenne;
  const Etudiant({required this.nom, required this.moyenne});
}

// Correction : ajout du widget 'const' et des routes de navigation
class MonApplication extends StatelessWidget {
  const MonApplication({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Définition de la page d'accueil
      home: PageAccueil(),
      // Correction : ajout de la route '/details' pour naviguer vers la page de détails
      routes: {'/details': (context) => DetailPage()},
    );
  }
}

class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});
  static const List<Etudiant> etudiants = [
    Etudiant(nom: 'Alice', moyenne: 17.25),
    Etudiant(nom: 'Bob', moyenne: 16.5),
    Etudiant(nom: 'Charlie', moyenne: 11.75),
    Etudiant(nom: 'David', moyenne: 12.75),
    Etudiant(nom: 'Eve', moyenne: 13.5),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Liste des étudiants')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Liste des étudiants et de leurs moyennes :',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: PageAccueil.etudiants.length,
                itemBuilder: (context, index) {
                  final etudiant = etudiants[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text('Nom: ${etudiant.nom}'),
                      subtitle: Text('Moyenne : ${etudiant.moyenne}'),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/details',
                          arguments: etudiant,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              child: Text('Calculer la moyenne de la classe'),
              onPressed: () {
                final average = calculateMoyenne(etudiants);
                moyenneAlertDialog(context, average); // Afficher l'alerte
              },
            ),
          ],
        ),
      ),
    );
  }

  // Correction : méthode pour calculer la moyenne arithmétique de la classe
  double calculateMoyenne(List<Etudiant> etudiants) {
    double total = 0.0;
    // Itération sur chaque étudiant pour accumuler les moyennes
    for (var etudiant in etudiants) {
      total += etudiant.moyenne;
    }
    // Division par le nombre d'étudiants pour obtenir la moyenne
    return total / etudiants.length;
  }

  // Correction : boîte de dialogue pour afficher la moyenne calculée
  void moyenneAlertDialog(BuildContext context, double average) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Titre de la boîte de dialogue
          title: const Text('Moyenne des étudiants'),
          // Contenu affichant la moyenne calculée
          content: Text('La moyenne des étudiants est : $average'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

// Correction : page de détails pour afficher les informations complètes d'un étudiant
class DetailPage extends StatelessWidget {
  const DetailPage({super.key});
  @override
  Widget build(BuildContext context) {
    // Récupération de l'étudiant transmis via les arguments de navigation
    final etudiant = ModalRoute.of(context)!.settings.arguments as Etudiant;
    return Scaffold(
      appBar: AppBar(title: Text('Détails de l\'étudiant')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Nom de l\'étudiant : ${etudiant.nom}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Moyenne : ${etudiant.moyenne}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
