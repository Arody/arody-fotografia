import '../entities/session_asset.dart';

abstract class SessionAssetsRepository {
  /// Get all assets for a specific session
  Future<List<SessionAsset>> getSessionAssets(String sessionId);
  
  /// Get a signed URL for an asset
  /// [storagePath] - The path in storage (e.g., "session-id/thumbnails/image.jpg")
  /// [thumbnail] - If true, returns thumbnail path, otherwise full resolution path
  Future<String> getAssetUrl(String storagePath, {bool thumbnail = true});
  
  /// Download an asset to the device
  /// [storagePath] - The path in storage
  /// [fileName] - The name to save the file as
  Future<void> downloadAsset(String storagePath, String fileName);
}

