// lib/features/messages/data/repositories/messages_repository_impl.dart
// Implementación del MessagesRepository.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/message_summary.dart';
import '../../domain/repositories/messages_repository.dart';
import '../datasources/messages_remote_datasource.dart';

class MessagesRepositoryImpl implements MessagesRepository {
  MessagesRepositoryImpl(this._datasource);

  final MessagesRemoteDatasource _datasource;

  @override
  Future<SendMessageResult> sendMessage({
    required String recipientEmail,
    required String title,
    required String body,
  }) async {
    final dto = await _datasource.sendMessage(
      recipientEmail: recipientEmail,
      title: title,
      body: body,
    );
    return dto.toDomain();
  }

  @override
  Future<MessagesPage> getInbox({int page = 1, int pageSize = 20}) async {
    final dto = await _datasource.getInbox(page: page, pageSize: pageSize);
    return dto.toDomain();
  }

  @override
  Future<MessagesPage> getSent({int page = 1, int pageSize = 20}) async {
    final dto = await _datasource.getSent(page: page, pageSize: pageSize);
    return dto.toDomain();
  }
}

final messagesRepositoryProvider = Provider<MessagesRepository>((ref) {
  final datasource = ref.watch(messagesRemoteDatasourceProvider);
  return MessagesRepositoryImpl(datasource);
});
