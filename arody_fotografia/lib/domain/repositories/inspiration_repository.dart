import '../entities/inspiration_item.dart';

abstract class InspirationRepository {
  Future<List<InspirationItem>> getInspirationItems();
  Future<List<String>> getCategories();
}
