// lib/core/providers/session_provider.dart
// Estado global de sesión: tiene JWT? quién es el usuario actual?

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../storage/secure_storage_service.dart';

part 'session_provider.g.dart';

/// Estado simple de sesión.
class SessionState {
  const SessionState({
    required this.isAuthenticated,
    this.userEmail,
    this.accessToken,
  });

  final bool isAuthenticated;
  final String? userEmail;
  final String? accessToken;

  static const SessionState unauthenticated = SessionState(
    isAuthenticated: false,
  );

  SessionState copyWith({
    bool? isAuthenticated,
    String? userEmail,
    String? accessToken,
  }) {
    return SessionState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userEmail: userEmail ?? this.userEmail,
      accessToken: accessToken ?? this.accessToken,
    );
  }
}

/// Notifier que mantiene la sesión y la persiste.
@Riverpod(keepAlive: true)
class Session extends _$Session {
  @override
  Future<SessionState> build() async {
    // Al arrancar, intentamos recuperar sesión guardada
    final storage = ref.read(secureStorageProvider);
    final token = await storage.readAccessToken();
    final email = await storage.readCurrentUserEmail();

    if (token != null && email != null) {
      return SessionState(
        isAuthenticated: true,
        userEmail: email,
        accessToken: token,
      );
    }

    return SessionState.unauthenticated;
  }

  /// Login exitoso: persistir y actualizar estado.
  Future<void> setSession({
    required String email,
    required String accessToken,
  }) async {
    final storage = ref.read(secureStorageProvider);
    await storage.saveAccessToken(accessToken);
    await storage.saveCurrentUserEmail(email);

    state = AsyncValue.data(
      SessionState(
        isAuthenticated: true,
        userEmail: email,
        accessToken: accessToken,
      ),
    );
  }

  /// Logout: limpiar storage y volver a unauthenticated.
  Future<void> clear() async {
    final storage = ref.read(secureStorageProvider);
    await storage.clearAll();
    state = const AsyncValue.data(SessionState.unauthenticated);
  }
}
