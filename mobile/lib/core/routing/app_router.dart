// lib/core/routing/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/session_provider.dart';
import '../../features/splash/presentation/splash_screen.dart';
import 'app_routes.dart';

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

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    _ref.listen(sessionProvider, (_, __) => notifyListeners());
  }

  final Ref _ref;

  bool get isAuthenticated {
    final async = _ref.read(sessionProvider);
    if (async is AsyncData<SessionState>) {
      return async.value.isAuthenticated;
    }
    return false;
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: notifier,
    redirect: (context, state) {
      final isAuth = notifier.isAuthenticated;

      final goingToAuthArea = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;
      final isSplash = state.matchedLocation == AppRoutes.splash;

      if (isSplash) return null;
      if (!isAuth && !goingToAuthArea) return AppRoutes.login;
      if (isAuth && goingToAuthArea) return AppRoutes.home;

      return null;
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
