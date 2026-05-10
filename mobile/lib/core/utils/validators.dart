// lib/core/utils/validators.dart
// Validadores reutilizables para formularios.

class Validators {
  Validators._();

  static String? required(
    String? value, [
    String message = 'Campo obligatorio',
  ]) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email obligatorio';
    final regex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
    if (!regex.hasMatch(value.trim())) return 'Email inválido';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Contraseña obligatoria';
    if (value.length < 6) return 'Mínimo 6 caracteres';
    if (value.length > 72) return 'Máximo 72 caracteres';
    return null;
  }

  static String? minLength(String? value, int min, [String? field]) {
    if (value == null || value.trim().length < min) {
      return '${field ?? "Campo"} debe tener al menos $min caracteres';
    }
    return null;
  }

  static String? phoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) return 'Teléfono obligatorio';
    if (value.trim().length < 7) return 'Teléfono inválido';
    if (value.trim().length > 20) return 'Teléfono inválido';
    return null;
  }
}
