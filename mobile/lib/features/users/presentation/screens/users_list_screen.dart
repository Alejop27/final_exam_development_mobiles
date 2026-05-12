// lib/features/users/presentation/screens/users_list_screen.dart
// Lista de usuarios con shimmer, pull-to-refresh y entrada staggered.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import '../controllers/users_list_controller.dart';
import '../widgets/empty_users_state.dart';
import '../widgets/user_list_tile.dart';

class UsersListScreen extends ConsumerWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersListProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // ──── Header de sección ────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Equipo', style: AppTextStyles.displayMedium),
                        const SizedBox(height: 4),
                        usersAsync.when(
                          data: (list) => Text(
                            '${list.length} ${list.length == 1 ? "compañero" : "compañeros"}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                          loading: () => Text(
                            'Cargando…',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                          error: (_, __) => Text(
                            'No se pudo cargar',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.accentRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.refreshCw, size: 20),
                    tooltip: 'Refrescar',
                    onPressed: () =>
                        ref.read(usersListProvider.notifier).refresh(),
                  ),
                ],
              ),
            ),
            // ──── Contenido ────
            Expanded(
              child: usersAsync.when(
                loading: () => const _ShimmerList(),
                error: (err, _) => _ErrorState(
                  onRetry: () =>
                      ref.read(usersListProvider.notifier).refresh(),
                ),
                data: (users) {
                  if (users.isEmpty) return const EmptyUsersState();
                  return RefreshIndicator(
                    color: AppColors.primaryDeep,
                    onRefresh: () =>
                        ref.read(usersListProvider.notifier).refresh(),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding:
                          const EdgeInsets.fromLTRB(8, 8, 8, 24),
                      itemCount: users.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 4),
                      itemBuilder: (context, index) {
                        return _StaggeredAppearance(
                          index: index,
                          child: UserListTile(user: users[index]),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──── Shimmer mientras carga ────

class _ShimmerList extends StatelessWidget {
  const _ShimmerList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (_, __) => const ShimmerListTile(),
    );
  }
}

// ──── Error con retry ────

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.cloudOff,
                size: 64, color: AppColors.accentRed),
            const SizedBox(height: 16),
            Text('No se pudo cargar la lista',
                style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Verifica tu conexión e intenta de nuevo',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondaryLight),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(LucideIcons.refreshCw, size: 16),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

// ──── Aparición escalonada (staggered) por ítem ────

class _StaggeredAppearance extends StatefulWidget {
  const _StaggeredAppearance({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  State<_StaggeredAppearance> createState() => _StaggeredAppearanceState();
}

class _StaggeredAppearanceState extends State<_StaggeredAppearance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _offset = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    // Stagger: cada ítem entra con 60ms de delay sobre el anterior.
    Future.delayed(Duration(milliseconds: widget.index * 60), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}