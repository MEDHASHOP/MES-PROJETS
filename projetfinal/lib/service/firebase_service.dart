import 'package:firebase_core/firebase_core.dart';
import 'package:logging/logging.dart';
import '../firebase_options.dart';

class FirebaseService {
  static final Logger _logger = Logger('FirebaseService');
  
  static bool _initialized = false;
  
  /// Initialise Firebase avec gestion d'erreur
  static Future<bool> initializeFirebase() async {
    if (_initialized) {
      _logger.info('Firebase déjà initialisé');
      return true;
    }

    try {
      _logger.info('Tentative d\'initialisation de Firebase...');
      
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      
      _initialized = true;
      _logger.info('Firebase initialisé avec succès');
      return true;
    } catch (e) {
      _logger.severe('Erreur lors de l\'initialisation de Firebase: $e');
      
      // Retourne false pour indiquer l'échec, mais ne fait pas planter l'application
      return false;
    }
  }
  
  /// Vérifie si Firebase est correctement initialisé
  static bool isInitialized() {
    return _initialized;
  }
  
  /// Réinitialise l'état d'initialisation (pour les tests éventuellement)
  static void resetInitialization() {
    _initialized = false;
  }
}