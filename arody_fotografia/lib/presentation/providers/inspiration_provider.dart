import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/inspiration_repository_impl.dart';
import '../../domain/entities/inspiration_item.dart';
import '../../domain/repositories/inspiration_repository.dart';

part 'inspiration_provider.g.dart';

@riverpod
InspirationRepository inspirationRepository(Ref ref) {
  return InspirationRepositoryImpl(Supabase.instance.client);
}

@riverpod
Future<List<InspirationItem>> inspirationList(Ref ref) async {
  final repository = ref.watch(inspirationRepositoryProvider);
  return repository.getInspirationItems();
}

@riverpod
Future<List<String>> inspirationCategories(Ref ref) async {
  final repository = ref.watch(inspirationRepositoryProvider);
  return repository.getCategories();
}
