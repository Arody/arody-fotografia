// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_assets_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionAssetsRepositoryHash() =>
    r'37e3abd58c1226fc95c9fa5f0ba04706e910fbfc';

/// See also [sessionAssetsRepository].
@ProviderFor(sessionAssetsRepository)
final sessionAssetsRepositoryProvider =
    AutoDisposeProvider<SessionAssetsRepository>.internal(
      sessionAssetsRepository,
      name: r'sessionAssetsRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sessionAssetsRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SessionAssetsRepositoryRef =
    AutoDisposeProviderRef<SessionAssetsRepository>;
String _$sessionAssetsHash() => r'36e7f1623bee5d12bdd32f9563da1786edebd7ad';

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

/// See also [sessionAssets].
@ProviderFor(sessionAssets)
const sessionAssetsProvider = SessionAssetsFamily();

/// See also [sessionAssets].
class SessionAssetsFamily extends Family<AsyncValue<List<SessionAsset>>> {
  /// See also [sessionAssets].
  const SessionAssetsFamily();

  /// See also [sessionAssets].
  SessionAssetsProvider call(String sessionId) {
    return SessionAssetsProvider(sessionId);
  }

  @override
  SessionAssetsProvider getProviderOverride(
    covariant SessionAssetsProvider provider,
  ) {
    return call(provider.sessionId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sessionAssetsProvider';
}

/// See also [sessionAssets].
class SessionAssetsProvider
    extends AutoDisposeFutureProvider<List<SessionAsset>> {
  /// See also [sessionAssets].
  SessionAssetsProvider(String sessionId)
    : this._internal(
        (ref) => sessionAssets(ref as SessionAssetsRef, sessionId),
        from: sessionAssetsProvider,
        name: r'sessionAssetsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sessionAssetsHash,
        dependencies: SessionAssetsFamily._dependencies,
        allTransitiveDependencies:
            SessionAssetsFamily._allTransitiveDependencies,
        sessionId: sessionId,
      );

  SessionAssetsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sessionId,
  }) : super.internal();

  final String sessionId;

  @override
  Override overrideWith(
    FutureOr<List<SessionAsset>> Function(SessionAssetsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SessionAssetsProvider._internal(
        (ref) => create(ref as SessionAssetsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sessionId: sessionId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<SessionAsset>> createElement() {
    return _SessionAssetsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionAssetsProvider && other.sessionId == sessionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sessionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SessionAssetsRef on AutoDisposeFutureProviderRef<List<SessionAsset>> {
  /// The parameter `sessionId` of this provider.
  String get sessionId;
}

class _SessionAssetsProviderElement
    extends AutoDisposeFutureProviderElement<List<SessionAsset>>
    with SessionAssetsRef {
  _SessionAssetsProviderElement(super.provider);

  @override
  String get sessionId => (origin as SessionAssetsProvider).sessionId;
}

String _$assetUrlHash() => r'0f19dc7a0e6b7423aebfaf89afc1502347dc05ae';

/// See also [assetUrl].
@ProviderFor(assetUrl)
const assetUrlProvider = AssetUrlFamily();

/// See also [assetUrl].
class AssetUrlFamily extends Family<AsyncValue<String>> {
  /// See also [assetUrl].
  const AssetUrlFamily();

  /// See also [assetUrl].
  AssetUrlProvider call(String storagePath, {bool thumbnail = true}) {
    return AssetUrlProvider(storagePath, thumbnail: thumbnail);
  }

  @override
  AssetUrlProvider getProviderOverride(covariant AssetUrlProvider provider) {
    return call(provider.storagePath, thumbnail: provider.thumbnail);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'assetUrlProvider';
}

/// See also [assetUrl].
class AssetUrlProvider extends AutoDisposeFutureProvider<String> {
  /// See also [assetUrl].
  AssetUrlProvider(String storagePath, {bool thumbnail = true})
    : this._internal(
        (ref) =>
            assetUrl(ref as AssetUrlRef, storagePath, thumbnail: thumbnail),
        from: assetUrlProvider,
        name: r'assetUrlProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$assetUrlHash,
        dependencies: AssetUrlFamily._dependencies,
        allTransitiveDependencies: AssetUrlFamily._allTransitiveDependencies,
        storagePath: storagePath,
        thumbnail: thumbnail,
      );

  AssetUrlProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storagePath,
    required this.thumbnail,
  }) : super.internal();

  final String storagePath;
  final bool thumbnail;

  @override
  Override overrideWith(
    FutureOr<String> Function(AssetUrlRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssetUrlProvider._internal(
        (ref) => create(ref as AssetUrlRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storagePath: storagePath,
        thumbnail: thumbnail,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _AssetUrlProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetUrlProvider &&
        other.storagePath == storagePath &&
        other.thumbnail == thumbnail;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storagePath.hashCode);
    hash = _SystemHash.combine(hash, thumbnail.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AssetUrlRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `storagePath` of this provider.
  String get storagePath;

  /// The parameter `thumbnail` of this provider.
  bool get thumbnail;
}

class _AssetUrlProviderElement extends AutoDisposeFutureProviderElement<String>
    with AssetUrlRef {
  _AssetUrlProviderElement(super.provider);

  @override
  String get storagePath => (origin as AssetUrlProvider).storagePath;
  @override
  bool get thumbnail => (origin as AssetUrlProvider).thumbnail;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
