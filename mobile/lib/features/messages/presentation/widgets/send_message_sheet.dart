// lib/features/messages/presentation/widgets/send_message_sheet.dart
// Bottom sheet de envío de mensaje. Spring animation al abrirse.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../auth/domain/entities/user.dart';
import '../controllers/send_message_controller.dart';

/// Helper: abre el sheet correctamente con todas las opciones.
Future<void> showSendMessageSheet(
  BuildContext context, {
  required User recipient,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true, // Importante para que el teclado no oculte campos
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (ctx) => SendMessageSheet(recipient: recipient),
  );
}

class SendMessageSheet extends ConsumerStatefulWidget {
  const SendMessageSheet({required this.recipient, super.key});

  final User recipient;

  @override
  ConsumerState<SendMessageSheet> createState() => _SendMessageSheetState();
}

class _SendMessageSheetState extends ConsumerState<SendMessageSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  final _bodyFocus = FocusNode();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    _bodyFocus.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    await ref.read(sendMessageControllerProvider.notifier).send(
          recipientEmail: widget.recipient.email,
          title: _titleCtrl.text.trim(),
          body: _bodyCtrl.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    // Escuchar resultados
    ref.listen<SendMessageState>(sendMessageControllerProvider, (prev, curr) {
      if (curr is SendSuccess) {
        // Insertar el mensaje en la bandeja propia (opcional: el remitente puede tenerlo en su "sent")
        // ─ Pero en esta app sin tab "enviados" en bandeja, no aplicamos insertLocally
        // Mostrar feedback contextual
        Navigator.of(context).pop();
        final r = curr.result;
        if (r.noDevices) {
          context.showSnackSuccess(
            'Mensaje guardado. ${widget.recipient.fullName.split(' ').first} no tiene dispositivos activos.',
          );
        } else if (r.devicesDelivered == r.devicesTargeted) {
          context.showSnackSuccess(
            'Mensaje enviado a ${r.devicesDelivered} dispositivo${r.devicesDelivered == 1 ? "" : "s"}',
          );
        } else if (r.devicesDelivered > 0) {
          context.showSnackSuccess(
            'Mensaje enviado a ${r.devicesDelivered} de ${r.devicesTargeted} dispositivos',
          );
        } else {
          context.showSnackError(
            'Mensaje guardado pero no se pudo notificar (intenta más tarde)',
          );
        }
        ref.read(sendMessageControllerProvider.notifier).reset();
      } else if (curr is SendError) {
        context.showSnackError(curr.message);
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            ref.read(sendMessageControllerProvider.notifier).reset();
          }
        });
      }
    });

    final state = ref.watch(sendMessageControllerProvider);
    final isLoading = state is SendLoading;

    // Padding inferior dinámico para que el teclado no oculte el botón
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              children: [
                // ─── Drag handle ───
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // ─── Header con destinatario ───
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Row(
                    children: [
                      UserAvatar(
                        fullName: widget.recipient.fullName,
                        photoUrl: widget.recipient.photoUrl,
                        size: 44,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Para',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.textSecondaryLight,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.recipient.fullName,
                              style: AppTextStyles.titleSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.x, size: 22),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),

                const Divider(color: AppColors.borderLight, height: 1),

                // ─── Form ───
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _titleCtrl,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) => _bodyFocus.requestFocus(),
                            maxLength: 200,
                            decoration: const InputDecoration(
                              labelText: 'Asunto',
                              counterText: '',
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 16, right: 12),
                                child: Icon(LucideIcons.type,
                                    color: AppColors.textSecondaryLight,
                                    size: 20),
                              ),
                              prefixIconConstraints: BoxConstraints(
                                minWidth: 0,
                                minHeight: 0,
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'El asunto es obligatorio';
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _bodyCtrl,
                            focusNode: _bodyFocus,
                            maxLines: 6,
                            minLines: 4,
                            maxLength: 5000,
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              labelText: 'Mensaje',
                              alignLabelWithHint: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'El mensaje no puede estar vacío';
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(5000),
                            ],
                          ),
                          const SizedBox(height: 24),
                          PrimaryButton(
                            label: 'Enviar mensaje',
                            icon: LucideIcons.send,
                            isLoading: isLoading,
                            onPressed: isLoading ? null : _send,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
