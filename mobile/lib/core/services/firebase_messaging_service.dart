// lib/core/services/firebase_messaging_service.dart
// Servicio que obtiene el token FCM, lo cachea y escucha eventos del SDK.

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/secure_storage_service.dart';

/// Handler de mensajes en background. DEBE ser top-level (no método de clase).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // En background no hacemos nada activo: Firebase muestra la notificación nativa.
  // Si en el futuro necesitas procesamiento (badge, cache local), iría aquí.
  if (kDebugMode) {
    debugPrint(
      '[FCM background] ${message.messageId}: ${message.notification?.title}',
    );
  }
}

class FirebaseMessagingService {
  FirebaseMessagingService(this._storage);

  final SecureStorageService _storage;
  final _firebaseMessaging = FirebaseMessaging.instance;

  String? _currentToken;

  /// Token FCM actual (puede cambiar por refresh).
  String? get currentToken => _currentToken;

  /// Inicializa: pide permisos, obtiene token, escucha refresh y mensajes.
  /// Se llama una sola vez desde main.dart antes de runApp.
  Future<void> initialize() async {
    // 1) Permisos
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('[FCM] User denied notification permissions');
    }

    // 2) Obtener token
    _currentToken = await _firebaseMessaging.getToken();
    if (_currentToken != null) {
      await _storage.saveFcmToken(_currentToken!);
      debugPrint('[FCM] Token: $_currentToken');
    }

    // 3) Configurar handler de mensajes en background (top-level)
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 4) Listener de refresh: el token puede cambiar (reinstalación, restore, etc.)
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      _currentToken = newToken;
      await _storage.saveFcmToken(newToken);
      debugPrint('[FCM] Token refreshed: $newToken');
      // En Fase 5+ aquí también notificaremos al backend con el nuevo token.
    });

    // 5) Listener de mensajes con app en foreground
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint(
        '[FCM foreground] ${message.messageId}: '
        '${message.notification?.title} - ${message.notification?.body}',
      );
      // En Fase 7 mostraremos un in-app banner aquí.
    });

    // 6) Listener: usuario tocó la notificación con app en background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('[FCM tap from background] ${message.messageId}');
      // En Fase 7: navegar a /messages cuando esto pase.
    });

    // 7) Caso: app abierta desde TERMINATED via notificación
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('[FCM tap from terminated] ${initialMessage.messageId}');
      // En Fase 7: navegar a /messages.
    }
  }

  /// Obtiene el token FCM actual o lo refresca.
  Future<String?> getToken() async {
    _currentToken ??= await _firebaseMessaging.getToken();
    return _currentToken;
  }

  /// Borra el token (al hacer logout completo y querer dejar de recibir pushes).
  Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
    _currentToken = null;
  }
}

/// Provider del servicio FCM.
final firebaseMessagingServiceProvider = Provider<FirebaseMessagingService>((
  ref,
) {
  final storage = ref.watch(secureStorageProvider);
  return FirebaseMessagingService(storage);
});
