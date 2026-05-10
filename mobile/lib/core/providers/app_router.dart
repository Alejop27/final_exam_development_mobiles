// lib/core/routing/app_router.dart
// Configuración de go_router con guards basados en sesión.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/session_provider.dart';
import '../../features/splash/presentation/splash_screen.dart';
import 'app_routes.dart';

/// Rutas placeholder para Fases 5-7. Las pantallas reales vienen después.
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          'Pantalla "$title"\n(se implementa en próximas fases)',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,

    // Redirect global basado en estado de sesión
    redirect: (context, state) {
      final session = ref.read(sessionProvider);
      final isAuth = session.valueOrNull?.isAuthenticated ?? false;

      final goingToAuthArea =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;
      final isSplash = state.matchedLocation == AppRoutes.splash;

      // En splash mientras carga: no redirigir
      if (isSplash) return null;

      // No auth y va a área protegida → login
      if (!isAuth && !goingToAuthArea) {
        return AppRoutes.login;
      }

      // Auth y va a login/register → home
      if (isAuth && goingToAuthArea) {
        return AppRoutes.home;
      }

      return null; // sin redirect
    },

    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const _PlaceholderScreen('Login'),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, __) => const _PlaceholderScreen('Registro'),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (_, __) => const _PlaceholderScreen('Home / Usuarios'),
      ),
      GoRoute(
        path: '${AppRoutes.userDetail}/:email',
        builder: (_, state) {
          final email = state.pathParameters['email'] ?? '';
          return _PlaceholderScreen('Perfil de $email');
        },
      ),
      GoRoute(
        path: AppRoutes.inbox,
        builder: (_, __) => const _PlaceholderScreen('Bandeja'),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (_, __) => const _PlaceholderScreen('Mi perfil'),
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Ruta no encontrada: ${state.matchedLocation}')),
    ),
  );
});
