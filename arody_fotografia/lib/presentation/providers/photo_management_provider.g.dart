// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_management_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$photoManagementRepositoryHash() =>
    r'9ff7d520899810311b1815509fa1708c18000522';

/// Provider for the photo management repository
///
/// Copied from [photoManagementRepository].
@ProviderFor(photoManagementRepository)
final photoManagementRepositoryProvider =
    AutoDisposeProvider<PhotoManagementRepository>.internal(
      photoManagementRepository,
      name: r'photoManagementRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$photoManagementRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PhotoManagementRepositoryRef =
    AutoDisposeProviderRef<PhotoManagementRepository>;
String _$photoUploadHash() => r'5349e3604e241c0dd5c0306e4e88416c369b0e4e';

/// Provider for photo upload state
///
/// Copied from [PhotoUpload].
@ProviderFor(PhotoUpload)
final photoUploadProvider =
    AutoDisposeNotifierProvider<PhotoUpload, PhotoUploadState>.internal(
      PhotoUpload.new,
      name: r'photoUploadProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$photoUploadHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PhotoUpload = AutoDisposeNotifier<PhotoUploadState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
