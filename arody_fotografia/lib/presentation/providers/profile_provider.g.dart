// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileRepositoryHash() => r'92ba83bf64f4951ffdafd443fabdba43e55db29b';

/// See also [profileRepository].
@ProviderFor(profileRepository)
final profileRepositoryProvider =
    AutoDisposeProvider<ProfileRepository>.internal(
      profileRepository,
      name: r'profileRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$profileRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfileRepositoryRef = AutoDisposeProviderRef<ProfileRepository>;
String _$userProfileHash() => r'95adc647d8fc17b707e4be1d3105db2b8c97f2f7';

/// See also [userProfile].
@ProviderFor(userProfile)
final userProfileProvider = AutoDisposeFutureProvider<Profile?>.internal(
  userProfile,
  name: r'userProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserProfileRef = AutoDisposeFutureProviderRef<Profile?>;
String _$createProfileHash() => r'469a5053a1a710dee94772eeedef915c731df176';

/// See also [CreateProfile].
@ProviderFor(CreateProfile)
final createProfileProvider =
    AutoDisposeAsyncNotifierProvider<CreateProfile, void>.internal(
      CreateProfile.new,
      name: r'createProfileProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$createProfileHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CreateProfile = AutoDisposeAsyncNotifier<void>;
String _$updateProfileHash() => r'9d076227cee97c09ec4106d2f22113545cd55bf0';

/// See also [UpdateProfile].
@ProviderFor(UpdateProfile)
final updateProfileProvider =
    AutoDisposeAsyncNotifierProvider<UpdateProfile, void>.internal(
      UpdateProfile.new,
      name: r'updateProfileProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$updateProfileHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UpdateProfile = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
