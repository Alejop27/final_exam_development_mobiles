// lib/features/auth/presentation/controllers/auth_controller.dart
// Controller que coordina las acciones de auth desde la UI.
// Maneja loading, error, y notifica a Session el resultado exitoso.

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/providers/session_provider.dart';
import '../../../../core/services/firebase_messaging_service.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

part 'auth_controller.g.dart';

/// Estado del controller. Es un sealed-style con tres casos.
sealed class AuthControllerState {
  const AuthControllerState();
}

class AuthIdle extends AuthControllerState {
  const AuthIdle();
}

class AuthLoading extends AuthControllerState {
  const AuthLoading();
}

class AuthError extends AuthControllerState {
  const AuthError(this.message);
  final String message;
}

class AuthSuccess extends AuthControllerState {
  const AuthSuccess(this.userEmail);
  final String userEmail;
}

@riverpod
class AuthController extends _$AuthController {
  @override
  AuthControllerState build() => const AuthIdle();

  /// Registro: obtiene token FCM, llama al repo, persiste sesión.
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String jobTitle,
    required File? photo,
  }) async {
    state = const AuthLoading();

    try {
      final fcmToken = await _ensureFcmToken();
      if (fcmToken == null) {
        state = const AuthError(
          'No se pudo obtener el token de notificaciones. '
          'Verifica los permisos de notificación.',
        );
        return;
      }

      final repo = ref.read(authRepositoryProvider);
      final result = await repo.register(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
        jobTitle: jobTitle,
        fcmToken: fcmToken,
        photo: photo,
      );

      // Persistir sesión: el router redirigirá automáticamente
      await ref.read(sessionProvider.notifier).setSession(
            email: result.user.email,
            accessToken: result.accessToken,
          );

      state = AuthSuccess(result.user.email);
    } on ApiException catch (e) {
      state = AuthError(_mapApiError(e));
    } on NetworkException catch (e) {
      state = AuthError(e.message);
    } catch (e) {
      state = AuthError('Error inesperado: $e');
    }
  }

  /// Login: igual flujo que register pero con menos campos.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();

    try {
      final fcmToken = await _ensureFcmToken();
      if (fcmToken == null) {
        state = const AuthError(
          'No se pudo obtener el token de notificaciones.',
        );
        return;
      }

      final repo = ref.read(authRepositoryProvider);
      final result = await repo.login(
        email: email,
        password: password,
        fcmToken: fcmToken,
      );

      await ref.read(sessionProvider.notifier).setSession(
            email: result.user.email,
            accessToken: result.accessToken,
          );

      state = AuthSuccess(result.user.email);
    } on ApiException catch (e) {
      state = AuthError(_mapApiError(e));
    } on NetworkException catch (e) {
      state = AuthError(e.message);
    } catch (e) {
      state = AuthError('Error inesperado: $e');
    }
  }

  /// Logout: notifica al back para borrar el token FCM, luego limpia sesión local.
  Future<void> logout() async {
    state = const AuthLoading();
    try {
      final storage = ref.read(secureStorageProvider);
      final fcmToken = await storage.readFcmToken();

      if (fcmToken != null) {
        try {
          final repo = ref.read(authRepositoryProvider);
          await repo.logout(fcmToken: fcmToken);
        } catch (_) {
          // Si el back falla, igual limpiamos sesión local
        }
      }

      await ref.read(sessionProvider.notifier).clear();
      state = const AuthIdle();
    } catch (e) {
      // Aunque falle, limpiamos local
      await ref.read(sessionProvider.notifier).clear();
      state = const AuthIdle();
    }
  }

  /// Resetea el estado a Idle (útil al abandonar una pantalla con error).
  void resetState() {
    state = const AuthIdle();
  }

  // ──── Helpers privados ────

  Future<String?> _ensureFcmToken() async {
    final fcmService = ref.read(firebaseMessagingServiceProvider);
    return fcmService.getToken();
  }

  String _mapApiError(ApiException e) {
    // Mapeos específicos por code (para mensajes amigables en español)
    switch (e.code) {
      case 'EMAIL_TAKEN':
        return 'Ya existe una cuenta con ese email';
      case 'INVALID_CREDENTIALS':
        return 'Email o contraseña incorrectos';
      case 'PHOTO_REQUIRED':
        return 'Debes seleccionar una foto de perfil';
      case 'INVALID_IMAGE_TYPE':
        return 'Formato de imagen no soportado (usa JPG, PNG o WEBP)';
      case 'VALIDATION_ERROR':
        return e.message;
      default:
        return e.message;
    }
  }
}
