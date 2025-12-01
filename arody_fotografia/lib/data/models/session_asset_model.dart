import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/session_asset.dart';

part 'session_asset_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SessionAssetModel extends SessionAsset {
  const SessionAssetModel({
    required super.id,
    required super.sessionId,
    required super.storagePath,
    required super.assetType,
    super.createdAt,
  });

  factory SessionAssetModel.fromJson(Map<String, dynamic> json) => _$SessionAssetModelFromJson(json);

  Map<String, dynamic> toJson() => _$SessionAssetModelToJson(this);
}

