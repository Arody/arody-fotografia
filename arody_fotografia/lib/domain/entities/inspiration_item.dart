import 'package:equatable/equatable.dart';

class InspirationItem extends Equatable {
  final String id;
  final String category;
  final String? title;
  final String? description;
  final String imageUrl;

  const InspirationItem({
    required this.id,
    required this.category,
    this.title,
    this.description,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, category, title, description, imageUrl];
}
