// lib/features/users/data/datasources/users_remote_datasource.dart
// Datasource HTTP para /api/users.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../dtos/user_list_dto.dart';

class UsersRemoteDatasource {
  UsersRemoteDatasource(this._dio);

  final Dio _dio;

  Future<UserListResponseDto> listAll() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/users');
    return UserListResponseDto.fromJson(response.data!);
  }

  Future<UserDetailResponseDto> getByEmail(String email) async {
    // Encodear el email por si trae caracteres especiales (.+@-)
    final encodedEmail = Uri.encodeComponent(email);
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/users/$encodedEmail',
    );
    return UserDetailResponseDto.fromJson(response.data!);
  }

  Future<UserDetailResponseDto> getMe() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/users/me');
    return UserDetailResponseDto.fromJson(response.data!);
  }
}

final usersRemoteDatasourceProvider = Provider<UsersRemoteDatasource>((ref) {
  final dio = ref.watch(dioClientProvider);
  return UsersRemoteDatasource(dio);
});
