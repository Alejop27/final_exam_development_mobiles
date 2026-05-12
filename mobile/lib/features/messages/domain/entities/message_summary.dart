// lib/features/messages/domain/entities/message_summary.dart
// Resumen del resultado de un envío (alimenta el toast post-envío).

import 'message.dart';

export 'message.dart';

class SendMessageResult {
  const SendMessageResult({
    required this.message,
    required this.devicesTargeted,
    required this.devicesDelivered,
    required this.devicesFailed,
  });

  final Message message;
  final int devicesTargeted;
  final int devicesDelivered;
  final int devicesFailed;

  /// True si la push llegó a al menos un dispositivo.
  bool get hasDeliveries => devicesDelivered > 0;

  /// True si el destinatario no tenía dispositivos registrados.
  bool get noDevices => devicesTargeted == 0;
}

