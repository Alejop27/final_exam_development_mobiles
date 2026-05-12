// lib/features/messages/data/dtos/send_message_response_dto.dart
// Respuesta de POST /api/messages.

import '../../domain/entities/message_summary.dart';
import 'message_dto.dart';

/// Respuesta cruda del back-end: { message, deliveries, summary }
class SendMessageResponseDto {
  const SendMessageResponseDto({
    required this.message,
    required this.devicesTargeted,
    required this.devicesDelivered,
    required this.devicesFailed,
  });

  final MessageDto message;
  final int devicesTargeted;
  final int devicesDelivered;
  final int devicesFailed;

  factory SendMessageResponseDto.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] as Map<String, dynamic>;
    return SendMessageResponseDto(
      message: MessageDto.fromJson(json['message'] as Map<String, dynamic>),
      devicesTargeted: summary['devicesTargeted'] as int,
      devicesDelivered: summary['devicesDelivered'] as int,
      devicesFailed: summary['devicesFailed'] as int,
    );
  }

  SendMessageResult toDomain() {
    return SendMessageResult(
      message: message.toDomain(),
      devicesTargeted: devicesTargeted,
      devicesDelivered: devicesDelivered,
      devicesFailed: devicesFailed,
    );
  }
}