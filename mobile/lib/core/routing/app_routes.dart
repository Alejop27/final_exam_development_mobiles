// lib/core/routing/app_routes.dart
// Constantes de rutas. Centralizar evita typos y facilita refactor.

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home'; // Lista de usuarios
  static const String userDetail = '/user'; // /user/:email
  static const String inbox = '/inbox';
  static const String profile = '/profile';
}
