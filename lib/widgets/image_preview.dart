import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final String? path;
  final Uint8List? webBytes;
  final double height;

  const ImagePreview({
    Key? key,
    this.path,
    this.webBytes,
    this.height = 220,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (path == null && webBytes == null) {
      return _placeholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: kIsWeb
          ? Image.memory(
              webBytes!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: height,
            )
          : Image.file(
              File(path!),
              fit: BoxFit.cover,
              width: double.infinity,
              height: height,
            ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: const Text(
        'No image selected',
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
