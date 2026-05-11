// lib/features/auth/data/repositories/auth_repository_impl.dart
// Implementación del contrato AuthRepository.
// Adapta los DTOs del datasource a entidades del dominio.

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._datasource);

  final AuthRemoteDatasource _datasource;

  @override
  Future<AuthResult> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String jobTitle,
    required String fcmToken,
    required File? photo,
  }) async {
    final dto = await _datasource.register(
      email: email,
      password: password,
      fullName: fullName,
      phoneNumber: phoneNumber,
      jobTitle: jobTitle,
      fcmToken: fcmToken,
      photo: photo,
    );
    return dto.toDomain();
  }

  @override
  Future<AuthResult> login({
    required String email,
    required String password,
    required String fcmToken,
  }) async {
    final dto = await _datasource.login(
      email: email,
      password: password,
      fcmToken: fcmToken,
    );
    return dto.toDomain();
  }

  @override
  Future<void> logout({required String fcmToken}) {
    return _datasource.logout(fcmToken: fcmToken);
  }
}

/// Provider del repository (devuelve el TIPO ABSTRACTO).
/// Esto permite cambiar la implementación sin tocar la presentation.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final datasource = ref.watch(authRemoteDatasourceProvider);
  return AuthRepositoryImpl(datasource);
});