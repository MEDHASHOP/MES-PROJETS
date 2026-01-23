import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            const Text('Accueil'),
          ],
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          final menuItem = _menuItems[index];
          return _MenuItemCard(
            title: menuItem.title,
            icon: menuItem.icon,
            onTap: () => Navigator.pushNamed(context, menuItem.route),
          );
        },
      ),
    );
  }

  // Liste des éléments de menu pour la grille
  static const List<_MenuItem> _menuItems = [
    _MenuItem(title: 'Calendrier', route: '/calendar', icon: Icons.calendar_today),
    _MenuItem(title: 'Carte', route: '/map', icon: Icons.location_on),
    _MenuItem(title: 'Conseils', route: '/tips', icon: Icons.lightbulb),
    _MenuItem(title: 'Profil', route: '/profile', icon: Icons.person),
    _MenuItem(title: 'Communauté', route: '/community', icon: Icons.people),
  ];
}

/// Représente un élément de menu dans la grille
class _MenuItem {
  const _MenuItem({
    required this.title,
    required this.route,
    required this.icon,
  });

  final String title;
  final String route;
  final IconData icon;
}

/// Carte pour un élément de menu
class _MenuItemCard extends StatelessWidget {
  const _MenuItemCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.green),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
