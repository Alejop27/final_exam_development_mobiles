// lib/features/auth/data/datasources/auth_remote_datasource.dart
// Datasource HTTP. Encapsula las llamadas a /api/auth/*.
// Lo consume el repository — nunca se llama directamente desde la UI.

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../dtos/auth_response_dto.dart';

class AuthRemoteDatasource {
  AuthRemoteDatasource(this._dio);

  final Dio _dio;

  /// POST /api/auth/register
  /// El back-end espera multipart/form-data con todos los campos + photo.
  Future<AuthResponseDto> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String jobTitle,
    required String fcmToken,
    required File? photo,
  }) async {
    final formData = FormData.fromMap({
      'email': email,
      'password': password,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'jobTitle': jobTitle,
      'fcmToken': fcmToken,
      if (photo != null)
        'photo': await MultipartFile.fromFile(
          photo.path,
          filename: photo.path.split(Platform.pathSeparator).last,
        ),
    });

    final response = await _dio.post<Map<String, dynamic>>(
      '/api/auth/register',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        // Esta ruta NO requiere JWT
        extra: {'skipAuth': true},
      ),
    );

    return AuthResponseDto.fromJson(response.data!);
  }

  /// POST /api/auth/login
  Future<AuthResponseDto> login({
    required String email,
    required String password,
    required String fcmToken,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/auth/login',
      data: {
        'email': email,
        'password': password,
        'fcmToken': fcmToken,
      },
      options: Options(extra: {'skipAuth': true}),
    );

    return AuthResponseDto.fromJson(response.data!);
  }

  /// POST /api/auth/logout
  /// Esta ruta SÍ requiere JWT — el interceptor lo inyecta automáticamente.
  Future<void> logout({required String fcmToken}) async {
    await _dio.post<void>(
      '/api/auth/logout',
      data: {'fcmToken': fcmToken},
    );
  }
}

/// Provider del datasource.
final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final dio = ref.watch(dioClientProvider);
  return AuthRemoteDatasource(dio);
});
