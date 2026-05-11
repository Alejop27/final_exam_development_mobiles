// lib/features/auth/presentation/widgets/job_title_dropdown.dart
// Dropdown con los cargos sugeridos por el enunciado.

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class JobTitleDropdown extends StatelessWidget {
  const JobTitleDropdown({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String? value;
  final ValueChanged<String?> onChanged;

  // Lista del enunciado (slide 3): "auxiliar, técnico redes, servicios generales,
  // operador logístico, contador, subgerente, etc."
  static const List<String> options = [
    'Auxiliar',
    'Técnico de Redes',
    'Servicios Generales',
    'Operador Logístico',
    'Contador',
    'Subgerente',
    'Gerente',
    'Analista',
    'Asistente',
    'Otro',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      icon: const Icon(LucideIcons.chevronDown, size: 18),
      style: AppTextStyles.bodyLarge,
      decoration: const InputDecoration(
        labelText: 'Cargo',
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 16, right: 12),
          child: Icon(LucideIcons.briefcase,
              color: AppColors.textSecondaryLight, size: 20),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
      ),
      items: options
          .map((opt) => DropdownMenuItem<String>(
                value: opt,
                child: Text(opt),
              ))
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null || v.isEmpty ? 'Selecciona un cargo' : null,
    );
  }
}
