// lib/features/users/presentation/controllers/user_detail_controller.dart
// Provider parametrizado por email para detalle de usuario.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/domain/entities/user.dart';
import '../../data/repositories/users_repository_impl.dart';

part 'user_detail_controller.g.dart';

@riverpod
Future<User> userDetail(Ref ref, String email) async {
  final repo = ref.watch(usersRepositoryProvider);
  return repo.getByEmail(email);
}

/// Mi propio perfil. Se cachea aparte para el tab "Perfil".
@riverpod
Future<User> myProfile(Ref ref) async {
  final repo = ref.watch(usersRepositoryProvider);
  return repo.getMe();
}
