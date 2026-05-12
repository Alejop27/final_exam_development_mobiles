// lib/features/messages/data/dtos/message_dto.dart
// DTOs del back-end: PublicMessage y PagedMessages.

import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/messages_repository.dart';

/// Mini DTO del usuario embebido en mensaje (sender/recipient summary).
class MessageUserSummaryDto {
  const MessageUserSummaryDto({
    required this.email,
    required this.fullName,
    required this.jobTitle,
    this.photoUrl,
  });

  final String email;
  final String fullName;
  final String? photoUrl;
  final String jobTitle;

  factory MessageUserSummaryDto.fromJson(Map<String, dynamic> json) {
    return MessageUserSummaryDto(
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      photoUrl: json['photoUrl'] as String?,
      jobTitle: json['jobTitle'] as String,
    );
  }

  /// Convierte el summary en una entidad User parcial.
  /// (phoneNumber/createdAt/authProvider se rellenan con defaults: nunca
  /// los vamos a usar desde el contexto de un mensaje.)
  User toDomain() {
    return User(
      email: email,
      fullName: fullName,
      photoUrl: photoUrl,
      phoneNumber: '',
      jobTitle: jobTitle,
      authProvider: 'LOCAL',
      createdAt: DateTime.now(),
    );
  }
}

class MessageDto {
  const MessageDto({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.sender,
    required this.recipient,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final MessageUserSummaryDto sender;
  final MessageUserSummaryDto recipient;

  factory MessageDto.fromJson(Map<String, dynamic> json) {
    return MessageDto(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      sender: MessageUserSummaryDto.fromJson(
          json['sender'] as Map<String, dynamic>),
      recipient: MessageUserSummaryDto.fromJson(
          json['recipient'] as Map<String, dynamic>),
    );
  }

  Message toDomain() {
    return Message(
      id: id,
      title: title,
      body: body,
      createdAt: createdAt,
      sender: sender.toDomain(),
      recipient: recipient.toDomain(),
    );
  }
}

/// Respuesta paginada de bandeja: { messages: [...], pagination: {...} }
class PagedMessagesDto {
  const PagedMessagesDto({
    required this.messages,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
  });

  final List<MessageDto> messages;
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;

  factory PagedMessagesDto.fromJson(Map<String, dynamic> json) {
    final list = (json['messages'] as List<dynamic>)
        .map((e) => MessageDto.fromJson(e as Map<String, dynamic>))
        .toList();
    final pag = json['pagination'] as Map<String, dynamic>;
    return PagedMessagesDto(
      messages: list,
      page: pag['page'] as int,
      pageSize: pag['pageSize'] as int,
      total: pag['total'] as int,
      totalPages: pag['totalPages'] as int,
    );
  }

  MessagesPage toDomain() {
    return MessagesPage(
      messages: messages.map((m) => m.toDomain()).toList(),
      page: page,
      pageSize: pageSize,
      total: total,
      totalPages: totalPages,
    );
  }
}