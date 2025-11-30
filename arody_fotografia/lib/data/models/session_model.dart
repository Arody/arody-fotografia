import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/session.dart';

part 'session_model.g.dart';

@JsonSerializable()
class SessionModel extends Session {
  const SessionModel({
    required super.id,
    @JsonKey(name: 'client_id') required super.clientId,
    @JsonKey(name: 'session_date') required super.sessionDate,
    super.location,
    @JsonKey(name: 'session_type') required super.sessionType,
    required super.status,
    super.notes,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) => _$SessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SessionModelToJson(this);
}
