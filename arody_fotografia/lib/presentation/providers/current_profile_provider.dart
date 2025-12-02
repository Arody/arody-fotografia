import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/profile_model.dart';
import '../../domain/entities/profile.dart';

part 'current_profile_provider.g.dart';

/// Provider to get the current user's profile
@riverpod
Future<Profile?> currentProfile(Ref ref) async {
  final supabase = Supabase.instance.client;
  final userId = supabase.auth.currentUser?.id;

  if (userId == null) return null;

  try {
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    return ProfileModel.fromJson(response);
  } catch (e) {
    // If profile doesn't exist, return null
    return null;
  }
}

/// Helper provider to check if current user is admin
@riverpod
Future<bool> isCurrentUserAdmin(Ref ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  return profile?.isAdmin ?? false;
}

