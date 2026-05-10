// lib/main.dart
// Bootstrap de la app:
// 1) Inicializar Flutter binding
// 2) Inicializar Firebase Core
// 3) Inicializar Firebase Messaging (token + listeners)
// 4) Inicializar locale para fechas
// 5) Levantar app con ProviderScope

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/config/app_config.dart';
import 'core/routing/app_router.dart';
import 'core/services/firebase_messaging_service.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Orientación: solo portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Locale para fechas en español
  await initializeDateFormatting('es_ES', null);

  // Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Container temprano de Riverpod para acceder a servicios antes de runApp
  final container = ProviderContainer();

  // Inicializar FCM (token + listeners)
  final fcmService = container.read(firebaseMessagingServiceProvider);
  await fcmService.initialize();

  runApp(UncontrolledProviderScope(container: container, child: const _App()));
}

class _App extends ConsumerWidget {
  const _App();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: router,
    );
  }
}

// Suprime warning del linter sobre el uso de SecureStorageService importado
// (se importa aquí solo para garantizar que el módulo se carga)
// ignore: unused_element
typedef _Unused = SecureStorageService;
