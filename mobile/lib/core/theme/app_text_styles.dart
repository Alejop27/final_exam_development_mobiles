// lib/core/theme/app_text_styles.dart
// Jerarquía tipográfica con Plus Jakarta Sans (de Google Fonts).

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Helper interno
  static TextStyle _base(
    double size,
    FontWeight weight, {
    Color color = AppColors.textPrimaryLight,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // ──── Display (hero) ────
  static TextStyle displayLarge = _base(
    40,
    FontWeight.w800,
    letterSpacing: -1.0,
    height: 1.1,
  );
  static TextStyle displayMedium = _base(
    32,
    FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.15,
  );

  // ──── Títulos ────
  static TextStyle titleLarge = _base(24, FontWeight.w700, height: 1.2);
  static TextStyle titleMedium = _base(20, FontWeight.w700, height: 1.25);
  static TextStyle titleSmall = _base(16, FontWeight.w600, height: 1.3);

  // ──── Body ────
  static TextStyle bodyLarge = _base(16, FontWeight.w500, height: 1.4);
  static TextStyle bodyMedium = _base(14, FontWeight.w500, height: 1.4);
  static TextStyle bodySmall = _base(12, FontWeight.w500, height: 1.4);

  // ──── Labels / botones ────
  static TextStyle labelLarge = _base(14, FontWeight.w700, letterSpacing: 0.3);
  static TextStyle labelMedium = _base(12, FontWeight.w600);
  static TextStyle labelSmall = _base(
    10,
    FontWeight.w600,
    color: AppColors.textMutedLight,
  );

  // ──── Sobre fondos oscuros (hero) ────
  static TextStyle heroTitle = _base(
    36,
    FontWeight.w800,
    color: AppColors.textPrimaryDark,
    letterSpacing: -0.5,
    height: 1.1,
  );
  static TextStyle heroSubtitle = _base(
    16,
    FontWeight.w500,
    color: AppColors.textSecondaryDark,
    height: 1.4,
  );
}
