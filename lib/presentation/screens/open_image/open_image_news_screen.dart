import 'dart:async';

import 'package:flutter/material.dart';

import '../../../domain/services/i_image_export_port.dart';
import 'open_image_state.dart';
import 'open_image_view_wrapper.dart';

/// Полноэкранный просмотр изображения новости с действиями через [OpenImageViewWrapper].
class OpenImageNewsScreen extends StatefulWidget {
  const OpenImageNewsScreen({
    super.key,
    required this.imageUrl,
    required this.imageExport,
  });

  final String imageUrl;
  final IImageExportPort imageExport;

  @override
  State<OpenImageNewsScreen> createState() => _OpenImageNewsScreenState();
}

class _OpenImageNewsScreenState extends State<OpenImageNewsScreen> {
  late final OpenImageViewWrapper _wrapper;
  StreamSubscription<OpenImageState>? _sub;

  @override
  void initState() {
    super.initState();
    _wrapper = OpenImageViewWrapper(widget.imageExport);
    _sub = _wrapper.stream.listen((state) {
      if (state is OpenImageMessage) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.text)),
        );
        Future<void>.delayed(const Duration(milliseconds: 50), () {
          if (mounted) _wrapper.resetMessage();
        });
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _wrapper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Image'),
        actions: [
          StreamBuilder<OpenImageState>(
            stream: _wrapper.stream,
            initialData: _wrapper.currentState,
            builder: (context, snapshot) {
              final busy = snapshot.data is OpenImageBusy;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Save',
                    onPressed: busy
                        ? null
                        : () => _wrapper.saveImage(widget.imageUrl),
                    icon: const Icon(Icons.download),
                  ),
                  IconButton(
                    tooltip: 'Share',
                    onPressed: busy
                        ? null
                        : () => _wrapper.shareImage(widget.imageUrl),
                    icon: const Icon(Icons.share),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          InteractiveViewer(
            minScale: 0.5,
            maxScale: 4,
            child: Center(
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                },
                errorBuilder: (context, error, stack) => const Center(
                  child: Icon(Icons.broken_image, color: Colors.white54, size: 64),
                ),
              ),
            ),
          ),
          StreamBuilder<OpenImageState>(
            stream: _wrapper.stream,
            initialData: _wrapper.currentState,
            builder: (context, snapshot) {
              if (snapshot.data is OpenImageBusy) {
                return const ColoredBox(
                  color: Colors.black26,
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
