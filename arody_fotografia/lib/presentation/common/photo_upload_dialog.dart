import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/photo_management_provider.dart';

class PhotoUploadDialog extends ConsumerStatefulWidget {
  final String sessionId;

  const PhotoUploadDialog({
    super.key,
    required this.sessionId,
  });

  @override
  ConsumerState<PhotoUploadDialog> createState() => _PhotoUploadDialogState();
}

class _PhotoUploadDialogState extends ConsumerState<PhotoUploadDialog> {
  List<File>? _selectedFiles;
  bool _isSelecting = false;

  Future<void> _pickImages() async {
    setState(() {
      _isSelecting = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
        allowCompression: false,
      );

      if (result != null) {
        setState(() {
          _selectedFiles = result.paths
              .where((path) => path != null)
              .map((path) => File(path!))
              .toList();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar archivos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isSelecting = false;
      });
    }
  }

  Future<void> _uploadPhotos() async {
    if (_selectedFiles == null || _selectedFiles!.isEmpty) return;

    await ref
        .read(photoUploadProvider.notifier)
        .uploadPhotos(widget.sessionId, _selectedFiles!);

    final state = ref.read(photoUploadProvider);

    if (mounted) {
      if (state.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${state.error}'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (!state.isUploading) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fotos cargadas exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(photoUploadProvider);

    return AlertDialog(
      title: const Text('Cargar Fotos'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_selectedFiles == null) ...[
              const Text(
                'Selecciona las fotos que deseas cargar',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              if (_isSelecting)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton.icon(
                  onPressed: _pickImages,
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Seleccionar Fotos'),
                ),
            ] else ...[
              Text(
                '${_selectedFiles!.length} foto(s) seleccionada(s)',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              if (uploadState.isUploading) ...[
                LinearProgressIndicator(value: uploadState.progress),
                const SizedBox(height: 8),
                Text(
                  'Subiendo ${uploadState.currentPhoto} de ${uploadState.totalPhotos}...',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ] else ...[
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _selectedFiles!.length,
                    itemBuilder: (context, index) {
                      final file = _selectedFiles![index];
                      return ListTile(
                        leading: const Icon(Icons.image),
                        title: Text(
                          file.path.split('/').last,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _selectedFiles!.removeAt(index);
                              if (_selectedFiles!.isEmpty) {
                                _selectedFiles = null;
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: uploadState.isUploading
              ? null
              : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        if (_selectedFiles != null && !uploadState.isUploading)
          ElevatedButton(
            onPressed: _uploadPhotos,
            child: const Text('Subir'),
          ),
      ],
    );
  }
}

