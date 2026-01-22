import 'package:flutter/material.dart';
import '../theme/index.dart';
import '../models/index.dart';

/// Écran des conseils de recyclage avec grille d'images
class TipsScreenWidget extends StatefulWidget {
  const TipsScreenWidget({super.key});

  @override
  State<TipsScreenWidget> createState() => _TipsScreenWidgetState();
}

class _TipsScreenWidgetState extends State<TipsScreenWidget> {
  late PageController _pageController;
  int _currentPage = 0;

  // Données d'exemple pour les conseils
  final List<RecyclingTip> _tips = [
    RecyclingTip(
      id: '1',
      title: 'Trier le plastique correctement',
      description: 'Apprenez à identifier et trier les différents types de plastique',
      category: 'Plastique',
      difficulty: 1,
      rating: 4.5,
      viewCount: 1250,
      imageUrl: 'assets/images/logo.svg',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    RecyclingTip(
      id: '2',
      title: 'Recycler le papier et carton',
      description: 'Guide complet pour recycler efficacement papier et carton',
      category: 'Papier',
      difficulty: 1,
      rating: 4.8,
      viewCount: 980,
      imageUrl: 'assets/images/logo.svg',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    RecyclingTip(
      id: '3',
      title: 'Gérer les déchets électroniques',
      description: 'Conseils pour recycler vos appareils électroniques',
      category: 'Électronique',
      difficulty: 2,
      rating: 4.3,
      viewCount: 750,
      imageUrl: 'assets/images/logo.svg',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    RecyclingTip(
      id: '4',
      title: 'Composter les déchets organiques',
      description: 'Créez votre propre compost à la maison',
      category: 'Organique',
      difficulty: 2,
      rating: 4.6,
      viewCount: 1100,
      imageUrl: 'assets/images/logo.svg',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conseils de Recyclage'),
        elevation: 0,
        backgroundColor: AppColors.primaryGreen,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec icône
            _buildHeader(),
            const SizedBox(height: 24),

            // Carrousel de conseils en vedette
            _buildFeaturedTipsCarousel(),
            const SizedBox(height: 32),

            // Grille de conseils
            _buildTipsGrid(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Construire l'en-tête avec icône
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.ecoGradient,
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAnimations.scaleAnimation(
                child: AppIcons.styledRecycleIcon(
                  size: 56,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Apprenez à Recycler',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_tips.length} conseils pratiques',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construire le carrousel de conseils en vedette
  Widget _buildFeaturedTipsCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Conseils en vedette',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: _tips.length,
            itemBuilder: (context, index) {
              return AppAnimations.slideInFromBottom(
                duration: Duration(milliseconds: 400 + (index * 100)),
                child: _buildTipCard(_tips[index], index),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Indicateurs de page
        _buildPageIndicators(),
      ],
    );
  }

  /// Construire les indicateurs de page
  Widget _buildPageIndicators() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _tips.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _currentPage == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: _currentPage == index
                  ? AppColors.accentOrange
                  : AppColors.lightGrey,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  /// Construire une carte de conseil
  Widget _buildTipCard(RecyclingTip tip, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: AppAnimations.heroCard(
        tag: 'tip_${tip.id}',
        onTap: () => _showTipDetail(tip),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: index % 2 == 0
                  ? AppColors.ecoGradient
                  : AppColors.orangeGradient,
            ),
            child: Stack(
              children: [
                // Contenu
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tip.category,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            tip.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tip.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.white.withValues(alpha: 0.9),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      // Statistiques
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatItem(
                            icon: Icons.visibility,
                            value: '${tip.viewCount}',
                            label: 'vues',
                          ),
                          _buildStatItem(
                            icon: Icons.star,
                            value: '${tip.rating}',
                            label: '/5',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Bouton d'action
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: AppColors.white,
                    onPressed: () => _showTipDetail(tip),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: AppColors.primaryGreen,
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

  /// Construire un élément de statistique
  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.white),
        const SizedBox(width: 4),
        Text(
          '$value $label',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Construire la grille de conseils
  Widget _buildTipsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tous les conseils',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: _tips.length,
            itemBuilder: (context, index) {
              return AppAnimations.fadeInAnimation(
                duration: Duration(milliseconds: 300 + (index * 100)),
                child: _buildGridTipCard(_tips[index]),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Construire une carte de conseil pour la grille
  Widget _buildGridTipCard(RecyclingTip tip) {
    return GestureDetector(
      onTap: () => _showTipDetail(tip),
      child: AppAnimations.heroCard(
        tag: 'grid_tip_${tip.id}',
        onTap: () => _showTipDetail(tip),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: AppColors.ecoGradient,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tip.category,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tip.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: AppColors.white,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${tip.rating}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Afficher les détails d'un conseil
  void _showTipDetail(RecyclingTip tip) {
    Navigator.of(context).push(
      AppAnimations.createHeroTransition(
        page: TipDetailScreen(tip: tip),
        routeName: '/tip_detail',
      ),
    );
  }
}

/// Écran de détail d'un conseil
class TipDetailScreen extends StatelessWidget {
  final RecyclingTip tip;

  const TipDetailScreen({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar personnalisée avec Hero
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primaryGreen,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(tip.title),
              background: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.ecoGradient,
                ),
                child: Center(
                  child: AppAnimations.rotationAnimation(
                    child: AppIcons.leafIcon(
                      size: 120,
                      color: AppColors.white.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Contenu
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Catégorie et note
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreen.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.lightGreen,
                          ),
                        ),
                        child: Text(
                          tip.category,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.accentOrange),
                          const SizedBox(width: 4),
                          Text(
                            '${tip.rating}/5',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Description
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tip.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  // Bouton d'action
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Conseil "${tip.title}" sauvegardé!'),
                            backgroundColor: AppColors.successGreen,
                          ),
                        );
                      },
                      icon: const Icon(Icons.bookmark),
                      label: const Text('Sauvegarder ce conseil'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
