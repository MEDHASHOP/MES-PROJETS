import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: "AIzaSyDTZ5luzZEqQ0ptiIBLlQpnjCiWwZBhWHo",
        appId: "1:708204346606:web:4cafb192b795feb3aa87ff",
        messagingSenderId: "708204346606",
        projectId: "projetfinal-62327",
        authDomain: "projetfinal-62327.firebaseapp.com",
        storageBucket: "projetfinal-62327.firebasestorage.app",
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: "AIzaSyDTZ5luzZEqQ0ptiIBLlQpnjCiWwZBhWHo",
          appId: "1:708204346606:android:4cafb192b795feb3aa87ff",
          messagingSenderId: "708204346606",
          projectId: "projetfinal-62327",
          storageBucket: "projetfinal-62327.firebasestorage.app",
        );
      case TargetPlatform.iOS:
        return const FirebaseOptions(
          apiKey: "AIzaSyDTZ5luzZEqQ0ptiIBLlQpnjCiWwZBhWHo",
          appId: "1:708204346606:ios:4cafb192b795feb3aa87ff",
          messagingSenderId: "708204346606",
          projectId: "projetfinal-62327",
          storageBucket: "projetfinal-62327.firebasestorage.app",
          iosClientId: "708204346606-abc123def456.apps.googleusercontent.com",
          iosBundleId: "com.example.projetfinal",
        );
      case TargetPlatform.macOS:
        return const FirebaseOptions(
          apiKey: "AIzaSyDTZ5luzZEqQ0ptiIBLlQpnjCiWwZBhWHo",
          appId: "1:708204346606:ios:4cafb192b795feb3aa87ff",
          messagingSenderId: "708204346606",
          projectId: "projetfinal-62327",
          storageBucket: "projetfinal-62327.firebasestorage.app",
          iosClientId: "708204346606-abc123def456.apps.googleusercontent.com",
          iosBundleId: "com.example.projetfinal",
        );
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      default:
        return const FirebaseOptions(
          apiKey: "AIzaSyDTZ5luzZEqQ0ptiIBLlQpnjCiWwZBhWHo",
          appId: "1:708204346606:android:4cafb192b795feb3aa87ff",
          messagingSenderId: "708204346606",
          projectId: "projetfinal-62327",
          storageBucket: "projetfinal-62327.firebasestorage.app",
        );
    }
  }
}