// lib/core/services/fcm_app_handler.dart
// Conecta los listeners de FCM con la UI real: refresh, banner, deep link.

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/messages/presentation/controllers/inbox_controller.dart';
import '../../features/messages/presentation/widgets/in_app_notification_banner.dart';
import '../providers/active_tab_provider.dart';

class FcmAppHandler {
  FcmAppHandler({
    required this.ref,
    required this.navigatorKey,
  });

  final WidgetRef ref;
  final GlobalKey<NavigatorState> navigatorKey;

  void start() {
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageTap);
    FirebaseMessaging.instance.getInitialMessage().then((msg) {
      if (msg != null) _onMessageTap(msg);
    });
  }

  void _onForegroundMessage(RemoteMessage message) {
    final title = message.notification?.title ?? 'Nuevo mensaje';
    final body = message.notification?.body ?? '';

    ref.read(inboxProvider.notifier).refresh();

    final ctx = navigatorKey.currentContext;
    if (ctx != null) {
      InAppNotificationBanner.show(
        ctx,
        title: title,
        body: body,
        onTap: _goToInboxTab,
      );
    }
  }

  void _onMessageTap(RemoteMessage message) {
    ref.read(inboxProvider.notifier).refresh();
    _goToInboxTab();
  }

  void _goToInboxTab() {
    // Cambia la tab activa a Mensajes (índice 1)
    ref.read(activeTabProvider.notifier).setTab(1);
  }
}
