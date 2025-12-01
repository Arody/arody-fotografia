// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payments_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paymentsRepositoryHash() =>
    r'57e448756ce0de2510a03cba7a0992b25babad16';

/// See also [paymentsRepository].
@ProviderFor(paymentsRepository)
final paymentsRepositoryProvider =
    AutoDisposeProvider<PaymentsRepository>.internal(
      paymentsRepository,
      name: r'paymentsRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$paymentsRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PaymentsRepositoryRef = AutoDisposeProviderRef<PaymentsRepository>;
String _$paymentsListHash() => r'e2f53bac84f21a377bbe787dc9f26eacaa7568ef';

/// See also [paymentsList].
@ProviderFor(paymentsList)
final paymentsListProvider = AutoDisposeFutureProvider<List<Payment>>.internal(
  paymentsList,
  name: r'paymentsListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paymentsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PaymentsListRef = AutoDisposeFutureProviderRef<List<Payment>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
