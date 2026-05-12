// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userDetail)
final userDetailProvider = UserDetailFamily._();

final class UserDetailProvider
    extends $FunctionalProvider<AsyncValue<User>, User, FutureOr<User>>
    with $FutureModifier<User>, $FutureProvider<User> {
  UserDetailProvider._(
      {required UserDetailFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'userDetailProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userDetailHash();

  @override
  String toString() {
    return r'userDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<User> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<User> create(Ref ref) {
    final argument = this.argument as String;
    return userDetail(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userDetailHash() => r'f84471bd1d5b56a58f6ba41daad922d7ef2fc4bc';

final class UserDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<User>, String> {
  UserDetailFamily._()
      : super(
          retry: null,
          name: r'userDetailProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  UserDetailProvider call(
    String email,
  ) =>
      UserDetailProvider._(argument: email, from: this);

  @override
  String toString() => r'userDetailProvider';
}

/// Mi propio perfil. Se cachea aparte para el tab "Perfil".

@ProviderFor(myProfile)
final myProfileProvider = MyProfileProvider._();

/// Mi propio perfil. Se cachea aparte para el tab "Perfil".

final class MyProfileProvider
    extends $FunctionalProvider<AsyncValue<User>, User, FutureOr<User>>
    with $FutureModifier<User>, $FutureProvider<User> {
  /// Mi propio perfil. Se cachea aparte para el tab "Perfil".
  MyProfileProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'myProfileProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$myProfileHash();

  @$internal
  @override
  $FutureProviderElement<User> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<User> create(Ref ref) {
    return myProfile(ref);
  }
}

String _$myProfileHash() => r'7743845b77bd1df8ca0e1dcd1892006c5a5ae4d2';
