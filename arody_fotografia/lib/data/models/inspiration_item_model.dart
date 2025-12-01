import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/inspiration_item.dart';

part 'inspiration_item_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class InspirationItemModel extends InspirationItem {
  const InspirationItemModel({
    required super.id,
    required super.category,
    super.title,
    super.description,
    required super.imageUrl,
    required super.createdAt,
  });

  factory InspirationItemModel.fromJson(Map<String, dynamic> json) => _$InspirationItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$InspirationItemModelToJson(this);
}
