import 'dart:typed_data';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final String? path;        // local file path (mobile/desktop)
  final Uint8List? webBytes; // raw bytes (web)
  final double height;

  const ImagePreview({
    super.key,
    this.path,
    this.webBytes,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    if (path == null && webBytes == null) {
      return _placeholder();
    }

    final img = kIsWeb && webBytes != null
        ? Image.memory(webBytes!, fit: BoxFit.contain, width: double.infinity, height: height)
        : Image.file(File(path!), fit: BoxFit.contain, width: double.infinity, height: height);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: Colors.black12,
        height: height,
        width: double.infinity,
        child: InteractiveViewer(
          maxScale: 4,
          minScale: 0.5,
          child: img,
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.tealAccent.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: const Text(
        'No image selected',
        style: TextStyle(color: Colors.black54),
      ),
    );
  }
}