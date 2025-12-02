import 'dart:io';
import 'dart:typed_data';

abstract class PhotoManagementRepository {
  /// Upload multiple photos to a session
  /// [sessionId] - The session ID to upload photos to
  /// [photos] - List of image files to upload
  /// [onProgress] - Callback to report upload progress (current, total)
  Future<void> uploadPhotos(
    String sessionId,
    List<File> photos, {
    Function(int current, int total)? onProgress,
  });

  /// Generate a thumbnail from an image file
  /// Returns the thumbnail as bytes
  /// [image] - The source image file
  /// [maxWidth] - Maximum width of the thumbnail (default: 400)
  Future<Uint8List> generateThumbnail(File image, {int maxWidth = 400});

  /// Delete a photo (both full and thumbnail) from storage and database
  /// [assetId] - The ID of the session asset to delete
  Future<void> deletePhoto(String assetId);
}

