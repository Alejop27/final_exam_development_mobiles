// lib/features/splash/presentation/splash_screen.dart
// Pantalla inicial: muestra logo animado mientras decide si ir a login o home.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/session_provider.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/animated_logo.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _decideRoute();
    });
  }

  Future<void> _decideRoute() async {
    // Esperamos al menos 1.2s para que se vea el splash
    await Future.delayed(const Duration(milliseconds: 1200));

    // Esperamos a que la sesión termine de cargar
    final sessionAsync = ref.read(sessionProvider.future);
    final session = await sessionAsync;

    if (!mounted) return;

    if (session.isAuthenticated) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.heroDark),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AnimatedLogo(size: 120),
                const SizedBox(height: 32),
                Text('Mensajería', style: AppTextStyles.heroTitle),
                const SizedBox(height: 8),
                Text(
                  'Corporativa',
                  style: AppTextStyles.heroSubtitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 64),
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
