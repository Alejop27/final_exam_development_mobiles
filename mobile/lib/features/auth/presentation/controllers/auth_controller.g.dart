// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

final class AuthControllerProvider
    extends $NotifierProvider<AuthController, AuthControllerState> {
  AuthControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthControllerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthControllerState>(value),
    );
  }
}

String _$authControllerHash() => r'2d36251c789688e720db8b426bad26f573850870';

abstract class _$AuthController extends $Notifier<AuthControllerState> {
  AuthControllerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthControllerState, AuthControllerState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AuthControllerState, AuthControllerState>,
        AuthControllerState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
