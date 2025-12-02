import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/photo_management_repository_impl.dart';
import '../../domain/repositories/photo_management_repository.dart';
import 'session_assets_provider.dart';

part 'photo_management_provider.g.dart';

/// Provider for the photo management repository
@riverpod
PhotoManagementRepository photoManagementRepository(Ref ref) {
  final supabase = Supabase.instance.client;
  return PhotoManagementRepositoryImpl(supabase);
}

/// State for photo upload progress
class PhotoUploadState {
  final bool isUploading;
  final int currentPhoto;
  final int totalPhotos;
  final String? error;

  const PhotoUploadState({
    this.isUploading = false,
    this.currentPhoto = 0,
    this.totalPhotos = 0,
    this.error,
  });

  PhotoUploadState copyWith({
    bool? isUploading,
    int? currentPhoto,
    int? totalPhotos,
    String? error,
  }) {
    return PhotoUploadState(
      isUploading: isUploading ?? this.isUploading,
      currentPhoto: currentPhoto ?? this.currentPhoto,
      totalPhotos: totalPhotos ?? this.totalPhotos,
      error: error ?? this.error,
    );
  }

  double get progress {
    if (totalPhotos == 0) return 0;
    return currentPhoto / totalPhotos;
  }
}

/// StateNotifier for managing photo upload
class PhotoUploadNotifier extends StateNotifier<PhotoUploadState> {
  final PhotoManagementRepository _repository;
  final Ref _ref;

  PhotoUploadNotifier(this._repository, this._ref)
      : super(const PhotoUploadState());

  Future<void> uploadPhotos(String sessionId, List<File> photos) async {
    state = PhotoUploadState(
      isUploading: true,
      totalPhotos: photos.length,
      currentPhoto: 0,
    );

    try {
      await _repository.uploadPhotos(
        sessionId,
        photos,
        onProgress: (current, total) {
          state = state.copyWith(
            currentPhoto: current,
            totalPhotos: total,
          );
        },
      );

      state = PhotoUploadState(
        isUploading: false,
        currentPhoto: photos.length,
        totalPhotos: photos.length,
      );

      // Invalidate session assets to refresh the gallery
      _ref.invalidate(sessionAssetsProvider);
    } catch (e) {
      state = PhotoUploadState(
        isUploading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> deletePhoto(String assetId) async {
    try {
      await _repository.deletePhoto(assetId);
      // Invalidate session assets to refresh the gallery
      _ref.invalidate(sessionAssetsProvider);
    } catch (e) {
      state = PhotoUploadState(error: e.toString());
    }
  }

  void reset() {
    state = const PhotoUploadState();
  }
}

/// Provider for photo upload state
@riverpod
class PhotoUpload extends _$PhotoUpload {
  @override
  PhotoUploadState build() {
    return const PhotoUploadState();
  }

  Future<void> uploadPhotos(String sessionId, List<File> photos) async {
    state = PhotoUploadState(
      isUploading: true,
      totalPhotos: photos.length,
      currentPhoto: 0,
    );

    try {
      final repository = ref.read(photoManagementRepositoryProvider);
      
      await repository.uploadPhotos(
        sessionId,
        photos,
        onProgress: (current, total) {
          state = state.copyWith(
            currentPhoto: current,
            totalPhotos: total,
          );
        },
      );

      state = PhotoUploadState(
        isUploading: false,
        currentPhoto: photos.length,
        totalPhotos: photos.length,
      );

      // Invalidate session assets to refresh the gallery
      ref.invalidate(sessionAssetsProvider);
    } catch (e) {
      state = PhotoUploadState(
        isUploading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> deletePhoto(String assetId) async {
    try {
      final repository = ref.read(photoManagementRepositoryProvider);
      await repository.deletePhoto(assetId);
      
      // Invalidate session assets to refresh the gallery
      ref.invalidate(sessionAssetsProvider);
    } catch (e) {
      state = PhotoUploadState(error: e.toString());
    }
  }

  void reset() {
    state = const PhotoUploadState();
  }
}

// Note: sessionAssetsProvider is imported from session_assets_provider.dart
// No forward reference needed here as we just import it

