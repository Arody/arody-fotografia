import '../entities/session.dart';

abstract class SessionsRepository {
  Future<List<Session>> getSessions();
  Future<List<Session>> getAllSessions(); // For admin - get all sessions
  Future<Session> getSessionById(String id);
  Future<void> createSession(Session session);
  Future<void> updateSessionStatus(String sessionId, String newStatus);
}
