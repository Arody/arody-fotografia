// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentProfileHash() => r'969e979124f2664ef0217cf1bce175044b93c15c';

/// Provider to get the current user's profile
///
/// Copied from [currentProfile].
@ProviderFor(currentProfile)
final currentProfileProvider = AutoDisposeFutureProvider<Profile?>.internal(
  currentProfile,
  name: r'currentProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentProfileRef = AutoDisposeFutureProviderRef<Profile?>;
String _$isCurrentUserAdminHash() =>
    r'2e8e94f34e3ca1d6badfa69df2dae6da501c2d53';

/// Helper provider to check if current user is admin
///
/// Copied from [isCurrentUserAdmin].
@ProviderFor(isCurrentUserAdmin)
final isCurrentUserAdminProvider = AutoDisposeFutureProvider<bool>.internal(
  isCurrentUserAdmin,
  name: r'isCurrentUserAdminProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isCurrentUserAdminHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsCurrentUserAdminRef = AutoDisposeFutureProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
