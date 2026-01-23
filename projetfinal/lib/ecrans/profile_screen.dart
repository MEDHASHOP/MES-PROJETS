import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math' as math;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/utilisateur.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  final Utilisateur utilisateur;

  const ProfileScreen({super.key, required this.utilisateur});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Utilisateur _utilisateur;
  final _formKey = GlobalKey<FormState>();

  // Variables temporaires pour les champs de formulaire
  late String _nomUtilisateur;
  late String _email;
  late String _ville;
  late String _pays;
  late int _quantiteTriee;
  late String _nouveauBadge;
  late String _moisProgression;
  late int _valeurProgression;

  @override
  void initState() {
    super.initState();
    _utilisateur = widget.utilisateur;
    _nomUtilisateur = _utilisateur.nomUtilisateur;
    _email = _utilisateur.email;
    _ville = _utilisateur.ville;
    _pays = _utilisateur.pays;
    _quantiteTriee = _utilisateur.quantiteTriee;
    _nouveauBadge = '';
    _moisProgression = '';
    _valeurProgression = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            const Text("Profil"),
          ],
        ),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _refreshData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditDialog();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Section Avatar et infos personnelles
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _utilisateur.avatarUrl.isNotEmpty
                              ? _utilisateur.avatarUrl.startsWith('file://')
                                  ? FileImage(File(_utilisateur.avatarUrl.replaceFirst('file://', ''))) as ImageProvider
                                  : NetworkImage(_utilisateur.avatarUrl)
                              : null,
                          child: _utilisateur.avatarUrl.isEmpty
                              ? Image.asset(
                                  'assets/images/logo.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.contain,
                                )
                              : null,
                        ),
                        const SizedBox(height: 16),
                        // Nom d'utilisateur
                        Text(
                          _utilisateur.nomUtilisateur,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Email
                        Text(
                          _utilisateur.email,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Ville et pays
                        Text(
                          "${_utilisateur.ville}, ${_utilisateur.pays}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Section Statistiques de recyclage
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Statistiques de recyclage",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.eco, color: Colors.green),
                          title: const Text("Quantité triée"),
                          trailing: Text(
                            "${_utilisateur.quantiteTriee} kg",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Divider(),
                        // Affichage de la répartition des déchets
                        if (_utilisateur.repartitionDechets.isNotEmpty)
                          ..._utilisateur.repartitionDechets.entries.map((entry) {
                            return ListTile(
                              leading: getIconForWasteType(entry.key),
                              title: Text(entry.key),
                              trailing: Text(
                                "${entry.value} kg",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }),
                        if (_utilisateur.repartitionDechets.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "Aucune donnée de tri disponible",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          ),

                        const SizedBox(height: 16),

                        // Section progression mensuelle
                        const Text(
                          "Progression mensuelle",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_utilisateur.progressionMensuelle.isNotEmpty)
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _utilisateur.progressionMensuelle.length,
                              itemBuilder: (context, index) {
                                var entry = _utilisateur.progressionMensuelle.entries.elementAt(index);
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.green[100],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            // Barre de progression
                                            Container(
                                              width: 40,
                                              height: (entry.value / _utilisateur.progressionMensuelle.values.reduce((a, b) => math.max(a, b)).toDouble()) * 120,
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            // Quantité en kg
                                            Text(
                                              "${entry.value}kg",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Mois
                                      RotatedBox(
                                        quarterTurns: 3,
                                        child: Text(
                                          entry.key,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        else
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "Aucune donnée de progression mensuelle",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Section Badges
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Badges",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_utilisateur.badges.isNotEmpty)
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: _utilisateur.badges.map((badge) {
                              return BadgeItem(badgeName: badge);
                            }).toList(),
                          )
                        else
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "Aucun badge obtenu",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          ),

                        const SizedBox(height: 20),

                        // Section Historique des badges
                        const Text(
                          "Historique des badges obtenus",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_utilisateur.historiqueBadges.isNotEmpty)
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _utilisateur.historiqueBadges.length,
                            separatorBuilder: (context, index) => const Divider(),
                            itemBuilder: (context, index) {
                              final badge = _utilisateur.historiqueBadges[index];
                              return ListTile(
                                leading: const Icon(Icons.star, color: Colors.amber),
                                title: Text(badge.nom),
                                subtitle: Text(badge.description),
                                trailing: Text(
                                  '${badge.dateObtention.day}/${badge.dateObtention.month}/${badge.dateObtention.year}',
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          )
                        else
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "Aucun historique de badges",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Méthode pour rafraîchir les données utilisateur
  Future<void> _refreshData() async {
    try {
      final BuildContext contextCopy = context;
      UserProvider userProvider = Provider.of<UserProvider>(contextCopy, listen: false);
      await userProvider.loadUserData(_utilisateur.id);

      if (mounted) {
        setState(() {
          _utilisateur = userProvider.currentUser ?? _utilisateur;
        });
      }
    } catch (e) {
      debugPrint('Erreur lors du rafraîchissement des données: $e');
    }
  }

  // Fonction pour afficher le dialogue d'édition
  void _showEditDialog() {
    final BuildContext dialogContext = context;

    showDialog(
      context: dialogContext,
      builder: (BuildContext builderContext) {
        return AlertDialog(
          title: const Text("Modifier le profil"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Bouton pour sélectionner un avatar
                  ElevatedButton.icon(
                    onPressed: () => _selectAvatar(context),
                    icon: const Icon(Icons.photo_camera),
                    label: const Text("Sélectionner un avatar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _utilisateur.nomUtilisateur,
                    decoration: const InputDecoration(labelText: "Nom d'utilisateur"),
                    onChanged: (value) => _nomUtilisateur = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer un nom d'utilisateur";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _utilisateur.email,
                    decoration: const InputDecoration(labelText: "Email"),
                    onChanged: (value) => _email = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer un email";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _utilisateur.ville,
                    decoration: const InputDecoration(labelText: "Ville"),
                    onChanged: (value) => _ville = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer une ville";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _utilisateur.pays,
                    decoration: const InputDecoration(labelText: "Pays"),
                    onChanged: (value) => _pays = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer un pays";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _utilisateur.quantiteTriee.toString(),
                    decoration: const InputDecoration(labelText: "Quantité triée (kg)"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      int? newValue = int.tryParse(value);
                      if (newValue != null) {
                        _quantiteTriee = newValue;
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer une quantité";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Ajouter une progression mensuelle",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Mois (ex: Janvier 2024)"),
                    onChanged: (value) => _moisProgression = value,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Quantité (kg)"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      int? newValue = int.tryParse(value);
                      if (newValue != null) {
                        _valeurProgression = newValue;
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Ajouter un badge",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Nom du badge"),
                    onChanged: (value) => _nouveauBadge = value,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (builderContext.mounted) {
                  Navigator.of(builderContext).pop();
                }
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Mettre à jour l'utilisateur avec les nouvelles valeurs
                  Utilisateur utilisateurMisAJour = _utilisateur.copyWith(
                    nomUtilisateur: _nomUtilisateur,
                    email: _email,
                    ville: _ville,
                    pays: _pays,
                    quantiteTriee: _quantiteTriee,
                  );

                  // Ajouter la progression mensuelle si les champs sont remplis
                  if (_moisProgression.isNotEmpty && _valeurProgression > 0) {
                    Map<String, int> nouvelleProgression = Map.from(utilisateurMisAJour.progressionMensuelle);
                    nouvelleProgression[_moisProgression] = _valeurProgression;
                    utilisateurMisAJour = utilisateurMisAJour.copyWith(progressionMensuelle: nouvelleProgression);
                  }

                  // Ajouter le badge si le champ est rempli
                  if (_nouveauBadge.isNotEmpty) {
                    List<String> nouveauxBadges = List.from(utilisateurMisAJour.badges);
                    nouveauxBadges.add(_nouveauBadge);
                    utilisateurMisAJour = utilisateurMisAJour.copyWith(badges: nouveauxBadges);

                    // Ajouter aussi à l'historique des badges
                    List<BadgeObtenu> nouvelHistorique = List.from(utilisateurMisAJour.historiqueBadges);
                    nouvelHistorique.add(BadgeObtenu(
                      nom: _nouveauBadge,
                      description: "Nouveau badge obtenu",
                      dateObtention: DateTime.now(),
                    ));
                    utilisateurMisAJour = utilisateurMisAJour.copyWith(historiqueBadges: nouvelHistorique);
                  }

                  // Sauvegarder les modifications sur Firebase via le provider
                  UserProvider userProvider = Provider.of<UserProvider>(dialogContext, listen: false);
                  await userProvider.updateUserData(utilisateurMisAJour);

                  // Mettre à jour l'état local après la sauvegarde réussie
                  setState(() {
                    _utilisateur = utilisateurMisAJour;
                  });

                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                }
              },
              child: const Text("Enregistrer"),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour sélectionner un avatar via ImagePicker
  Future<void> _selectAvatar(BuildContext ctx) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      try {
        // Mettre à jour l'interface utilisateur immédiatement avec l'image locale
        setState(() {
          _utilisateur = _utilisateur.copyWith(
            avatarUrl: 'file://${image.path}', // Utilisation d'un chemin de fichier local temporaire
          );
        });

        // Télécharger l'image vers Firebase Storage
        UserProvider userProvider = Provider.of<UserProvider>(ctx, listen: false);
        await userProvider.updateProfilePicture(File(image.path));

        // Recharger les données utilisateur pour obtenir l'URL mise à jour
        await userProvider.loadUserData(_utilisateur.id);

        // Mettre à jour l'état local avec les données fraîches
        if (mounted) {
          setState(() {
            _utilisateur = userProvider.currentUser ?? _utilisateur;
          });
        }
      } catch (e) {
        debugPrint('Erreur lors de la mise à jour de l\'avatar: $e');
        // Rétablir l'ancien avatar en cas d'erreur
        if (mounted) {
          setState(() {
            _utilisateur = widget.utilisateur;
          });
        }
      }
    }
  }

  // Fonction utilitaire pour obtenir une icône en fonction du type de déchet
  Widget getIconForWasteType(String wasteType) {
    switch (wasteType.toLowerCase()) {
      case 'plastique':
        return const Icon(Icons.local_drink, color: Colors.blue);
      case 'papier':
        return const Icon(Icons.description, color: Colors.yellow);
      case 'verre':
        return const Icon(Icons.bubble_chart, color: Colors.green);
      case 'métal':
        return const Icon(Icons.castle, color: Colors.grey);
      default:
        return const Icon(Icons.category, color: Colors.orange);
    }
  }
}

// Widget pour afficher un badge individuel
class BadgeItem extends StatelessWidget {
  final String badgeName;

  const BadgeItem({super.key, required this.badgeName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amber[300],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber[600]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 16, color: Colors.amber[700]),
          const SizedBox(width: 4),
          Text(
            badgeName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.amber[800],
            ),
          ),
        ],
      ),
    );
  }

  // Fonction utilitaire pour obtenir une icône en fonction du type de déchet
  Widget getIconForWasteType(String wasteType) {
    switch (wasteType.toLowerCase()) {
      case 'plastique':
        return const Icon(Icons.local_drink, color: Colors.blue);
      case 'papier':
        return const Icon(Icons.description, color: Colors.yellow);
      case 'verre':
        return const Icon(Icons.bubble_chart, color: Colors.green);
      case 'métal':
        return const Icon(Icons.castle, color: Colors.grey);
      default:
        return const Icon(Icons.category, color: Colors.orange);
    }
  }
}
