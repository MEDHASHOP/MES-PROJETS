import 'package:flutter/material.dart';

/// Classe pour gérer les animations Hero et les transitions
class AppAnimations {
  /// Transition avec animation Hero pour les images
  static Widget heroImage({
    required String tag,
    required String imagePath,
    required VoidCallback onTap,
    double width = 200,
    double height = 200,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(16)),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: tag,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  /// Transition avec animation Hero pour les icônes
  static Widget heroIcon({
    required String tag,
    required Widget icon,
    required VoidCallback onTap,
    double size = 60,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: tag,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: icon,
        ),
      ),
    );
  }

  /// Transition avec animation Hero pour les cartes
  static Widget heroCard({
    required String tag,
    required Widget child,
    required VoidCallback onTap,
    double borderRadius = 16,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: tag,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  /// Animation de fade-in
  static Widget fadeInAnimation({
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeIn,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// Animation de slide-in depuis le bas
  static Widget slideInFromBottom({
    required Widget child,
    Duration duration = const Duration(milliseconds: 600),
    Curve curve = Curves.easeOut,
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: const Offset(0, 0.3), end: Offset.zero),
      duration: duration,
      curve: curve,
      builder: (context, offset, child) {
        return Transform.translate(
          offset: offset * 100,
          child: Opacity(
            opacity: 1 - (offset.dy * 0.3).abs(),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// Animation de scale (zoom)
  static Widget scaleAnimation({
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.elasticOut,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// Animation de rotation
  static Widget rotationAnimation({
    required Widget child,
    Duration duration = const Duration(seconds: 2),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: Curves.linear,
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value * 6.28,
          child: child,
        );
      },
      child: child,
    );
  }

  /// Transition personnalisée entre écrans
  static PageRoute<T> createHeroTransition<T>({
    required Widget page,
    required String routeName,
  }) {
    return PageRouteBuilder<T>(
      settings: RouteSettings(name: routeName),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  /// Transition avec fade et scale
  static PageRoute<T> createFadeScaleTransition<T>({
    required Widget page,
    required String routeName,
  }) {
    return PageRouteBuilder<T>(
      settings: RouteSettings(name: routeName),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}

/// Widget pour afficher une grille d'images avec animations
class AnimatedImageGrid extends StatelessWidget {
  final List<String> imagePaths;
  final int crossAxisCount;
  final double spacing;
  final Function(int) onImageTap;
  final BorderRadius borderRadius;

  const AnimatedImageGrid({
    super.key,
    required this.imagePaths,
    this.crossAxisCount = 2,
    this.spacing = 12,
    required this.onImageTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: imagePaths.length,
      itemBuilder: (context, index) {
        return AppAnimations.fadeInAnimation(
          duration: Duration(milliseconds: 300 + (index * 100)),
          child: AppAnimations.heroImage(
            tag: 'image_$index',
            imagePath: imagePaths[index],
            onTap: () => onImageTap(index),
            borderRadius: borderRadius,
          ),
        );
      },
    );
  }
}
