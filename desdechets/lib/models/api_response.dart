/// Modèles de réponses API pour l'application de gestion des déchets
/// Wrapper générique pour les réponses
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final int? errorCode;
  final DateTime timestamp;

  ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.errorCode,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Créer une réponse réussie
  factory ApiResponse.success(T data) {
    return ApiResponse(success: true, data: data);
  }

  /// Créer une réponse d'erreur
  factory ApiResponse.error(String error, {int? errorCode}) {
    return ApiResponse(
      success: false,
      error: error,
      errorCode: errorCode ?? 500,
    );
  }

  @override
  String toString() =>
      'ApiResponse(success: $success, error: $error, timestamp: $timestamp)';
}

/// Wrapper pour les listes paginées
class PaginatedResponse<T> {
  final List<T> items;
  final int total;
  final int page;
  final int pageSize;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginatedResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  /// Obtenir le nombre total de pages
  int get totalPages => (total / pageSize).ceil();

  /// Vérifier s'il y a des éléments
  bool get isEmpty => items.isEmpty;

  /// Vérifier si c'est la première page
  bool get isFirstPage => page == 1;

  /// Vérifier si c'est la dernière page
  bool get isLastPage => !hasNextPage;

  @override
  String toString() =>
      'PaginatedResponse(page: $page/$totalPages, items: ${items.length}/$total)';
}

/// Réponse pour l'authentification
class AuthResponse {
  final bool success;
  final String? userId;
  final String? email;
  final String? token;
  final String? error;
  final UserAuthData? userData;

  AuthResponse({
    required this.success,
    this.userId,
    this.email,
    this.token,
    this.error,
    this.userData,
  });

  factory AuthResponse.success({
    required String userId,
    required String email,
    required String token,
    UserAuthData? userData,
  }) {
    return AuthResponse(
      success: true,
      userId: userId,
      email: email,
      token: token,
      userData: userData,
    );
  }

  factory AuthResponse.failure(String error) {
    return AuthResponse(success: false, error: error);
  }

  @override
  String toString() =>
      'AuthResponse(success: $success, userId: $userId, email: $email)';
}

/// Données utilisateur depuis l'authentification
class UserAuthData {
  final String firstName;
  final String lastName;
  final String? profileImage;
  final bool isNewUser;
  final DateTime createdAt;

  UserAuthData({
    required this.firstName,
    required this.lastName,
    this.profileImage,
    this.isNewUser = false,
    required this.createdAt,
  });

  @override
  String toString() =>
      'UserAuthData(name: $firstName $lastName, newUser: $isNewUser)';
}

/// Réponse pour les statistiques
class StatisticsResponse {
  final int totalCollections;
  final int totalWeightKg;
  final Map<String, int> wasteBreakdown;
  final double co2Saved;
  final int level;
  final int points;
  final DateTime periodStart;
  final DateTime periodEnd;

  StatisticsResponse({
    required this.totalCollections,
    required this.totalWeightKg,
    required this.wasteBreakdown,
    required this.co2Saved,
    required this.level,
    required this.points,
    required this.periodStart,
    required this.periodEnd,
  });

  /// Obtenir le pourcentage de progrès vers le niveau suivant
  int getProgressToNextLevel() {
    final currentLevelPoints = (level - 1) * 1000;
    final nextLevelPoints = level * 1000;
    final progress =
        (points - currentLevelPoints) / (nextLevelPoints - currentLevelPoints);
    return (progress * 100).toInt().clamp(0, 100);
  }

  @override
  String toString() =>
      'StatisticsResponse(collections: $totalCollections, weight: ${totalWeightKg}kg, level: $level)';
}

/// Réponse pour la recherche
class SearchResponse<T> {
  final List<T> results;
  final int totalResults;
  final String query;
  final List<String>? suggestions;
  final Map<String, int>? facets;

  SearchResponse({
    required this.results,
    required this.totalResults,
    required this.query,
    this.suggestions,
    this.facets,
  });

  bool get hasResults => results.isNotEmpty;

  @override
  String toString() =>
      'SearchResponse(query: "$query", results: ${results.length}/$totalResults)';
}

/// Réponse pour le téléchargement de fichiers
class UploadResponse {
  final bool success;
  final String? fileUrl;
  final String? fileName;
  final int? fileSize;
  final String? error;
  final double uploadProgress; // 0.0 à 1.0

  UploadResponse({
    required this.success,
    this.fileUrl,
    this.fileName,
    this.fileSize,
    this.error,
    this.uploadProgress = 1.0,
  });

  int get uploadProgressPercent => (uploadProgress * 100).toInt();

  factory UploadResponse.success({
    required String fileUrl,
    required String fileName,
    required int fileSize,
  }) {
    return UploadResponse(
      success: true,
      fileUrl: fileUrl,
      fileName: fileName,
      fileSize: fileSize,
      uploadProgress: 1.0,
    );
  }

  factory UploadResponse.error(String error) {
    return UploadResponse(success: false, error: error);
  }

  factory UploadResponse.inProgress(double progress) {
    return UploadResponse(
      success: false,
      uploadProgress: progress.clamp(0.0, 1.0),
    );
  }

  @override
  String toString() =>
      'UploadResponse(success: $success, file: $fileName, progress: $uploadProgressPercent%)';
}

/// Réponse pour le batch
class BatchResponse {
  final int totalRequests;
  final int successCount;
  final int errorCount;
  final List<String>? errors;
  final DateTime timestamp;

  BatchResponse({
    required this.totalRequests,
    required this.successCount,
    required this.errorCount,
    this.errors,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  bool get isFullySuccessful => errorCount == 0;

  double get successRate => successCount / totalRequests;

  int get successPercent => (successRate * 100).toInt();

  @override
  String toString() =>
      'BatchResponse(total: $totalRequests, success: $successCount, errors: $errorCount)';
}

/// Réponse pour les notifications
class NotificationResponse {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final Map<String, dynamic>? data;
  final DateTime timestamp;
  final bool isRead;

  NotificationResponse({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.data,
    required this.timestamp,
    this.isRead = false,
  });

  @override
  String toString() =>
      'NotificationResponse(id: $id, title: $title, type: $type)';
}

/// Type de notification
enum NotificationType {
  collection,
  achievement,
  reminder,
  update,
  alert,
  message,
}

/// Réponse pour l'export de données
class ExportDataResponse {
  final String fileName;
  final String? downloadUrl;
  final int totalItems;
  final String format; // "json", "csv", "pdf"
  final DateTime exportDate;
  final int fileSize;

  ExportDataResponse({
    required this.fileName,
    this.downloadUrl,
    required this.totalItems,
    required this.format,
    required this.exportDate,
    required this.fileSize,
  });

  String get fileSizeKb => '${(fileSize / 1024).toStringAsFixed(2)} KB';

  @override
  String toString() =>
      'ExportDataResponse(file: $fileName, items: $totalItems, format: $format)';
}

/// Modèle d'erreur unifié
class AppError {
  final String message;
  final String? code;
  final String? details;
  final StackTrace? stackTrace;

  AppError({required this.message, this.code, this.details, this.stackTrace});

  factory AppError.fromException(Exception e, {StackTrace? stackTrace}) {
    return AppError(
      message: e.toString(),
      code: 'exception',
      stackTrace: stackTrace,
    );
  }

  @override
  String toString() =>
      'AppError(code: $code, message: $message, details: $details)';
}
