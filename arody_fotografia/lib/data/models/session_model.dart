import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/session.dart';

part 'session_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class SessionModel extends Session {
  const SessionModel({
    required super.id,
    required super.clientId,
    required super.sessionDate,
    super.location,
    required super.sessionType,
    required super.status,
    super.notes,
    super.createdAt,
    super.clientName,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    // Extraer el nombre del cliente si viene en la relación de profiles
    String? clientName;
    if (json['profiles'] != null && json['profiles'] is Map) {
      clientName = json['profiles']['full_name'] as String?;
    } else if (json['client_name'] != null) {
      clientName = json['client_name'] as String?;
    }

    return SessionModel(
      id: json['id'] as String,
      clientId: json['client_id'] as String,
      sessionDate: DateTime.parse(json['session_date'] as String),
      location: json['location'] as String?,
      sessionType: json['session_type'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      clientName: clientName,
    );
  }

  Map<String, dynamic> toJson() {
    final json = _$SessionModelToJson(this);
    // Remove clientName from toJson as it's not a database field
    json.remove('client_name');
    return json;
  }
}
