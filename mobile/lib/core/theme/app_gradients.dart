// lib/core/theme/app_gradients.dart
// Gradientes reutilizables. El gradiente principal es la IDENTIDAD VISUAL de la app.

import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  AppGradients._();

  /// Gradiente identidad: violeta profundo → magenta. 135° (top-left → bottom-right).
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primaryDeep, AppColors.primaryBright],
  );

  /// Gradiente para fondos hero: navy oscuro con tinte violeta.
  static const LinearGradient heroDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A1432), Color(0xFF0F0A1E)],
  );

  /// Gradiente sutil para cards en modo light.
  static const LinearGradient cardLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF1EEFB)],
  );

  /// Gradiente para overlays sobre imágenes (foto de perfil hero).
  static LinearGradient imageOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Colors.black.withValues(alpha: 0.4),
      Colors.black.withValues(alpha: 0.7),
    ],
    stops: const [0.0, 0.6, 1.0],
  );
}
