import 'package:equatable/equatable.dart';

class Session extends Equatable {
  final String id;
  final String clientId;
  final DateTime sessionDate;
  final String? location;
  final String sessionType;
  final String status;
  final String? notes;
  final DateTime? createdAt;

  const Session({
    required this.id,
    required this.clientId,
    required this.sessionDate,
    this.location,
    required this.sessionType,
    required this.status,
    this.notes,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, clientId, sessionDate, location, sessionType, status, notes, createdAt];
}
