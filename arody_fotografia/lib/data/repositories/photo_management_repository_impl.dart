import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/photo_management_repository.dart';

class PhotoManagementRepositoryImpl implements PhotoManagementRepository {
  final SupabaseClient _supabaseClient;

  PhotoManagementRepositoryImpl(this._supabaseClient);

  @override
  Future<void> uploadPhotos(
    String sessionId,
    List<File> photos, {
    Function(int current, int total)? onProgress,
  }) async {
    final total = photos.length;

    for (int i = 0; i < photos.length; i++) {
      final photo = photos[i];
      onProgress?.call(i + 1, total);

      // Generate a unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(photo.path);
      final filename = 'photo_${timestamp}_$i$extension';

      // Generate thumbnail
      final thumbnailBytes = await generateThumbnail(photo);

      // Upload full resolution
      final fullPath = '$sessionId/full/$filename';
      await _supabaseClient.storage.from('session-photos').uploadBinary(
            fullPath,
            await photo.readAsBytes(),
            fileOptions: FileOptions(
              contentType: _getMimeType(extension),
              upsert: false,
            ),
          );

      // Upload thumbnail
      final thumbnailPath = '$sessionId/thumbnails/$filename';
      await _supabaseClient.storage.from('session-photos').uploadBinary(
            thumbnailPath,
            thumbnailBytes,
            fileOptions: FileOptions(
              contentType: _getMimeType(extension),
              upsert: false,
            ),
          );

      // Register in database
      await _supabaseClient.from('session_assets').insert({
        'session_id': sessionId,
        'storage_path': thumbnailPath,
        'asset_type': 'final',
      });
    }
  }

  @override
  Future<Uint8List> generateThumbnail(File image, {int maxWidth = 400}) async {
    try {
      final result = await FlutterImageCompress.compressWithFile(
        image.absolute.path,
        minWidth: maxWidth,
        quality: 85,
      );

      if (result == null) {
        throw Exception('Failed to compress image');
      }

      return result;
    } catch (e) {
      throw Exception('Error generating thumbnail: $e');
    }
  }

  @override
  Future<void> deletePhoto(String assetId) async {
    try {
      // First, get the asset info to know the storage path
      final asset = await _supabaseClient
          .from('session_assets')
          .select('storage_path')
          .eq('id', assetId)
          .single();

      final storagePath = asset['storage_path'] as String;

      // Derive the full path from thumbnail path
      final fullPath = storagePath.replaceFirst('/thumbnails/', '/full/');

      // Delete from storage (both thumbnail and full)
      await _supabaseClient.storage.from('session-photos').remove([
        storagePath, // thumbnail
        fullPath, // full resolution
      ]);

      // Delete from database
      await _supabaseClient.from('session_assets').delete().eq('id', assetId);
    } catch (e) {
      throw Exception('Error deleting photo: $e');
    }
  }

  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}

