// lib/features/auth/data/dtos/auth_response_dto.dart
// DTO de la respuesta de /auth/register y /auth/login.

import '../../domain/repositories/auth_repository.dart';
import 'user_dto.dart';

class AuthResponseDto {
  const AuthResponseDto({required this.user, required this.accessToken});

  final UserDto user;
  final String accessToken;

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String,
    );
  }

  AuthResult toDomain() {
    return AuthResult(user: user.toDomain(), accessToken: accessToken);
  }
}