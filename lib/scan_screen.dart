import 'dart:typed_data';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});
  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final _picker = ImagePicker();

  // Mobile/Desktop use a file path; Web uses bytes.
  String? _path;
  Uint8List? _webBytes;

  Future<void> _pickFromGallery() async {
    final XFile? x = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (x == null) return;

    if (kIsWeb) {
      _webBytes = await x.readAsBytes();
      _path = null;
    } else {
      _path = x.path;
      _webBytes = null;
    }
    setState(() {});
  }

  Future<void> _pickFromCamera() async {
    final XFile? x = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (x == null) return;

    if (kIsWeb) {
      _webBytes = await x.readAsBytes();
      _path = null;
    } else {
      _path = x.path;
      _webBytes = null;
    }
    setState(() {});
  }

  Widget _preview() {
    if (kIsWeb) {
      if (_webBytes == null) {
        return _placeholder();
      }
      return Image.memory(
        _webBytes!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 220,
      );
    } else {
      if (_path == null) {
        return _placeholder();
      }
      return Image.file(
        File(_path!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: 220,
      );
    }
  }

  Widget _placeholder() => Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.tealAccent.withOpacity(.5)),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: const Text('No image selected'),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Your Bud')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _preview(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.tonal(
                  onPressed: _pickFromCamera,
                  child: const Text('Camera'),
                ),
                const SizedBox(width: 12),
                FilledButton.tonal(
                  onPressed: _pickFromGallery,
                  child: const Text('Gallery'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: (_path != null || _webBytes != null)
                  ? () {
                      /* call your AI */
                    }
                  : null,
              child: const Text('Analyze with AI'),
            ),
          ],
        ),
      ),
    );
  }
}
