// lib/features/users/data/dtos/user_list_dto.dart
// DTOs de las respuestas de /api/users.

import '../../../auth/data/dtos/user_dto.dart';

/// Respuesta de GET /api/users → { users: [...], total: N }
class UserListResponseDto {
  const UserListResponseDto({required this.users, required this.total});

  final List<UserDto> users;
  final int total;

  factory UserListResponseDto.fromJson(Map<String, dynamic> json) {
    final list = (json['users'] as List<dynamic>)
        .map((e) => UserDto.fromJson(e as Map<String, dynamic>))
        .toList();
    return UserListResponseDto(
      users: list,
      total: json['total'] as int? ?? list.length,
    );
  }
}

/// Respuesta de GET /api/users/:email y /api/users/me → { user: {...} }
class UserDetailResponseDto {
  const UserDetailResponseDto({required this.user});

  final UserDto user;

  factory UserDetailResponseDto.fromJson(Map<String, dynamic> json) {
    return UserDetailResponseDto(
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
