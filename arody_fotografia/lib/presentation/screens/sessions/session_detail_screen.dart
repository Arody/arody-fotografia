import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/sessions_provider.dart';
import '../../providers/session_assets_provider.dart' as assets_provider;
import '../../providers/current_profile_provider.dart';
import '../../providers/photo_management_provider.dart';
import '../../common/image_viewer.dart';
import '../../common/photo_upload_dialog.dart';
import '../../../domain/entities/session.dart';

class SessionDetailScreen extends ConsumerWidget {
  final String sessionId;

  const SessionDetailScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(sessionDetailProvider(sessionId));
    final isAdminAsync = ref.watch(isCurrentUserAdminProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalles de la Sesión')),
      floatingActionButton: isAdminAsync.when(
        data: (isAdmin) => isAdmin
            ? FloatingActionButton.extended(
                onPressed: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    builder: (context) =>
                        PhotoUploadDialog(sessionId: sessionId),
                  );
                  if (result == true && context.mounted) {
                    // Refresh the gallery
                    ref.invalidate(
                      assets_provider.sessionAssetsProvider(sessionId),
                    );
                  }
                },
                icon: const Icon(Icons.upload),
                label: const Text('Cargar Fotos'),
              )
            : null,
        loading: () => null,
        error: (_, __) => null,
      ),
      body: sessionAsync.when(
        data: (session) {
          final dateFormat = DateFormat('EEEE, d ' 'de' ' MMMM, yyyy', 'es');
          final timeFormat = DateFormat('h:mm a');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.sessionType.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 8),
                    Text(dateFormat.format(session.sessionDate.toLocal())),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 8),
                    Text(timeFormat.format(session.sessionDate.toLocal())),
                  ],
                ),
                if (session.location != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 8),
                      Text(session.location!),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Estado',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    isAdminAsync.when(
                      data: (isAdmin) => isAdmin
                          ? TextButton.icon(
                              onPressed: () =>
                                  _showStatusDialog(ref, context, session),
                              icon: const Icon(Icons.edit, size: 16),
                              label: const Text('Cambiar'),
                            )
                          : const SizedBox.shrink(),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
                Text(_getStatusText(session.status)),
                const SizedBox(height: 24),
                if (session.notes != null) ...[
                  const Text(
                    'Notas',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(session.notes!),
                  const SizedBox(height: 24),
                ],
                const Divider(),
                const SizedBox(height: 16),
                _buildGallerySection(ref),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildGallerySection(WidgetRef ref) {
    final assetsAsync = ref.watch(
      assets_provider.sessionAssetsProvider(sessionId),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.photo_library, size: 20),
            const SizedBox(width: 8),
            Text(
              'Galería',
              style: Theme.of(
                ref.context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        assetsAsync.when(
          data: (assets) {
            if (assets.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        size: 48,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'No hay fotos disponibles aún',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: assets.length,
              itemBuilder: (context, index) {
                final asset = assets[index];
                return _buildThumbnail(ref, asset.storagePath, asset.id);
              },
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 8),
                  Text(
                    'Error al cargar galería: $error',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnail(WidgetRef ref, String storagePath, String assetId) {
    final urlAsync = ref.watch(
      assets_provider.assetUrlProvider(storagePath, thumbnail: true),
    );
    final isAdminAsync = ref.watch(isCurrentUserAdminProvider);

    return urlAsync.when(
      data: (url) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(ref.context).push(
                MaterialPageRoute(
                  builder: (context) => ImageViewer(
                    storagePath: storagePath,
                    fileName: 'photo_$assetId.jpg',
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.error, color: Colors.red),
                ),
              ),
            ),
          ),
          // Delete button for admin
          isAdminAsync.when(
            data: (isAdmin) => isAdmin
                ? Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () =>
                          _showDeleteConfirmation(ref, assetId, storagePath),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.delete,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      loading: () => Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (error, stack) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.error, color: Colors.red),
      ),
    );
  }

  void _showDeleteConfirmation(
    WidgetRef ref,
    String assetId,
    String storagePath,
  ) {
    showDialog(
      context: ref.context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Foto'),
        content: const Text('¿Estás seguro de que deseas eliminar esta foto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              try {
                await ref
                    .read(photoUploadProvider.notifier)
                    .deletePhoto(assetId);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Foto eliminada exitosamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }

                // Refresh the gallery
                ref.invalidate(
                  assets_provider.sessionAssetsProvider(sessionId),
                );
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al eliminar: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'planned':
        return 'Planeada';
      case 'confirmed':
        return 'Confirmada';
      case 'delivered':
        return 'Entregada';
      case 'cancelled':
        return 'Cancelada';
      default:
        return status;
    }
  }

  void _showStatusDialog(WidgetRef ref, BuildContext context, Session session) {
    final statuses = [
      {'value': 'planned', 'label': 'Planeada'},
      {'value': 'confirmed', 'label': 'Confirmada'},
      {'value': 'delivered', 'label': 'Entregada'},
      {'value': 'cancelled', 'label': 'Cancelada'},
    ];

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cambiar Estado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statuses.map((status) {
            final isSelected = session.status == status['value'];
            return ListTile(
              title: Text(status['label']!),
              leading: Radio<String>(
                value: status['value']!,
                groupValue: session.status,
                onChanged: (value) {
                  if (value != null && value != session.status) {
                    Navigator.pop(dialogContext);
                    _updateStatus(ref, context, value);
                  }
                },
              ),
              selected: isSelected,
              onTap: () {
                final value = status['value']!;
                if (value != session.status) {
                  Navigator.pop(dialogContext);
                  _updateStatus(ref, context, value);
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _updateStatus(
    WidgetRef ref,
    BuildContext context,
    String newStatus,
  ) async {
    try {
      final repository = ref.read(sessionsRepositoryProvider);
      await repository.updateSessionStatus(sessionId, newStatus);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Estado actualizado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Refresh both the session detail and the sessions list
      ref.invalidate(sessionDetailProvider(sessionId));
      ref.invalidate(allSessionsListProvider);
      ref.invalidate(sessionsListProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar estado: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
