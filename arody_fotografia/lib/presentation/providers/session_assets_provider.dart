import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/session_assets_repository_impl.dart';
import '../../domain/entities/session_asset.dart';
import '../../domain/repositories/session_assets_repository.dart';

part 'session_assets_provider.g.dart';

// Provider for the repository instance
@riverpod
SessionAssetsRepository sessionAssetsRepository(Ref ref) {
  final supabase = Supabase.instance.client;
  return SessionAssetsRepositoryImpl(supabase);
}

// Provider to get assets for a specific session
@riverpod
Future<List<SessionAsset>> sessionAssets(
  Ref ref,
  String sessionId,
) async {
  final repository = ref.watch(sessionAssetsRepositoryProvider);
  return repository.getSessionAssets(sessionId);
}

// Provider to get asset URL
@riverpod
Future<String> assetUrl(
  Ref ref,
  String storagePath, {
  bool thumbnail = true,
}) async {
  final repository = ref.watch(sessionAssetsRepositoryProvider);
  return repository.getAssetUrl(storagePath, thumbnail: thumbnail);
}

