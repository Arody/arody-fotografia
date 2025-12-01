import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/session.dart';

part 'session_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SessionModel extends Session {
  const SessionModel({
    required super.id,
    required super.clientId,
    required super.sessionDate,
    super.location,
    required super.sessionType,
    required super.status,
    super.notes,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) => _$SessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SessionModelToJson(this);
}
