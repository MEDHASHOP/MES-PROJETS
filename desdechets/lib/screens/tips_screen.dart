import '../models/index.dart';

/// Classe représentant l'état de l'écran conseils
class TipsScreenState {
  final List<RecyclingTip> tips;
  final List<RecyclingTip> favoriteTips;
  final RecyclingTip? selectedTip;
  final String? selectedCategory;
  final TipsSortOption sortOption;
  final bool isLoading;
  final String? error;
  final List<String> availableCategories;
  final int totalTips;

  const TipsScreenState({
    this.tips = const [],
    this.favoriteTips = const [],
    this.selectedTip,
    this.selectedCategory,
    this.sortOption = TipsSortOption.newest,
    this.isLoading = false,
    this.error,
    this.availableCategories = const [],
    this.totalTips = 0,
  });

  /// Obtenir les conseils filtrés
  List<RecyclingTip> getFilteredTips() {
    if (selectedCategory == null || selectedCategory!.isEmpty) {
      return tips;
    }

    return tips
        .where(
          (tip) =>
              tip.category.toLowerCase() == selectedCategory!.toLowerCase(),
        )
        .toList();
  }

  /// Obtenir les conseils triés
  List<RecyclingTip> getSortedTips() {
    final filtered = getFilteredTips();

    switch (sortOption) {
      case TipsSortOption.newest:
        return filtered..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      case TipsSortOption.oldest:
        return filtered..sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
      case TipsSortOption.mostViewed:
        return filtered..sort((a, b) => b.viewCount.compareTo(a.viewCount));
      case TipsSortOption.highestRated:
        return filtered..sort((a, b) => b.rating.compareTo(a.rating));
      case TipsSortOption.easiest:
        return filtered..sort((a, b) => a.difficulty.compareTo(b.difficulty));
    }
  }

  /// Vérifier si un conseil est favori
  bool isFavorite(RecyclingTip tip) {
    return favoriteTips.any((fav) => fav.id == tip.id);
  }

  /// Créer une copie avec modifications
  TipsScreenState copyWith({
    List<RecyclingTip>? tips,
    List<RecyclingTip>? favoriteTips,
    RecyclingTip? selectedTip,
    String? selectedCategory,
    TipsSortOption? sortOption,
    bool? isLoading,
    String? error,
    List<String>? availableCategories,
    int? totalTips,
  }) {
    return TipsScreenState(
      tips: tips ?? this.tips,
      favoriteTips: favoriteTips ?? this.favoriteTips,
      selectedTip: selectedTip ?? this.selectedTip,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      sortOption: sortOption ?? this.sortOption,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      availableCategories: availableCategories ?? this.availableCategories,
      totalTips: totalTips ?? this.totalTips,
    );
  }

  @override
  String toString() =>
      'TipsScreenState(tipsCount: ${tips.length}, selectedCategory: $selectedCategory)';
}

/// Options de tri des conseils
enum TipsSortOption {
  newest, // Les plus récents
  oldest, // Les plus anciens
  mostViewed, // Les plus consultés
  highestRated, // Les mieux notés
  easiest, // Les plus faciles
}

/// Classe pour une fiche de conseil avec contenu détaillé
class TipDetail {
  final RecyclingTip tip;
  final List<String> steps; // Étapes pour suivre le conseil
  final List<String> materials; // Matériaux nécessaires
  final List<String> benefits; // Bénéfices du conseil
  final List<String> commonMistakes; // Erreurs courantes
  final List<RecyclingTip> relatedTips; // Conseils liés
  final List<TipComment> comments;
  final int viewCount;
  final double userRating; // Note de l'utilisateur (0-5)

  const TipDetail({
    required this.tip,
    this.steps = const [],
    this.materials = const [],
    this.benefits = const [],
    this.commonMistakes = const [],
    this.relatedTips = const [],
    this.comments = const [],
    this.viewCount = 0,
    this.userRating = 0.0,
  });

  /// Créer une copie avec modifications
  TipDetail copyWith({
    RecyclingTip? tip,
    List<String>? steps,
    List<String>? materials,
    List<String>? benefits,
    List<String>? commonMistakes,
    List<RecyclingTip>? relatedTips,
    List<TipComment>? comments,
    int? viewCount,
    double? userRating,
  }) {
    return TipDetail(
      tip: tip ?? this.tip,
      steps: steps ?? this.steps,
      materials: materials ?? this.materials,
      benefits: benefits ?? this.benefits,
      commonMistakes: commonMistakes ?? this.commonMistakes,
      relatedTips: relatedTips ?? this.relatedTips,
      comments: comments ?? this.comments,
      viewCount: viewCount ?? this.viewCount,
      userRating: userRating ?? this.userRating,
    );
  }

  @override
  String toString() =>
      'TipDetail(title: ${tip.title}, stepsCount: ${steps.length}, commentsCount: ${comments.length})';
}

/// Classe pour un commentaire sur un conseil
class TipComment {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final double rating; // Note associée au commentaire
  final DateTime createdAt;
  final int likes;
  final bool isVerified; // Si l'auteur est un expert

  const TipComment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    this.rating = 0.0,
    required this.createdAt,
    this.likes = 0,
    this.isVerified = false,
  });

  /// Obtenir le texte du temps écoulé
  String get timeAgoText {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays}j';
    } else {
      return createdAt.toString().split(' ')[0];
    }
  }

  /// Créer une copie avec modifications
  TipComment copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    String? content,
    double? rating,
    DateTime? createdAt,
    int? likes,
    bool? isVerified,
  }) {
    return TipComment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  @override
  String toString() =>
      'TipComment(id: $id, user: $userName, createdAt: $createdAt)';
}

/// Classe pour les quizz interactifs
class RecyclingQuiz {
  final String id;
  final String title;
  final String description;
  final List<QuizQuestion> questions;
  final int estimatedDuration; // En secondes
  final String category;
  final double difficulty;
  final int completions; // Nombre de fois complété

  const RecyclingQuiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    this.estimatedDuration = 300,
    required this.category,
    this.difficulty = 2.0,
    this.completions = 0,
  });

  @override
  String toString() =>
      'RecyclingQuiz(id: $id, title: $title, questionsCount: ${questions.length})';
}

/// Classe pour une question de quizz
class QuizQuestion {
  final String id;
  final String question;
  final List<String> answers;
  final int correctAnswerIndex;
  final String? explanation;
  final String? imageUrl;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.answers,
    required this.correctAnswerIndex,
    this.explanation,
    this.imageUrl,
  });

  /// Vérifier si la réponse est correcte
  bool isCorrect(int selectedIndex) => selectedIndex == correctAnswerIndex;

  @override
  String toString() =>
      'QuizQuestion(id: $id, question: $question, answersCount: ${answers.length})';
}
