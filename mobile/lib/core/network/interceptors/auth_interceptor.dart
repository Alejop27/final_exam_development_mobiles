// lib/core/network/interceptors/auth_interceptor.dart
// Inyecta automáticamente el JWT en el header Authorization de cada request.

import 'package:dio/dio.dart';
import '../../storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage);

  final SecureStorageService _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Solo inyectar si la request no marca explícitamente "no auth needed"
    final skipAuth = options.extra['skipAuth'] == true;

    if (!skipAuth) {
      final token = await _storage.readAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }
}
