// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UsersList)
final usersListProvider = UsersListProvider._();

final class UsersListProvider
    extends $AsyncNotifierProvider<UsersList, List<User>> {
  UsersListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'usersListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$usersListHash();

  @$internal
  @override
  UsersList create() => UsersList();
}

String _$usersListHash() => r'50bb6eae2c6d15729ffbd2235db5148ac6dd5f28';

abstract class _$UsersList extends $AsyncNotifier<List<User>> {
  FutureOr<List<User>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<User>>, List<User>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<User>>, List<User>>,
        AsyncValue<List<User>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
