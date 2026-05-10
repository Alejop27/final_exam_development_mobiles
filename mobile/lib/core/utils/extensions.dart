// lib/core/utils/extensions.dart
// Extension methods de uso general.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeFormatX on DateTime {
  /// Formato corto: "15 mar, 14:32"
  String toShortLabel() {
    final formatter = DateFormat('d MMM, HH:mm', 'es_ES');
    return formatter.format(toLocal());
  }

  /// "Hace X minutos / horas / días"
  String toRelativeLabel() {
    final diff = DateTime.now().difference(this);
    if (diff.inSeconds < 60) return 'Ahora';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
    if (diff.inDays < 7) return 'Hace ${diff.inDays} días';
    return toShortLabel();
  }
}

extension SnackbarX on BuildContext {
  void showSnackError(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFEF4444),
      ),
    );
  }

  void showSnackSuccess(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }
}
