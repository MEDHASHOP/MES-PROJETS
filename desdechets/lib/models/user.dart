/// Classe représentant un utilisateur de l'application
class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? profileImage;
  final String address;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool notificationsEnabled;
  final int sortingScore; // Score d'habitudes de tri

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profileImage,
    required this.address,
    this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
    this.notificationsEnabled = true,
    this.sortingScore = 0,
  });

  /// Obtenir le nom complet
  String get fullName => '$firstName $lastName';

  /// Créer une copie avec modifications
  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? profileImage,
    String? address,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? notificationsEnabled,
    int? sortingScore,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profileImage: profileImage ?? this.profileImage,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      sortingScore: sortingScore ?? this.sortingScore,
    );
  }

  /// Convertir en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'profileImage': profileImage,
      'address': address,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'notificationsEnabled': notificationsEnabled,
      'sortingScore': sortingScore,
    };
  }

  /// Créer depuis JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      profileImage: json['profileImage'] as String?,
      address: json['address'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      sortingScore: json['sortingScore'] as int? ?? 0,
    );
  }

  @override
  String toString() =>
      'User(id: $id, email: $email, fullName: $fullName, sortingScore: $sortingScore)';
}
