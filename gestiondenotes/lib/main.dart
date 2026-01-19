// lib/main.dart
import 'package:flutter/material.dart';
import 'ui/login_screen.dart'; // ← Importez l'écran de connexion

void main() {
  runApp(const MonAppli());
}

class MonAppli extends StatelessWidget {
  const MonAppli({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des Notes',
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(), // ← Démarrer avec l'écran de connexion
      theme: ThemeData(
        // Définir le thème global
        scaffoldBackgroundColor: const Color.fromARGB(
          255,
          255,
          255,
          255,
        ), // Fond pour tous les Scaffold
      ),
    );
  }
}
