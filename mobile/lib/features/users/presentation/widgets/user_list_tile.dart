// lib/features/users/presentation/widgets/user_list_tile.dart
// Tile de la lista de usuarios.
// IMPLEMENTA EL ADICIONAL 1 del enunciado: transición animada lista → detalle
// con OpenContainer del paquete `animations` (Container Transform).

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../auth/domain/entities/user.dart';
import '../screens/user_detail_screen.dart';
import 'job_title_chip.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    // OpenContainer = Container Transform pattern.
    // El "closedBuilder" es el ítem en lista; al tocarlo, se transforma
    // suavemente en la pantalla del "openBuilder" (UserDetailScreen).
    return OpenContainer<void>(
      transitionType: ContainerTransitionType.fadeThrough,
      transitionDuration: const Duration(milliseconds: 450),
      openElevation: 0,
      closedElevation: 0,
      closedColor: Colors.transparent,
      openColor: AppColors.backgroundLight,
      closedShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      // El detalle a mostrar al expandir.
      openBuilder: (context, _) => UserDetailScreen(email: user.email),
      // El cerrado: card en la lista.
      closedBuilder: (context, openContainer) {
        return InkWell(
          onTap: openContainer,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                UserAvatar(
                  fullName: user.fullName,
                  photoUrl: user.photoUrl,
                  size: 56,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: AppTextStyles.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      JobTitleChip(jobTitle: user.jobTitle, dense: true),
                    ],
                  ),
                ),
                const Icon(
                  LucideIcons.chevronRight,
                  size: 20,
                  color: AppColors.textMutedLight,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
