// lib/features/users/presentation/screens/user_detail_screen.dart
// Detalle de un usuario: hero con foto grande + atributos + FAB de mensaje.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import '../../../auth/domain/entities/user.dart';
import '../controllers/user_detail_controller.dart';
import '../widgets/job_title_chip.dart';

class UserDetailScreen extends ConsumerWidget {
  const UserDetailScreen({required this.email, super.key});

  final String email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(userDetailProvider(email));

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: asyncUser.when(
        loading: () => const _DetailSkeleton(),
        error: (err, _) => _DetailError(
          onRetry: () => ref.invalidate(userDetailProvider(email)),
        ),
        data: (user) => _DetailContent(user: user),
      ),
    );
  }
}

// ──── Contenido principal ────

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ──── Hero con foto y back button ────
        SliverAppBar(
          expandedHeight: 320,
          pinned: true,
          stretch: true,
          backgroundColor: AppColors.primaryDeep,
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: Material(
              color: Colors.black.withValues(alpha: 0.3),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [
              StretchMode.zoomBackground,
              StretchMode.fadeTitle,
            ],
            background: _HeroPhoto(user: user),
          ),
        ),

        // ──── Bloque de atributos ────
        SliverToBoxAdapter(
          child: Transform.translate(
            offset: const Offset(0, -32),
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              decoration: const BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre + cargo
                  Text(user.fullName, style: AppTextStyles.titleLarge),
                  const SizedBox(height: 8),
                  JobTitleChip(jobTitle: user.jobTitle),
                  const SizedBox(height: 24),

                  // Atributos
                  _AttributeRow(
                    icon: LucideIcons.mail,
                    label: 'Email',
                    value: user.email,
                  ),
                  const _Divider(),
                  _AttributeRow(
                    icon: LucideIcons.phone,
                    label: 'Teléfono',
                    value: user.phoneNumber,
                  ),
                  const _Divider(),
                  _AttributeRow(
                    icon: LucideIcons.briefcase,
                    label: 'Cargo',
                    value: user.jobTitle,
                  ),
                  const SizedBox(height: 32),

                  // Botón de envío de mensaje (lleva al modal de Fase 7)
                  PrimaryButton(
                    label: 'Enviar mensaje',
                    icon: LucideIcons.send,
                    onPressed: () => _openSendMessage(context, user),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openSendMessage(BuildContext context, User recipient) {
    // En Fase 7 esto abrirá el bottom sheet real de envío de mensaje.
    // Por ahora, placeholder:
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Envío de mensaje a ${recipient.fullName} se implementa en Fase 7',
        ),
      ),
    );
  }
}

// ──── Foto hero ────

class _HeroPhoto extends StatelessWidget {
  const _HeroPhoto({required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Foto o gradiente de fallback
        if (user.photoUrl != null && user.photoUrl!.isNotEmpty)
          CachedNetworkImage(
            imageUrl: user.photoUrl!,
            fit: BoxFit.cover,
            placeholder: (_, __) => const DecoratedBox(
              decoration: BoxDecoration(gradient: AppGradients.primary),
            ),
            errorWidget: (_, __, ___) => const _InitialsHero(),
          )
        else
          _InitialsHero(initials: user.initials),

        // Overlay degradado para que el back button + AppBar sean legibles
        DecoratedBox(
          decoration: BoxDecoration(gradient: AppGradients.imageOverlay),
        ),
      ],
    );
  }
}

class _InitialsHero extends StatelessWidget {
  const _InitialsHero({this.initials = '?'});
  final String initials;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppGradients.primary),
      child: Center(
        child: Text(
          initials,
          style: AppTextStyles.heroTitle.copyWith(fontSize: 96),
        ),
      ),
    );
  }
}

// ──── Fila de atributo ────

class _AttributeRow extends StatelessWidget {
  const _AttributeRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryDeep.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryDeep, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: AppColors.borderLight);
  }
}

// ──── Skeleton mientras carga ────

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const ShimmerLoader(
              width: double.infinity, height: 320, borderRadius: 0),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerLoader(width: 200, height: 28),
                const SizedBox(height: 12),
                const ShimmerLoader(width: 100, height: 20, borderRadius: 12),
                const SizedBox(height: 32),
                ...List.generate(
                    3,
                    (_) => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child:
                              ShimmerLoader(width: double.infinity, height: 48),
                        )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailError extends StatelessWidget {
  const _DetailError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.userX,
                  size: 64, color: AppColors.accentRed),
              const SizedBox(height: 16),
              Text('No se pudo cargar el perfil',
                  style: AppTextStyles.titleMedium),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(LucideIcons.refreshCw, size: 16),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
