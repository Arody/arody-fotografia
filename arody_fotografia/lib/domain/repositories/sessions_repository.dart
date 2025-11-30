import '../entities/session.dart';

abstract class SessionsRepository {
  Future<List<Session>> getSessions();
  Future<Session> getSessionById(String id);
  Future<void> createSession(Session session);
}
