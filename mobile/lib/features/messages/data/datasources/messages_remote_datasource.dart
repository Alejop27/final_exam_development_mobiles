// lib/features/messages/data/datasources/messages_remote_datasource.dart
// Datasource HTTP para /api/messages.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../dtos/message_dto.dart';
import '../dtos/send_message_response_dto.dart';

class MessagesRemoteDatasource {
  MessagesRemoteDatasource(this._dio);

  final Dio _dio;

  Future<SendMessageResponseDto> sendMessage({
    required String recipientEmail,
    required String title,
    required String body,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/messages',
      data: {
        'recipientEmail': recipientEmail,
        'title': title,
        'body': body,
      },
    );
    return SendMessageResponseDto.fromJson(response.data!);
  }

  Future<PagedMessagesDto> getInbox({
    required int page,
    required int pageSize,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/messages/inbox',
      queryParameters: {'page': page, 'pageSize': pageSize},
    );
    return PagedMessagesDto.fromJson(response.data!);
  }

  Future<PagedMessagesDto> getSent({
    required int page,
    required int pageSize,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/messages/sent',
      queryParameters: {'page': page, 'pageSize': pageSize},
    );
    return PagedMessagesDto.fromJson(response.data!);
  }
}

final messagesRemoteDatasourceProvider =
    Provider<MessagesRemoteDatasource>((ref) {
  final dio = ref.watch(dioClientProvider);
  return MessagesRemoteDatasource(dio);
});
