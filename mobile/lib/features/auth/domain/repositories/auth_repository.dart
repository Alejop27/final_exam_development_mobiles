// lib/features/auth/domain/repositories/auth_repository.dart
// Contrato abstracto. La capa data lo implementa; la capa presentation lo consume.
// Esta inversión de dependencia es el core de Clean Architecture.

import 'dart:io';
import '../../domain/entities/user.dart';

/// Datos retornados al hacer login o registro exitoso.
class AuthResult {
  const AuthResult({required this.user, required this.accessToken});

  final User user;
  final String accessToken;
}

/// Contrato del repositorio de autenticación.
abstract class AuthRepository {
  /// Registra una cuenta nueva.
  /// [photo] es null en plataformas web donde no podemos usar dart:io.
  Future<AuthResult> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String jobTitle,
    required String fcmToken,
    required File? photo,
  });

  /// Login con credenciales.
  Future<AuthResult> login({
    required String email,
    required String password,
    required String fcmToken,
  });

  /// Logout: elimina el token FCM en el servidor.
  Future<void> logout({required String fcmToken});
}
