// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_asset_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionAssetModel _$SessionAssetModelFromJson(Map<String, dynamic> json) =>
    SessionAssetModel(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      storagePath: json['storage_path'] as String,
      assetType: json['asset_type'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$SessionAssetModelToJson(SessionAssetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session_id': instance.sessionId,
      'storage_path': instance.storagePath,
      'asset_type': instance.assetType,
      'created_at': instance.createdAt?.toIso8601String(),
    };
