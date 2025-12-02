import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Session;
import '../../data/repositories/sessions_repository_impl.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/sessions_repository.dart';

part 'sessions_provider.g.dart';

@riverpod
SessionsRepository sessionsRepository(Ref ref) {
  return SessionsRepositoryImpl(Supabase.instance.client);
}

@riverpod
Future<List<Session>> sessionsList(Ref ref) async {
  final repository = ref.watch(sessionsRepositoryProvider);
  return repository.getSessions();
}

@riverpod
Future<List<Session>> allSessionsList(Ref ref) async {
  final repository = ref.watch(sessionsRepositoryProvider);
  return repository.getAllSessions();
}

@riverpod
Future<Session> sessionDetail(Ref ref, String id) async {
  final repository = ref.watch(sessionsRepositoryProvider);
  return repository.getSessionById(id);
}

@riverpod
class CreateSession extends _$CreateSession {
  @override
  FutureOr<void> build() {}

  Future<void> create(Session session) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(sessionsRepositoryProvider);
      await repository.createSession(session);
      ref.invalidate(sessionsListProvider);
    });
  }
}
