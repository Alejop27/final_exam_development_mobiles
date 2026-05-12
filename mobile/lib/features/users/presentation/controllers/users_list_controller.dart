// lib/features/users/presentation/controllers/users_list_controller.dart
// Provider de la lista de usuarios. Riverpod 2 con AsyncNotifier.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/domain/entities/user.dart';
import '../../data/repositories/users_repository_impl.dart';

part 'users_list_controller.g.dart';

@riverpod
class UsersList extends _$UsersList {
  @override
  Future<List<User>> build() async {
    final repo = ref.watch(usersRepositoryProvider);
    return repo.listAll();
  }

  /// Pull-to-refresh: vuelve a llamar al back y actualiza el state.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(usersRepositoryProvider);
      return repo.listAll();
    });
  }
}
