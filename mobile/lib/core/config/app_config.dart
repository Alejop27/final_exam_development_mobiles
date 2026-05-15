// lib/core/config/app_config.dart
// Configuración global de la app: URL del back-end, timeouts, etc.

class AppConfig {
  AppConfig._(); // Constructor privado: solo estáticos

  /// URL base del back-end. En producción debería leerse de --dart-define.
  ///
  /// Para desarrollo:
  /// - Android emulador: http://10.0.2.2:3000  (10.0.2.2 = localhost del host)
  /// - iOS simulador / Web: http://localhost:3000
  /// - Dispositivo Android físico: http://<IP_LOCAL_DEL_PC>:3000
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.152.178.23:3000',
  );

  /// Timeouts de red
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(
    seconds: 30,
  ); // Para subida de foto

  /// Nombre de la app
  static const String appName = 'Mensajería Corporativa';

  /// Versión visible
  static const String appVersion = '1.0.0';
}
