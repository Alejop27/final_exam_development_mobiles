// lib/core/network/interceptors/error_interceptor.dart
// Mapea DioException a ApiException tipada.

import 'package:dio/dio.dart';
import '../api_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;

    // Caso 1: error de red (sin response del servidor)
    if (response == null) {
      final exception = NetworkException(_networkErrorMessage(err.type));
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: exception,
          type: err.type,
        ),
      );
      return;
    }

    // Caso 2: el back-end respondió con JSON estructurado: { error: {...} }
    String message = 'Error en el servidor';
    String? code;
    Object? details;

    final data = response.data;
    if (data is Map<String, dynamic> && data['error'] is Map) {
      final errorObj = data['error'] as Map<String, dynamic>;
      message = (errorObj['message'] as String?) ?? message;
      code = errorObj['code'] as String?;
      details = errorObj['details'];
    }

    final apiException = ApiException(
      statusCode: response.statusCode ?? 0,
      message: message,
      code: code,
      details: details,
    );

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: response,
        error: apiException,
        type: err.type,
      ),
    );
  }

  String _networkErrorMessage(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
        return 'Tiempo de conexión agotado';
      case DioExceptionType.receiveTimeout:
        return 'El servidor tardó demasiado en responder';
      case DioExceptionType.sendTimeout:
        return 'Tiempo de envío agotado';
      case DioExceptionType.connectionError:
        return 'No se pudo conectar al servidor';
      case DioExceptionType.cancel:
        return 'Solicitud cancelada';
      case DioExceptionType.badCertificate:
        return 'Certificado inválido';
      default:
        return 'Error de red';
    }
  }
}
