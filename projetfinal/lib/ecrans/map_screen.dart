import 'package:flutter/material.dart';
import 'collection_points_screen.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Rediriger vers le nouvel écran des points de collecte
    return const CollectionPointsScreen();
  }
}
