import 'package:equatable/equatable.dart';

class SessionAsset extends Equatable {
  final String id;
  final String sessionId;
  final String storagePath;
  final String assetType; // 'preview', 'final', 'bts'
  final DateTime? createdAt;

  const SessionAsset({
    required this.id,
    required this.sessionId,
    required this.storagePath,
    required this.assetType,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        sessionId,
        storagePath,
        assetType,
        createdAt,
      ];
}

