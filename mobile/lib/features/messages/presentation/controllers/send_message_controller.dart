// lib/features/messages/presentation/controllers/send_message_controller.dart
// Controller del flujo de envío. Estado sealed-style igual que auth.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/api_exception.dart';
import '../../data/repositories/messages_repository_impl.dart';
import '../../domain/entities/message_summary.dart';

part 'send_message_controller.g.dart';

sealed class SendMessageState {
  const SendMessageState();
}

class SendIdle extends SendMessageState {
  const SendIdle();
}

class SendLoading extends SendMessageState {
  const SendLoading();
}

class SendError extends SendMessageState {
  const SendError(this.message);
  final String message;
}

class SendSuccess extends SendMessageState {
  const SendSuccess(this.result);
  final SendMessageResult result;
}

@riverpod
class SendMessageController extends _$SendMessageController {
  @override
  SendMessageState build() => const SendIdle();

  Future<void> send({
    required String recipientEmail,
    required String title,
    required String body,
  }) async {
    state = const SendLoading();
    try {
      final repo = ref.read(messagesRepositoryProvider);
      final result = await repo.sendMessage(
        recipientEmail: recipientEmail,
        title: title,
        body: body,
      );
      state = SendSuccess(result);
    } on ApiException catch (e) {
      state = SendError(_mapError(e));
    } on NetworkException catch (e) {
      state = SendError(e.message);
    } catch (e) {
      state = SendError('Error inesperado: $e');
    }
  }

  void reset() => state = const SendIdle();

  String _mapError(ApiException e) {
    switch (e.code) {
      case 'RECIPIENT_NOT_FOUND':
        return 'El destinatario ya no existe en el sistema';
      case 'SELF_MESSAGE_FORBIDDEN':
        return 'No puedes enviarte mensajes a ti mismo';
      case 'VALIDATION_ERROR':
        return e.message;
      default:
        return e.message;
    }
  }
}
