// lib/features/users/data/repositories/users_repository_impl.dart
// Implementación de UsersRepository: adapta DTOs a entidades.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/users_remote_datasource.dart';

class UsersRepositoryImpl implements UsersRepository {
  UsersRepositoryImpl(this._datasource);

  final UsersRemoteDatasource _datasource;

  @override
  Future<List<User>> listAll() async {
    final response = await _datasource.listAll();
    return response.users.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<User> getByEmail(String email) async {
    final response = await _datasource.getByEmail(email);
    return response.user.toDomain();
  }

  @override
  Future<User> getMe() async {
    final response = await _datasource.getMe();
    return response.user.toDomain();
  }
}

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  final datasource = ref.watch(usersRemoteDatasourceProvider);
  return UsersRepositoryImpl(datasource);
});