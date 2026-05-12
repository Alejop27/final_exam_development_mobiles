// lib/features/users/domain/repositories/users_repository.dart
// Contrato del repositorio de usuarios.

import '../../../auth/domain/entities/user.dart';

abstract class UsersRepository {
  /// Lista todos los usuarios del sistema EXCEPTO el solicitante (filtrado en back).
  Future<List<User>> listAll();

  /// Detalle de un usuario por email.
  Future<User> getByEmail(String email);

  /// Mi propio perfil (del usuario autenticado).
  Future<User> getMe();
}
