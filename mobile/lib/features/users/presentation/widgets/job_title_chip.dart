// lib/features/users/presentation/widgets/job_title_chip.dart
// Chip de cargo con color por categoría. Ayuda a la jerarquía visual corporativa.

import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';

class JobTitleChip extends StatelessWidget {
  const JobTitleChip({required this.jobTitle, this.dense = false, super.key});

  final String jobTitle;
  final bool dense;

  /// Asigna un color por familia de cargos. Coherente con el análisis visual:
  /// "el cargo debe ser visualmente diferenciado".
  ({Color bg, Color fg}) _colorsFor(String title) {
    final t = title.toLowerCase();
    if (t.contains('gerente') || t.contains('director')) {
      return (bg: const Color(0xFFFEF3C7), fg: const Color(0xFF92400E));
    }
    if (t.contains('técnico') ||
        t.contains('tecnico') ||
        t.contains('analista')) {
      return (bg: const Color(0xFFDBEAFE), fg: const Color(0xFF1E40AF));
    }
    if (t.contains('contador') || t.contains('financ')) {
      return (bg: const Color(0xFFD1FAE5), fg: const Color(0xFF065F46));
    }
    if (t.contains('logístico') ||
        t.contains('logistico') ||
        t.contains('servicios')) {
      return (bg: const Color(0xFFEDE9FE), fg: const Color(0xFF5B21B6));
    }
    if (t.contains('auxiliar') || t.contains('asistente')) {
      return (bg: const Color(0xFFFCE7F3), fg: const Color(0xFF9D174D));
    }
    return (bg: const Color(0xFFF1EEFB), fg: const Color(0xFF6C3CE1));
  }

  @override
  Widget build(BuildContext context) {
    final c = _colorsFor(jobTitle);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 12,
        vertical: dense ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        jobTitle,
        style: (dense ? AppTextStyles.labelSmall : AppTextStyles.labelMedium)
            .copyWith(color: c.fg, fontWeight: FontWeight.w700),
      ),
    );
  }
}
