// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) => SessionModel(
  id: json['id'] as String,
  clientId: json['client_id'] as String,
  sessionDate: DateTime.parse(json['session_date'] as String),
  location: json['location'] as String?,
  sessionType: json['session_type'] as String,
  status: json['status'] as String,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$SessionModelToJson(SessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'client_id': instance.clientId,
      'session_date': instance.sessionDate.toIso8601String(),
      'location': instance.location,
      'session_type': instance.sessionType,
      'status': instance.status,
      'notes': instance.notes,
    };
