// lib/shared/widgets/gradient_background.dart
// Fondo con gradiente para pantallas hero (login, splash, perfil).

import 'package:flutter/material.dart';
import '../../core/theme/app_gradients.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({required this.child, this.gradient, super.key});

  final Widget child;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: gradient ?? AppGradients.primary),
      child: child,
    );
  }
}
