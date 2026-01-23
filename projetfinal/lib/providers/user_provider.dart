import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/utilisateur.dart';
import '../service/firebase_service.dart';

class UserProvider with ChangeNotifier {
  Utilisateur? _currentUser;
  bool _isLoading = false;

  Utilisateur? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  List<Utilisateur> _allUsers = [];
  List<Utilisateur> get allUsers => _allUsers;

  // Initialiser l'utilisateur
  void initializeUser(Utilisateur utilisateur) {
    try {
      _currentUser = utilisateur;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors de l\'initialisation de l\'utilisateur: $e');
    }
  }

  // Mettre à jour les informations de l'utilisateur
  Future<void> updateUser({
    String? nomUtilisateur,
    String? email,
    String? ville,
    String? pays,
  }) async {
    if (_currentUser == null || !FirebaseService.isInitialized()) return;

    _isLoading = true;
    notifyListeners();

    try {
      final docRef = FirebaseFirestore.instance
          .collection('utilisateurs')
          .doc(_currentUser!.id);

      await docRef.update({
        if (nomUtilisateur != null) 'nomUtilisateur': nomUtilisateur,
        if (email != null) 'email': email,
        if (ville != null) 'ville': ville,
        if (pays != null) 'pays': pays,
      });

      _currentUser = _currentUser!.copyWith(
        nomUtilisateur: nomUtilisateur,
        email: email,
        ville: ville,
        pays: pays,
      );

      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour de l\'utilisateur: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mettre à jour l'image de profil
  Future<void> updateProfilePicture(File imageFile) async {
    if (_currentUser == null || !FirebaseService.isInitialized()) return;

    _isLoading = true;
    notifyListeners();

    try {
      String fileName =
          'profil_images/${_currentUser!.id}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference reference = FirebaseStorage.instance.ref().child(fileName);

      UploadTask uploadTask = reference.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('utilisateurs')
          .doc(_currentUser!.id)
          .update({'avatarUrl': downloadUrl});

      _currentUser = _currentUser!.copyWith(avatarUrl: downloadUrl);

      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour de l\'image de profil: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Charger les données de l'utilisateur depuis Firestore
  Future<void> loadUserData(String userId) async {
    if (!FirebaseService.isInitialized()) {
      debugPrint('Firebase n\'est pas initialisé. Impossible de charger les données utilisateur.');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('utilisateurs')
          .doc(userId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        _currentUser = Utilisateur.fromMap(data, doc.id);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors du chargement des données utilisateur: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Charger tous les utilisateurs depuis Firestore
  Future<void> loadAllUsers() async {
    if (!FirebaseService.isInitialized()) {
      debugPrint('Firebase n\'est pas initialisé. Impossible de charger les utilisateurs.');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('utilisateurs').get();

      _allUsers = snapshot.docs.map((doc) {
        return Utilisateur.fromMap(doc.data(), doc.id);
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors du chargement de tous les utilisateurs: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mettre à jour toutes les données de l'utilisateur sur Firebase
  Future<void> updateUserData(Utilisateur utilisateur) async {
    if (!FirebaseService.isInitialized()) {
      debugPrint('Firebase n\'est pas initialisé. Impossible de mettre à jour les données utilisateur.');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final docRef = FirebaseFirestore.instance
          .collection('utilisateurs')
          .doc(utilisateur.id);

      await docRef.set(utilisateur.toMap());

      _currentUser = utilisateur;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour des données utilisateur: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
