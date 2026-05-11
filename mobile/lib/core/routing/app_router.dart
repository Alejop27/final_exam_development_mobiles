// lib/core/routing/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
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

class _HomePlaceholder extends ConsumerWidget {
  const _HomePlaceholder();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Reemplaza valueOrNull con when
    final session = ref.watch(sessionProvider);
    final userEmail =
        session is AsyncData<SessionState> ? session.value.userEmail : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.logOut),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.checkCircle2,
                  size: 80, color: Color(0xFF10B981)),
              const SizedBox(height: 24),
              Text('Sesión iniciada',
                  style: AppTextStyles.titleLarge, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(userEmail ?? '',
                  style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: 32),
              Text(
                'La lista de usuarios y la mensajería\nse implementan en Fases 6 y 7.',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(
          path: AppRoutes.register, builder: (_, __) => const RegisterScreen()),
      GoRoute(
          path: AppRoutes.home, builder: (_, __) => const _HomePlaceholder()),
      GoRoute(
        path: '${AppRoutes.userDetail}/:email',
        builder: (_, state) {
          final email = state.pathParameters['email'] ?? '';
          return _PlaceholderScreen('Perfil de $email');
        },
      ),
      GoRoute(
          path: AppRoutes.inbox,
          builder: (_, __) => const _PlaceholderScreen('Bandeja')),
      GoRoute(
          path: AppRoutes.profile,
          builder: (_, __) => const _PlaceholderScreen('Mi perfil')),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Ruta no encontrada: ${state.matchedLocation}')),
    ),
  );
});
