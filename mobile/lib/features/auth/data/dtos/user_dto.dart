// lib/features/auth/data/dtos/user_dto.dart
// DTO de usuario tal como viene del back-end.

import '../../domain/entities/user.dart';

class UserDto {
  const UserDto({
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.jobTitle,
    required this.authProvider,
    required this.createdAt,
    this.photoUrl,
  });

  final String email;
  final String fullName;
  final String? photoUrl;
  final String phoneNumber;
  final String jobTitle;
  final String authProvider;
  final DateTime createdAt;

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      photoUrl: json['photoUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String,
      jobTitle: json['jobTitle'] as String,
      authProvider: json['authProvider'] as String? ?? 'LOCAL',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convierte el DTO a entidad de dominio.
  User toDomain() {
    return User(
      email: email,
      fullName: fullName,
      photoUrl: photoUrl,
      phoneNumber: phoneNumber,
      jobTitle: jobTitle,
      authProvider: authProvider,
      createdAt: createdAt,
    );
  }
}
