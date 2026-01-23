import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  // Onglets pour la section communauté
  int _selectedIndex = 0;

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
            const Text("Communauté"),
          ],
        ),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const ForumScreen(),
          const PhotoSharingScreen(),
          const NeighborhoodRankingScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: "Forum",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: "Photos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: "Classement",
          ),
        ],
      ),
    );
  }
}

// Écran du forum
class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final List<Map<String, String>> _discussions = [
    {'titre': 'Sujet 1', 'contenu': 'Astuces pour trier les déchets électroniques...', 'auteur': 'U1'},
    {'titre': 'Sujet 2', 'contenu': 'Comment réduire les déchets plastiques ?', 'auteur': 'U2'},
    {'titre': 'Sujet 3', 'contenu': 'Meilleures pratiques pour le recyclage du verre', 'auteur': 'U3'},
    {'titre': 'Sujet 4', 'contenu': 'Recyclage des piles usagées : comment procéder ?', 'auteur': 'U4'},
    {'titre': 'Sujet 5', 'contenu': 'Compostage à domicile : guide pratique', 'auteur': 'U5'},
    {'titre': 'Sujet 6', 'contenu': 'Initiatives locales de recyclage dans votre quartier', 'auteur': 'U6'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Discussions récentes",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _discussions.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(_discussions[index]['auteur']!),
                    ),
                    title: Text(_discussions[index]['titre']!),
                    subtitle: Text(_discussions[index]['contenu']!),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigation vers la discussion
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Écran de partage de photos
class PhotoSharingScreen extends StatefulWidget {
  const PhotoSharingScreen({super.key});

  @override
  State<PhotoSharingScreen> createState() => _PhotoSharingScreenState();
}

class _PhotoSharingScreenState extends State<PhotoSharingScreen> {
  final List<String> _photos = [
    'https://picsum.photos/200/200?random=1',
    'https://picsum.photos/200/200?random=2',
    'https://picsum.photos/200/200?random=3',
    'https://picsum.photos/200/200?random=4',
    'https://picsum.photos/200/200?random=5',
    'https://picsum.photos/200/200?random=6',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Photos récentes",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _photos.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _photos[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}

// Écran de classement par quartier
class NeighborhoodRankingScreen extends StatefulWidget {
  const NeighborhoodRankingScreen({super.key});

  @override
  State<NeighborhoodRankingScreen> createState() => _NeighborhoodRankingScreenState();
}

class _NeighborhoodRankingScreenState extends State<NeighborhoodRankingScreen> {
  final List<Map<String, dynamic>> _quartiers = [
    {'nom': 'Plateau', 'points': 1250},
    {'nom': 'Cocody', 'points': 1100},
    {'nom': 'Treichville', 'points': 950},
    {'nom': 'Adjame', 'points': 800},
    {'nom': 'Yopougon', 'points': 750},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Classement par quartier",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _quartiers.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: index == 0 ? Colors.amber :
                               index == 1 ? Colors.grey :
                               index == 2 ? Colors.brown :
                               Colors.blueGrey,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    title: Text(_quartiers[index]['nom']),
                    trailing: Text(
                      '${_quartiers[index]['points']} pts',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}