// lib/core/routing/app_router.dart
// Configuración de go_router con guards basados en sesión.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/users/presentation/screens/home_shell.dart';
import '../../features/users/presentation/screens/user_detail_screen.dart';
import '../providers/session_provider.dart';
import '../theme/app_text_styles.dart';
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
          style: AppTextStyles.titleMedium,
        ),
      ),
    );
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterRefreshNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: notifier,
    redirect: (context, state) {
      final session = ref.read(sessionProvider);
      final isAuth = session.maybeWhen(
        data: (s) => s.isAuthenticated,
        orElse: () => false,
      );

      final goingToAuthArea = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;
      final isSplash = state.matchedLocation == AppRoutes.splash;

      if (isSplash) return null;
      if (!isAuth && !goingToAuthArea) return AppRoutes.login;
      if (isAuth && goingToAuthArea) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (_, __) => const HomeShell(),
      ),
      // La ruta /user/:email se sigue declarando para deep linking,
      // aunque la navegación normal va por OpenContainer (sin nombre).
      GoRoute(
        path: '${AppRoutes.userDetail}/:email',
        builder: (_, state) {
          final email = state.pathParameters['email'] ?? '';
          return UserDetailScreen(email: email);
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

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(this._ref) {
    _sub = _ref.listen<AsyncValue<SessionState>>(
      sessionProvider,
      (_, __) => notifyListeners(),
    );
  }

  final Ref _ref;
  late final ProviderSubscription<AsyncValue<SessionState>> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}
