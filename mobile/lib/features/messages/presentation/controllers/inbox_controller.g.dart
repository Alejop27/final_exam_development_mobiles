// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Inbox)
final inboxProvider = InboxProvider._();

final class InboxProvider extends $AsyncNotifierProvider<Inbox, List<Message>> {
  InboxProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'inboxProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$inboxHash();

  @$internal
  @override
  Inbox create() => Inbox();
}

String _$inboxHash() => r'958cd6fe380f9541ba00e0084ed193b109ba5249';

abstract class _$Inbox extends $AsyncNotifier<List<Message>> {
  FutureOr<List<Message>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Message>>, List<Message>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Message>>, List<Message>>,
        AsyncValue<List<Message>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
