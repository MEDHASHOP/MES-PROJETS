import 'package:flutter/material.dart';
import 'recycling_tips_screen.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Rediriger vers le nouvel écran de conseils de recyclage
    return const RecyclingTipsScreen();
  }
}
