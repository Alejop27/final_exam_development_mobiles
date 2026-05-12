// lib/features/messages/presentation/controllers/inbox_controller.dart
// Controller de la bandeja de entrada. Se refresca también al recibir push.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/messages_repository_impl.dart';
import '../../domain/entities/message.dart';

part 'inbox_controller.g.dart';

@riverpod
class Inbox extends _$Inbox {
  @override
  Future<List<Message>> build() async {
    final repo = ref.watch(messagesRepositoryProvider);
    // De entrada cargamos primera página (20 mensajes).
    final result = await repo.getInbox();
    return result.messages;
  }

  /// Refrescar la bandeja. Lo llamamos también al recibir un push.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(messagesRepositoryProvider);
      final result = await repo.getInbox();
      return result.messages;
    });
  }

  /// Insertar un mensaje en la lista localmente sin refetch (al recibir push).
  /// Optimiza la UX: el mensaje aparece arriba en milisegundos.
  void insertLocally(Message message) {
    final current = state.asData?.value ?? [];
    // Evitar duplicados por id
    if (current.any((m) => m.id == message.id)) return;
    state = AsyncValue.data([message, ...current]);
  }
}
