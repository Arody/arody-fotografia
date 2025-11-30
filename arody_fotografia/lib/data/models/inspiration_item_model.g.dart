// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspiration_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InspirationItemModel _$InspirationItemModelFromJson(
  Map<String, dynamic> json,
) => InspirationItemModel(
  id: json['id'] as String,
  category: json['category'] as String,
  title: json['title'] as String?,
  description: json['description'] as String?,
  imageUrl: json['imageUrl'] as String,
);

Map<String, dynamic> _$InspirationItemModelToJson(
  InspirationItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'category': instance.category,
  'title': instance.title,
  'description': instance.description,
  'imageUrl': instance.imageUrl,
};
