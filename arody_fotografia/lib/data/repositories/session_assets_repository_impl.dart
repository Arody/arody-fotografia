import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../domain/entities/session_asset.dart';
import '../../domain/repositories/session_assets_repository.dart';
import '../models/session_asset_model.dart';

class SessionAssetsRepositoryImpl implements SessionAssetsRepository {
  final SupabaseClient _supabaseClient;

  SessionAssetsRepositoryImpl(this._supabaseClient);

  @override
  Future<List<SessionAsset>> getSessionAssets(String sessionId) async {
    try {
      final response = await _supabaseClient
          .from('session_assets')
          .select()
          .eq('session_id', sessionId)
          .order('created_at', ascending: true);

      print('📸 Found ${(response as List).length} assets for session $sessionId');

      return (response as List)
          .map((json) => SessionAssetModel.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error fetching session assets: $e');
      rethrow;
    }
  }

  @override
  Future<String> getAssetUrl(String storagePath, {bool thumbnail = true}) async {
    try {
      // Convert path to thumbnail or full based on parameter
      String path = storagePath;
      
      if (thumbnail && !storagePath.contains('/thumbnails/')) {
        // Convert full path to thumbnail path
        path = storagePath.replaceFirst('/full/', '/thumbnails/');
      } else if (!thumbnail && storagePath.contains('/thumbnails/')) {
        // Convert thumbnail path to full path
        path = storagePath.replaceFirst('/thumbnails/', '/full/');
      }

      print('🔗 Creating signed URL for: $path');

      // Create signed URL with 1 hour expiration
      final signedUrl = await _supabaseClient.storage
          .from('session-photos')
          .createSignedUrl(path, 3600); // 1 hour = 3600 seconds

      print('✅ Signed URL created: ${signedUrl.substring(0, 50)}...');
      return signedUrl;
    } catch (e) {
      print('❌ Error creating signed URL for $storagePath: $e');
      rethrow;
    }
  }

  @override
  Future<void> downloadAsset(String storagePath, String fileName) async {
    try {
      // Get full resolution URL
      final url = await getAssetUrl(storagePath, thumbnail: false);
      
      // Download the file
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode != 200) {
        throw Exception('Failed to download image');
      }

      // Get the downloads directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getDownloadsDirectory();
      }

      if (directory == null) {
        throw Exception('Could not access storage directory');
      }

      // Create file path
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      // Write the file
      await file.writeAsBytes(response.bodyBytes);
      
      // Note: For iOS/Android, you might want to use image_gallery_saver
      // to save to the photos gallery instead
    } catch (e) {
      throw Exception('Error downloading image: $e');
    }
  }
}

