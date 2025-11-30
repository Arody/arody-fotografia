import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/inspiration_item.dart';

part 'inspiration_item_model.g.dart';

@JsonSerializable()
class InspirationItemModel extends InspirationItem {
  const InspirationItemModel({
    required super.id,
    required super.category,
    super.title,
    super.description,
    @JsonKey(name: 'image_url') required super.imageUrl,
  });

  factory InspirationItemModel.fromJson(Map<String, dynamic> json) => _$InspirationItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$InspirationItemModelToJson(this);
}
