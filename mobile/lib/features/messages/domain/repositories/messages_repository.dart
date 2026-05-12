// lib/features/messages/domain/repositories/messages_repository.dart
// Contrato del repositorio de mensajería.

import '../entities/message.dart';
import '../entities/message_summary.dart';

class MessagesPage {
  const MessagesPage({
    required this.messages,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
  });

  final List<Message> messages;
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;

  bool get hasMore => page < totalPages;
}

abstract class MessagesRepository {
  /// Envía un mensaje + dispara push del lado del back-end.
  Future<SendMessageResult> sendMessage({
    required String recipientEmail,
    required String title,
    required String body,
  });

  /// Bandeja de mensajes recibidos del usuario autenticado.
  Future<MessagesPage> getInbox({int page = 1, int pageSize = 20});

  /// Mensajes enviados (útil para sustentación, no requerido por la rúbrica).
  Future<MessagesPage> getSent({int page = 1, int pageSize = 20});
}