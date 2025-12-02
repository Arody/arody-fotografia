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
  final String? clientName; // Nombre del cliente (para vista de admin)

  const Session({
    required this.id,
    required this.clientId,
    required this.sessionDate,
    this.location,
    required this.sessionType,
    required this.status,
    this.notes,
    this.createdAt,
    this.clientName,
  });

  Session copyWith({
    String? id,
    String? clientId,
    DateTime? sessionDate,
    String? location,
    String? sessionType,
    String? status,
    String? notes,
    DateTime? createdAt,
    String? clientName,
  }) {
    return Session(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      sessionDate: sessionDate ?? this.sessionDate,
      location: location ?? this.location,
      sessionType: sessionType ?? this.sessionType,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      clientName: clientName ?? this.clientName,
    );
  }

  @override
  List<Object?> get props => [id, clientId, sessionDate, location, sessionType, status, notes, createdAt, clientName];
}
