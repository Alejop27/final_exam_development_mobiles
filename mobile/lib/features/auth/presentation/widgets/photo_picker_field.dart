// lib/features/auth/presentation/widgets/photo_picker_field.dart
// Selector de foto de perfil con previsualización circular.

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';

class PhotoPickerField extends StatefulWidget {
  const PhotoPickerField({
    required this.onPhotoSelected,
    this.size = 140,
    super.key,
  });

  final void Function(File? photo) onPhotoSelected;
  final double size;

  @override
  State<PhotoPickerField> createState() => _PhotoPickerFieldState();
}

class _PhotoPickerFieldState extends State<PhotoPickerField> {
  File? _photo;
  final _picker = ImagePicker();

  Future<void> _pickFrom(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1024,
      );
      if (picked != null) {
        if (kIsWeb) {
          // En web no podemos crear File con dart:io. Para registro web,
          // tendríamos que usar bytes — fuera del alcance del enunciado (Android-first).
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Subida de foto en Web no soportada en esta versión'),
              ),
            );
          }
          return;
        }
        setState(() => _photo = File(picked.path));
        widget.onPhotoSelected(_photo);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo cargar la imagen: $e')),
        );
      }
    }
  }

  void _showSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(LucideIcons.camera,
                    color: AppColors.primaryDeep),
                title: Text('Tomar foto', style: AppTextStyles.bodyLarge),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickFrom(ImageSource.camera);
                },
              ),
              ListTile(
                leading:
                    const Icon(LucideIcons.image, color: AppColors.primaryDeep),
                title:
                    Text('Elegir de galería', style: AppTextStyles.bodyLarge),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickFrom(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _showSourceSheet,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                gradient: _photo == null ? AppGradients.primary : null,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDeep.withValues(alpha: 0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: _photo != null
                  ? ClipOval(child: Image.file(_photo!, fit: BoxFit.cover))
                  : const Icon(
                      LucideIcons.camera,
                      color: Colors.white,
                      size: 36,
                    ),
            ),
            if (_photo != null)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryDeep,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Icon(LucideIcons.pencil,
                      color: Colors.white, size: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
