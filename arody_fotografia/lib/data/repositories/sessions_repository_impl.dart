import 'package:supabase_flutter/supabase_flutter.dart' hide Session;
import '../../domain/entities/session.dart';
import '../../domain/repositories/sessions_repository.dart';
import '../models/session_model.dart';

class SessionsRepositoryImpl implements SessionsRepository {
  final SupabaseClient _supabaseClient;

  SessionsRepositoryImpl(this._supabaseClient);

  @override
  Future<List<Session>> getSessions() async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    final response = await _supabaseClient
        .from('sessions')
        .select()
        .eq('client_id', userId)
        .order('session_date', ascending: false);

    return (response as List).map((e) => SessionModel.fromJson(e)).toList();
  }

  @override
  Future<Session> getSessionById(String id) async {
    final response = await _supabaseClient
        .from('sessions')
        .select()
        .eq('id', id)
        .single();

    return SessionModel.fromJson(response);
  }

  @override
  Future<void> createSession(Session session) async {
    final sessionModel = session as SessionModel;
    final json = sessionModel.toJson();
    
    // Remover el ID para que Supabase lo genere automáticamente
    json.remove('id');
    
    await _supabaseClient.from('sessions').insert(json);
  }
}
