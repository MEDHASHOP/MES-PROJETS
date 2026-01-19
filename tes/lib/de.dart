import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart'; // Assurez-vous que ce fichier existe

// Importez vos écrans
import 'screens/connexion.dart';
import 'screens/acceuil.dart';
import 'screens/ecrire.dart';

// ============================================================
// ZONE DE CONFIGURATION DES COULEURS GLOBALES
// ============================================================
// Changez ces codes couleurs pour modifier toute l'application.
// Utilisez des valeurs hexadécimales (0xFF + le code couleur).
const Color maCouleurPrincipale = Color(0xFF6200EE); // Violet foncé
const Color maCouleurSecondaire = Color(0xFF03DAC6); // Cyan/Turquoise
const Color monFondEcran = Color(0xFFF2F2F2); // Gris très clair
const Color couleurTexteAppbar = Colors.white;
// ============================================================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialisation de Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Erreur d'initialisation Firebase ou déjà initialisé : $e");
  }

  runApp(const ProviderScope(child: MonAppli()));
}

class MonAppli extends StatelessWidget {
  const MonAppli({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Notes',
      debugShowCheckedModeBanner: false,

      // ============================================================
      // CONFIGURATION DU THÈME GLOBAL
      // ============================================================
      theme: ThemeData(
        useMaterial3: true,
        // On définit le schéma de couleurs à partir de nos variables
        colorScheme: ColorScheme.fromSeed(
          seedColor: maCouleurPrincipale,
          secondary: maCouleurSecondaire,
          background: monFondEcran,
          // Vous pouvez forcer le mode sombre ici si besoin : brightness: Brightness.dark,
        ),

        // Personnalisation spécifique de la barre d'application (AppBar)
        appBarTheme: const AppBarTheme(
          backgroundColor: maCouleurPrincipale,
          foregroundColor: couleurTexteAppbar, // Couleur du titre et des icônes
          elevation: 4, // Une petite ombre sous la barre
          centerTitle: true,
        ),

        // Personnalisation des boutons surélevés (ElevatedButton)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: maCouleurPrincipale, // Fond du bouton
            foregroundColor: Colors.white, // Texte du bouton
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Boutons arrondis
            ),
          ),
        ),

        // Personnalisation des boutons flottants (FloatingActionButton)
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: maCouleurSecondaire,
          foregroundColor: Colors.black,
        ),

        // Personnalisation de la couleur de fond générale
        scaffoldBackgroundColor: monFondEcran,
      ),
      // ============================================================

      // Écran de départ
      home: const LoginScreen(),

      // Routes de navigation
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/add-note': (context) => const AddNoteScreen(),
      },
    );
  }
}
