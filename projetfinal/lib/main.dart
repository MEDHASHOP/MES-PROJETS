import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';
import 'ecrans/index.dart';
import 'models/utilisateur.dart';
import 'providers/index.dart';
import 'service/firebase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuration du logger
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  // 🔑 Initialisation Firebase via le service
  await FirebaseService.initializeFirebase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider()
            ..initializeUser(utilisateur), // ⚠️ utilisateur par défaut (test)
        ),
      ],
      child: MaterialApp(
        title: 'DésDéchets',
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/home': (context) => const HomeScreen(),
          '/calendar': (context) => const CalendarScreen(),
          '/map': (context) => const MapScreen(),
          '/tips': (context) => const TipsScreen(),
          '/profile': (context) => Consumer<UserProvider>(
                builder: (context, userProvider, _) {
                  final user = userProvider.currentUser ?? utilisateur;
                  return ProfileScreen(utilisateur: user);
                },
              ),
          '/community': (context) => const CommunityScreen(),
        },
      ),
    );
  }
}
