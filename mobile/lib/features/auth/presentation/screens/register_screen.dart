// lib/features/auth/presentation/screens/register_screen.dart
// Pantalla de Registro. Layout más largo (scrollable) con todos los campos del enunciado.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/job_title_dropdown.dart';
import '../widgets/photo_picker_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String? _jobTitle;
  File? _photo;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _fullNameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_photo == null) {
      context.showSnackError('Debes seleccionar una foto de perfil');
      return;
    }

    FocusScope.of(context).unfocus();

    await ref.read(authControllerProvider.notifier).register(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
          fullName: _fullNameCtrl.text.trim(),
          phoneNumber: _phoneCtrl.text.trim(),
          jobTitle: _jobTitle!,
          photo: _photo,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthControllerState>(authControllerProvider, (prev, curr) {
      if (curr is AuthError) {
        context.showSnackError(curr.message);
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            ref.read(authControllerProvider.notifier).resetState();
          }
        });
      }
    });

    final state = ref.watch(authControllerProvider);
    final isLoading = state is AuthLoading;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.pop(),
        ),
        title: const Text('Crear cuenta'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ──── Header con gradiente ────
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: AppGradients.primary,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryDeep.withValues(alpha: 0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Únete al equipo',
                        style: AppTextStyles.titleLarge
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Completa tus datos para crear tu cuenta',
                        style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.85)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ──── Foto ────
                PhotoPickerField(
                  onPhotoSelected: (file) => setState(() => _photo = file),
                ),
                const SizedBox(height: 8),
                Text(
                  'Foto de perfil',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textSecondaryLight),
                ),
                const SizedBox(height: 28),

                // ──── Nombre completo ────
                AuthTextField(
                  controller: _fullNameCtrl,
                  label: 'Nombre completo',
                  icon: LucideIcons.user,
                  textInputAction: TextInputAction.next,
                  validator: (v) => Validators.minLength(v, 2, 'Nombre'),
                ),
                const SizedBox(height: 16),

                // ──── Email ────
                AuthTextField(
                  controller: _emailCtrl,
                  label: 'Email',
                  icon: LucideIcons.mail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),

                // ──── Teléfono ────
                AuthTextField(
                  controller: _phoneCtrl,
                  label: 'Número telefónico',
                  icon: LucideIcons.phone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: Validators.phoneNumber,
                ),
                const SizedBox(height: 16),

                // ──── Cargo ────
                JobTitleDropdown(
                  value: _jobTitle,
                  onChanged: (v) => setState(() => _jobTitle = v),
                ),
                const SizedBox(height: 16),

                // ──── Contraseña ────
                AuthTextField(
                  controller: _passwordCtrl,
                  label: 'Contraseña',
                  icon: LucideIcons.lock,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _onSubmit(),
                  validator: Validators.password,
                  suffix: IconButton(
                    icon: Icon(
                      _obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                      size: 18,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 32),

                // ──── Botón ────
                PrimaryButton(
                  label: 'Crear cuenta',
                  icon: LucideIcons.userPlus,
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _onSubmit,
                ),
                const SizedBox(height: 16),

                // ──── Link a login ────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿Ya tienes cuenta?',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textSecondaryLight),
                    ),
                    TextButton(
                      onPressed: isLoading ? null : () => context.pop(),
                      child: const Text('Iniciar sesión'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
