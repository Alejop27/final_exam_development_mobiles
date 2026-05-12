// lib/features/messages/domain/entities/message.dart
// Entidad pura: un mensaje recibido o enviado en la bandeja.

import '../../../auth/domain/entities/user.dart';

class Message {
  const Message({
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
  final User sender;
  final User recipient;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Message && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
