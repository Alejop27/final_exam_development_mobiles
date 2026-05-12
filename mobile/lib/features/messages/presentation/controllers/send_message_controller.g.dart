// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SendMessageController)
final sendMessageControllerProvider = SendMessageControllerProvider._();

final class SendMessageControllerProvider
    extends $NotifierProvider<SendMessageController, SendMessageState> {
  SendMessageControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'sendMessageControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$sendMessageControllerHash();

  @$internal
  @override
  SendMessageController create() => SendMessageController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SendMessageState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SendMessageState>(value),
    );
  }
}

String _$sendMessageControllerHash() =>
    r'22042f584e0717160ce0632f43ad8c47acc8d342';

abstract class _$SendMessageController extends $Notifier<SendMessageState> {
  SendMessageState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SendMessageState, SendMessageState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<SendMessageState, SendMessageState>,
        SendMessageState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
