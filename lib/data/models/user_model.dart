// lib/data/models/user_model.dart - Add copyWith method
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final int completedTrips;
  final int savedTrips;
  final int achievements;
  final String preferredLanguage;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.completedTrips = 0,
    this.savedTrips = 0,
    this.achievements = 0,
    this.preferredLanguage = 'ar',
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImageUrl: json['profile_image_url'],
      completedTrips: json['completed_trips'] ?? 0,
      savedTrips: json['saved_trips'] ?? 0,
      achievements: json['achievements'] ?? 0,
      preferredLanguage: json['preferred_language'] ?? 'ar',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_image_url': profileImageUrl,
      'completed_trips': completedTrips,
      'saved_trips': savedTrips,
      'achievements': achievements,
      'preferred_language': preferredLanguage,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // إضافة copyWith method
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    int? completedTrips,
    int? savedTrips,
    int? achievements,
    String? preferredLanguage,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      completedTrips: completedTrips ?? this.completedTrips,
      savedTrips: savedTrips ?? this.savedTrips,
      achievements: achievements ?? this.achievements,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}