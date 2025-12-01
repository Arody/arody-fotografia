import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';

part 'profile_provider.g.dart';

@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepositoryImpl(Supabase.instance.client);
}

@riverpod
Future<Profile?> userProfile(Ref ref) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return null;

  final repository = ref.watch(profileRepositoryProvider);
  return repository.getProfile(userId);
}

@riverpod
class CreateProfile extends _$CreateProfile {
  @override
  FutureOr<void> build() {}

  Future<void> create(Profile profile) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(profileRepositoryProvider);
      await repository.createProfile(profile);
      ref.invalidate(userProfileProvider);
    });
  }
}

@riverpod
class UpdateProfile extends _$UpdateProfile {
  @override
  FutureOr<void> build() {}

  Future<void> updateProfile(Profile profile) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(profileRepositoryProvider);
      await repository.updateProfile(profile);
      ref.invalidate(userProfileProvider);
    });
  }
}

