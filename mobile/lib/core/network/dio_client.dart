// lib/core/network/dio_client.dart
// Provider de Dio configurado con interceptors. Se inyecta a los repositories.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/app_config.dart';
import '../storage/secure_storage_service.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';

/// Provider de la instancia única de Dio configurada.
final dioClientProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      sendTimeout: AppConfig.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      // Aceptamos hasta 4xx para que el ErrorInterceptor los procese
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  // Orden importa: error PRIMERO (al revés en onError) → auth → logger
  dio.interceptors.addAll([
    AuthInterceptor(storage),
    ErrorInterceptor(),
    if (AppConfig.apiBaseUrl.contains('localhost') ||
        AppConfig.apiBaseUrl.contains('10.0.2.2'))
      PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
      ),
  ]);

  return dio;
});
