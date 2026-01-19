// lib/ui/login_screen.dart
import 'package:flutter/material.dart';
import 'notes_list_screen.dart'; // ou 'package:votre_projet/ui/notes_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Simuler une authentification simple
  void _login() {
    if (_usernameController.text == 'medha' &&
        _passwordController.text == '64233127') {
      // Rediriger vers l'écran principal des notes
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NotesListScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nom d\'utilisateur ou mot de passe incorrect'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Connexion')), // Supprimé
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centre verticalement
          children: [
            // --- Ajout de l'image ---
            // Remplacez 'assets/images/logo_app.png' par le chemin de votre image
            // Assurez-vous d'avoir ajouté le chemin dans votre pubspec.yaml
            Image.asset(
              'assets/images/logo.png', // <--- CHANGEZ CE CHEMIN
              width: 150, // Ajustez la taille comme vous le souhaitez
              height: 150,
              fit: BoxFit.cover, // Ou BoxFit.contain selon votre préférence
            ),
            const SizedBox(
              height: 32,
            ), // Espacement entre l'image et le formulaire
            // --- Fin de l'ajout de l'image ---
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Nom d\'utilisateur',
                labelStyle: TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                labelStyle: TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 24),
            // --- Modification du bouton ---
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Changer la couleur de fond
                foregroundColor: Colors.white, // Changer la couleur du texte
                shape: RoundedRectangleBorder(
                  // Pour arrondir les coins
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ), // Rayon de l'arrondi
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ), // Ajuster le padding pour agrandir le bouton
              ),
              child: const Text(
                'Connexion',
                style: TextStyle(fontSize: 18), // Agrandir la taille du texte
              ),
            ),
            // --- Ajout du texte indicatif après le bouton ---
            const SizedBox(
              height: 16,
            ), // Espacement entre le bouton et le texte
            const Text(
              'Utilisateur: medha\nMot de passe: 64233127',
              style: TextStyle(
                fontSize: 20, // Taille de police plus petite
                color: Color.fromARGB(255, 22, 1, 255), // Couleur discrète
                // fontStyle: FontStyle.italic, // Optionnel : italique
              ),
              textAlign: TextAlign.center, // Centrer le texte
            ),
            // --- Fin de l'ajout du texte indicatif ---
          ],
        ),
      ),
    );
  }
}
