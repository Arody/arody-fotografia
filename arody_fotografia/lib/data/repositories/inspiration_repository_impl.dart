import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/inspiration_item.dart';
import '../../domain/repositories/inspiration_repository.dart';
import '../models/inspiration_item_model.dart';

class InspirationRepositoryImpl implements InspirationRepository {
  final SupabaseClient _supabaseClient;

  InspirationRepositoryImpl(this._supabaseClient);

  @override
  Future<List<InspirationItem>> getInspirationItems() async {
    final response = await _supabaseClient
        .from('inspiration_items')
        .select()
        .order('created_at', ascending: false);

    return (response as List).map((e) => InspirationItemModel.fromJson(e)).toList();
  }

  @override
  Future<List<String>> getCategories() async {
    final response = await _supabaseClient
        .from('inspiration_items')
        .select('category');

    final categories = (response as List)
        .map((e) => e['category'] as String)
        .toSet()
        .toList();
    
    categories.sort();
    return categories;
  }
}
