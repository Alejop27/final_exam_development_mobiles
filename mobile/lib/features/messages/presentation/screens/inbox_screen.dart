// lib/features/messages/presentation/screens/inbox_screen.dart
// Bandeja de entrada. Reemplaza el _InboxPlaceholder.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import '../controllers/inbox_controller.dart';
import '../widgets/empty_inbox_state.dart';
import '../widgets/message_list_tile.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inboxAsync = ref.watch(inboxProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mensajes', style: AppTextStyles.displayMedium),
                        const SizedBox(height: 4),
                        inboxAsync.when(
                          data: (list) => Text(
                            list.isEmpty
                                ? 'Sin mensajes'
                                : '${list.length} ${list.length == 1 ? "mensaje" : "mensajes"}',
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
                    onPressed: () => ref.read(inboxProvider.notifier).refresh(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: inboxAsync.when(
                loading: () => ListView.builder(
                  itemCount: 6,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (_, __) => const ShimmerListTile(),
                ),
                error: (err, _) => _InboxError(
                  onRetry: () => ref.read(inboxProvider.notifier).refresh(),
                ),
                data: (messages) {
                  if (messages.isEmpty) return const EmptyInboxState();
                  return RefreshIndicator(
                    color: AppColors.primaryDeep,
                    onRefresh: () => ref.read(inboxProvider.notifier).refresh(),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
                      itemCount: messages.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 4),
                      itemBuilder: (context, index) {
                        return MessageListTile(message: messages[index]);
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

class _InboxError extends StatelessWidget {
  const _InboxError({required this.onRetry});
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
            Text('No se pudo cargar la bandeja',
                style: AppTextStyles.titleMedium),
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
