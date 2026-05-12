// lib/features/users/presentation/screens/home_shell.dart
// Shell principal post-login: AppBar con avatar + botón logout, BottomNav 3 tabs.
// Tab 0 = Usuarios (real). Tabs 1 y 2 = placeholders para Fase 7.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/user_detail_controller.dart';
import 'users_list_screen.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final myProfileAsync = ref.watch(myProfileProvider);

    final pages = const [
      UsersListScreen(),
      _InboxPlaceholder(),
      _ProfilePlaceholder(),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
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
          _titleFor(_index),
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
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: _buildBottomNav(),
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

  Widget _buildBottomNav() {
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
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
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

// ──── Placeholders de tabs (Fase 7) ────

class _InboxPlaceholder extends StatelessWidget {
  const _InboxPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.inbox,
                size: 80, color: AppColors.textMutedLight),
            const SizedBox(height: 16),
            Text('Bandeja de mensajes', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Se implementa en Fase 7',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondaryLight),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfilePlaceholder extends ConsumerWidget {
  const _ProfilePlaceholder();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myProfileAsync = ref.watch(myProfileProvider);

    return myProfileAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(
        child: Text('Error: $err', style: AppTextStyles.bodyMedium),
      ),
      data: (user) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            UserAvatar(
              fullName: user.fullName,
              photoUrl: user.photoUrl,
              size: 120,
            ),
            const SizedBox(height: 16),
            Text(user.fullName, style: AppTextStyles.titleLarge),
            const SizedBox(height: 4),
            Text(
              user.email,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                children: [
                  _ProfileRow(
                    label: 'Cargo',
                    value: user.jobTitle,
                  ),
                  const Divider(color: AppColors.borderLight),
                  _ProfileRow(
                    label: 'Teléfono',
                    value: user.phoneNumber,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Versión completa de "Mi perfil" en Fase 7',
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textMutedLight),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryLight,
              )),
          Text(value,
              style: AppTextStyles.bodyMedium
                  .copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
