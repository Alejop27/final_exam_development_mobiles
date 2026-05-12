// lib/features/users/presentation/screens/home_shell.dart
// Shell principal post-login. Tabs: Equipo / Mensajes / Perfil.
// Conecta listeners de FCM para refresh in-app + banner + deep-link.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/providers/active_tab_provider.dart';
import '../../../../core/services/fcm_app_handler.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../messages/presentation/screens/inbox_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../controllers/user_detail_controller.dart';
import 'users_list_screen.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  // Key separada para el navigator interno del overlay (banner FCM)
  final _shellNavigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FcmAppHandler(
        ref: ref,
        navigatorKey: _shellNavigatorKey,
      ).start();
    });
  }

  @override
  Widget build(BuildContext context) {
    final myProfileAsync = ref.watch(myProfileProvider);
    final activeTab = ref.watch(activeTabProvider);

    final pages = const [
      UsersListScreen(),
      InboxScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: activeTab == 2
          // En tab Perfil, el propio screen maneja header con hero.
          // Aquí sólo lo ocultamos para no duplicar.
          ? null
          : AppBar(
              backgroundColor: AppColors.backgroundLight,
              elevation: 0,
              leadingWidth: 64,
              leading: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: myProfileAsync.maybeWhen(
                  data: (user) => UserAvatar(
                    fullName: user.fullName,
                    photoUrl: user.photoUrl,
                    size: 40,
                  ),
                  orElse: () => const CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.surfaceLightAlt,
                  ),
                ),
              ),
              title: Text(
                _titleFor(activeTab),
                style: AppTextStyles.titleSmall,
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(LucideIcons.logOut, size: 22),
                  tooltip: 'Cerrar sesión',
                  onPressed: () => _confirmLogout(context),
                ),
                const SizedBox(width: 8),
              ],
            ),
      // Navigator interno para que el banner overlay tenga context correcto
      body: Navigator(
        key: _shellNavigatorKey,
        onGenerateRoute: (settings) {
          return MaterialPageRoute<void>(
            builder: (_) => IndexedStack(index: activeTab, children: pages),
            settings: settings,
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(activeTab),
    );
  }

  String _titleFor(int idx) {
    switch (idx) {
      case 0:
        return 'Equipo';
      case 1:
        return 'Mensajes';
      case 2:
        return 'Mi perfil';
      default:
        return '';
    }
  }

  Widget _buildBottomNav(int activeTab) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: NavigationBar(
          selectedIndex: activeTab,
          onDestinationSelected: (i) =>
              ref.read(activeTabProvider.notifier).setTab(i),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          indicatorColor: AppColors.primaryDeep.withValues(alpha: 0.12),
          height: 72,
          destinations: const [
            NavigationDestination(
              icon: Icon(LucideIcons.users, size: 22),
              selectedIcon: Icon(LucideIcons.users,
                  size: 22, color: AppColors.primaryDeep),
              label: 'Equipo',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.inbox, size: 22),
              selectedIcon: Icon(LucideIcons.inbox,
                  size: 22, color: AppColors.primaryDeep),
              label: 'Mensajes',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.user, size: 22),
              selectedIcon: Icon(LucideIcons.user,
                  size: 22, color: AppColors.primaryDeep),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accentRed,
            ),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (result == true && context.mounted) {
      await ref.read(authControllerProvider.notifier).logout();
    }
  }
}
