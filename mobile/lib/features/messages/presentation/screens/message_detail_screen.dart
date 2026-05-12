// lib/features/messages/presentation/screens/message_detail_screen.dart
// Detalle de un mensaje recibido. Hero card con remitente arriba + cuerpo abajo.

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../domain/entities/message.dart';

class MessageDetailScreen extends StatelessWidget {
  const MessageDetailScreen({required this.message, super.key});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // ──── Header con gradiente ────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
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
              background: DecoratedBox(
                decoration: const BoxDecoration(gradient: AppGradients.primary),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            UserAvatar(
                              fullName: message.sender.fullName,
                              photoUrl: message.sender.photoUrl,
                              size: 56,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'De',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color:
                                          Colors.white.withValues(alpha: 0.7),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    message.sender.fullName,
                                    style: AppTextStyles.titleMedium
                                        .copyWith(color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    message.sender.email,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color:
                                          Colors.white.withValues(alpha: 0.85),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ──── Cuerpo del mensaje ────
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                decoration: const BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Metadatos: cargo + fecha
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLightAlt,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            message.sender.jobTitle,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.textPrimaryLight,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(LucideIcons.clock,
                                size: 14, color: AppColors.textMutedLight),
                            const SizedBox(width: 4),
                            Text(
                              message.createdAt.toShortLabel(),
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.textMutedLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Título
                    Text(message.title, style: AppTextStyles.titleLarge),
                    const SizedBox(height: 16),

                    // Cuerpo
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: SelectableText(
                        message.body,
                        style: AppTextStyles.bodyLarge.copyWith(
                          height: 1.6,
                          color: AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tiempo relativo
                    Row(
                      children: [
                        const Icon(LucideIcons.history,
                            size: 14, color: AppColors.textMutedLight),
                        const SizedBox(width: 6),
                        Text(
                          message.createdAt.toRelativeLabel(),
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.textMutedLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
