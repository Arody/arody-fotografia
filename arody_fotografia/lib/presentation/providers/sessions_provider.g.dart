// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sessions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionsRepositoryHash() =>
    r'5810518785a71f5a41add46f76aca9b7ceaf025e';

/// See also [sessionsRepository].
@ProviderFor(sessionsRepository)
final sessionsRepositoryProvider =
    AutoDisposeProvider<SessionsRepository>.internal(
      sessionsRepository,
      name: r'sessionsRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sessionsRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SessionsRepositoryRef = AutoDisposeProviderRef<SessionsRepository>;
String _$sessionsListHash() => r'3bf8a718d608e9018e97acf89027c06f3393353c';

/// See also [sessionsList].
@ProviderFor(sessionsList)
final sessionsListProvider = AutoDisposeFutureProvider<List<Session>>.internal(
  sessionsList,
  name: r'sessionsListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sessionsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SessionsListRef = AutoDisposeFutureProviderRef<List<Session>>;
String _$allSessionsListHash() => r'50a5607e1e401c0ecdb864850380f80a6bf08799';

/// See also [allSessionsList].
@ProviderFor(allSessionsList)
final allSessionsListProvider =
    AutoDisposeFutureProvider<List<Session>>.internal(
      allSessionsList,
      name: r'allSessionsListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$allSessionsListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllSessionsListRef = AutoDisposeFutureProviderRef<List<Session>>;
String _$sessionDetailHash() => r'67a2e483f3db0140288cf2486ba67b2b5d665489';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [sessionDetail].
@ProviderFor(sessionDetail)
const sessionDetailProvider = SessionDetailFamily();

/// See also [sessionDetail].
class SessionDetailFamily extends Family<AsyncValue<Session>> {
  /// See also [sessionDetail].
  const SessionDetailFamily();

  /// See also [sessionDetail].
  SessionDetailProvider call(String id) {
    return SessionDetailProvider(id);
  }

  @override
  SessionDetailProvider getProviderOverride(
    covariant SessionDetailProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sessionDetailProvider';
}

/// See also [sessionDetail].
class SessionDetailProvider extends AutoDisposeFutureProvider<Session> {
  /// See also [sessionDetail].
  SessionDetailProvider(String id)
    : this._internal(
        (ref) => sessionDetail(ref as SessionDetailRef, id),
        from: sessionDetailProvider,
        name: r'sessionDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sessionDetailHash,
        dependencies: SessionDetailFamily._dependencies,
        allTransitiveDependencies:
            SessionDetailFamily._allTransitiveDependencies,
        id: id,
      );

  SessionDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Session> Function(SessionDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SessionDetailProvider._internal(
        (ref) => create(ref as SessionDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Session> createElement() {
    return _SessionDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SessionDetailRef on AutoDisposeFutureProviderRef<Session> {
  /// The parameter `id` of this provider.
  String get id;
}

class _SessionDetailProviderElement
    extends AutoDisposeFutureProviderElement<Session>
    with SessionDetailRef {
  _SessionDetailProviderElement(super.provider);

  @override
  String get id => (origin as SessionDetailProvider).id;
}

String _$createSessionHash() => r'966b9a673f12d61b0aa358926187666b96389ede';

/// See also [CreateSession].
@ProviderFor(CreateSession)
final createSessionProvider =
    AutoDisposeAsyncNotifierProvider<CreateSession, void>.internal(
      CreateSession.new,
      name: r'createSessionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$createSessionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CreateSession = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
