import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final SupabaseClient _supabaseClient;

  ProfileRepositoryImpl(this._supabaseClient);

  @override
  Future<Profile?> getProfile(String userId) async {
    try {
      final response = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;
      return ProfileModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> createProfile(Profile profile) async {
    final profileModel = profile as ProfileModel;
    final json = profileModel.toJson();
    
    // Remover campos que se generan automáticamente
    json.remove('created_at');
    json.remove('updated_at');
    
    await _supabaseClient.from('profiles').insert(json);
  }

  @override
  Future<void> updateProfile(Profile profile) async {
    final profileModel = profile as ProfileModel;
    final json = profileModel.toJson();
    
    // Remover campos que no deben actualizarse
    json.remove('id');
    json.remove('created_at');
    
    // Actualizar updated_at manualmente
    json['updated_at'] = DateTime.now().toIso8601String();
    
    await _supabaseClient
        .from('profiles')
        .update(json)
        .eq('id', profile.id);
  }
}

