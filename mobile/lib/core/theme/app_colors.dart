// lib/core/theme/app_colors.dart
// Paleta de colores derivada del análisis visual.
// Identidad: violeta profundo + magenta como gradiente, blanco + dark navy de soporte.

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ──── Primarios ────
  static const Color primaryDeep = Color(0xFF6C3CE1); // Violeta profundo
  static const Color primaryBright = Color(0xFFD43BFF); // Magenta vibrante
  static const Color primaryDark = Color(
    0xFF4A24A8,
  ); // Violeta oscuro (estados pressed)

  // ──── Acentos ────
  static const Color accentBlue = Color(
    0xFF3B82F6,
  ); // Azul para acciones secundarias
  static const Color accentGreen = Color(0xFF10B981); // Verde online / éxito
  static const Color accentRed = Color(0xFFEF4444); // Rojo error / destructivo
  static const Color accentYellow = Color(0xFFF59E0B); // Amarillo advertencia

  // ──── Neutros — light theme ────
  static const Color backgroundLight = Color(
    0xFFF8F7FF,
  ); // Blanco con tinte violeta
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceLightAlt = Color(0xFFF1EEFB);

  static const Color textPrimaryLight = Color(0xFF1A1429);
  static const Color textSecondaryLight = Color(0xFF6B6582);
  static const Color textMutedLight = Color(0xFFA09BB3);
  static const Color borderLight = Color(0xFFE5E1F4);

  // ──── Neutros — dark / hero ────
  static const Color backgroundDark = Color(0xFF0F0A1E); // Splash, login
  static const Color surfaceDark = Color(0xFF1A1432);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB8B0D4);

  // ──── Glassmorphism ────
  static Color glassFill = Colors.white.withValues(alpha: 0.12);
  static Color glassBorder = Colors.white.withValues(alpha: 0.20);
  static Color glassFillDark = Colors.white.withValues(alpha: 0.06);
}
