// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier que mantiene la sesión y la persiste.

@ProviderFor(Session)
final sessionProvider = SessionProvider._();

/// Notifier que mantiene la sesión y la persiste.
final class SessionProvider
    extends $AsyncNotifierProvider<Session, SessionState> {
  /// Notifier que mantiene la sesión y la persiste.
  SessionProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'sessionProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$sessionHash();

  @$internal
  @override
  Session create() => Session();
}

String _$sessionHash() => r'8e8eece9827478110465a19224162651f19157e1';

/// Notifier que mantiene la sesión y la persiste.

abstract class _$Session extends $AsyncNotifier<SessionState> {
  FutureOr<SessionState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SessionState>, SessionState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<SessionState>, SessionState>,
        AsyncValue<SessionState>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
