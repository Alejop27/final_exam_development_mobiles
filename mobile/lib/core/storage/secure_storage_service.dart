// lib/core/storage/secure_storage_service.dart
// Wrapper sobre flutter_secure_storage. Centraliza claves y manejo de errores.

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecureStorageService {
  SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  // ──── Claves ────
  static const String _kAccessToken = 'access_token';
  static const String _kCurrentUserEmail = 'current_user_email';
  static const String _kFcmToken = 'fcm_token';

  // ──── Access token (JWT) ────
  Future<void> saveAccessToken(String token) =>
      _storage.write(key: _kAccessToken, value: token);

  Future<String?> readAccessToken() => _storage.read(key: _kAccessToken);

  Future<void> deleteAccessToken() => _storage.delete(key: _kAccessToken);

  // ──── Email del usuario en sesión ────
  Future<void> saveCurrentUserEmail(String email) =>
      _storage.write(key: _kCurrentUserEmail, value: email);

  Future<String?> readCurrentUserEmail() =>
      _storage.read(key: _kCurrentUserEmail);

  Future<void> deleteCurrentUserEmail() =>
      _storage.delete(key: _kCurrentUserEmail);

  // ──── FCM token (cache para no llamar a Firebase cada vez) ────
  Future<void> saveFcmToken(String token) =>
      _storage.write(key: _kFcmToken, value: token);

  Future<String?> readFcmToken() => _storage.read(key: _kFcmToken);

  // ──── Reset completo (logout) ────
  Future<void> clearAll() async {
    await _storage.delete(key: _kAccessToken);
    await _storage.delete(key: _kCurrentUserEmail);
    // No borramos fcm_token: el dispositivo sigue siendo el mismo
  }
}

/// Provider de Riverpod para inyectar el servicio donde se necesite.
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  return SecureStorageService(storage);
});
