// lib/features/auth/domain/entities/user.dart
// Entidad pura del dominio. NO depende de Flutter ni de paquetes externos.
// Representa al usuario tal como vive en la lógica de negocio.

class User {
  const User({
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.jobTitle,
    required this.authProvider,
    required this.createdAt,
    this.photoUrl,
  });

  final String email;
  final String fullName;
  final String? photoUrl;
  final String phoneNumber;
  final String jobTitle;
  final String authProvider;
  final DateTime createdAt;

  /// Genera las iniciales del usuario para fallback de avatar.
  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  bool get isFacebookUser => authProvider == 'FACEBOOK';

  User copyWith({
    String? email,
    String? fullName,
    String? photoUrl,
    String? phoneNumber,
    String? jobTitle,
    String? authProvider,
    DateTime? createdAt,
  }) {
    return User(
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      jobTitle: jobTitle ?? this.jobTitle,
      authProvider: authProvider ?? this.authProvider,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is User && other.email == email;

  @override
  int get hashCode => email.hashCode;
}
