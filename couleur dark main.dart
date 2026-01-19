// lib/main.dart

class MonAppli extends StatelessWidget {
  const MonAppli({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Notes',
      debugShowCheckedModeBanner: false,

      // ============================================================
      // 1. THÈME CLAIR (LIGHT MODE)
      // ============================================================
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: maCouleurPrincipale,
          secondary: maCouleurSecondaire,
          surface: monFondEcran, // Correction effectuée ici (au lieu de background)
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: maCouleurPrincipale,
          foregroundColor: Colors.white,
        ),
      ),

      // ============================================================
      // 2. THÈME SOMBRE (DARK MODE)
      // ============================================================
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: maCouleurPrincipale,
          secondary: maCouleurSecondaire,
          brightness: Brightness.dark, // Indique à Flutter d'utiliser des tons sombres
        ),
        // On peut personnaliser l'AppBar spécifiquement pour le mode sombre
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
        ),
      ),

      // ============================================================
      // 3. LOGIQUE DE SÉLECTION DU THÈME
      // ============================================================
      // ThemeMode.system : utilise le réglage du téléphone
      // ThemeMode.dark : force le mode sombre
      // ThemeMode.light : force le mode clair
      themeMode: ThemeMode.system, 

      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/add-note': (context) => const AddNoteScreen(),
      },
    );
  }
}