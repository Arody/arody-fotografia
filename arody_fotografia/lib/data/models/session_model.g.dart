// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) => SessionModel(
  id: json['id'] as String,
  clientId: json['clientId'] as String,
  sessionDate: DateTime.parse(json['sessionDate'] as String),
  location: json['location'] as String?,
  sessionType: json['sessionType'] as String,
  status: json['status'] as String,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$SessionModelToJson(SessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'sessionDate': instance.sessionDate.toIso8601String(),
      'location': instance.location,
      'sessionType': instance.sessionType,
      'status': instance.status,
      'notes': instance.notes,
    };
