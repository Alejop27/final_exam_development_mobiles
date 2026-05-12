// lib/core/providers/active_tab_provider.dart
// Provider para controlar qué tab está activa en el HomeShell.
// Permite a otras partes de la app (ej: FCM tap) navegar a una tab específica.

import 'package:flutter_riverpod/flutter_riverpod.dart';

class _ActiveTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setTab(int index) => state = index;
}

/// Índice de la tab activa en el HomeShell. 0=Equipo, 1=Mensajes, 2=Perfil.
final activeTabProvider = NotifierProvider<_ActiveTabNotifier, int>(
  _ActiveTabNotifier.new,
);
