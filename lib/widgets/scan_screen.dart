import 'dart:typed_data';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/ai_service.dart';

class ScanScreen extends StatefulWidget {
  final String
      apiUrl; // kept for compatibility; not required with current AIService
  const ScanScreen({super.key, required this.apiUrl});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final _picker = ImagePicker();
  final _ai = AIService();

  XFile? _picked;
  Uint8List? _previewBytes; // web
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_previewBytes != null)
              Image.memory(_previewBytes!, height: 200, fit: BoxFit.cover)
            else if (_picked != null && !kIsWeb)
              Image.file(File(_picked!.path), height: 200, fit: BoxFit.cover),
            const SizedBox(height: 12),
            if (_isLoading) const CircularProgressIndicator(),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_result != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(_result.toString()),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _pick(ImageSource.gallery),
                  child: const Text('Gallery'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => _pick(ImageSource.camera),
                  child: const Text('Camera'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pick(ImageSource source) async {
    setState(() {
      _error = null;
      _result = null;
    });

    try {
      final file = await _picker.pickImage(source: source);
      if (file == null) return;

      setState(() {
        _picked = file;
        _isLoading = true;
      });

      Map<String, dynamic> result;

      if (kIsWeb) {
        final bytes = await file.readAsBytes();
        setState(() => _previewBytes = bytes);
        result = await _ai.analyze(bytes: bytes, filename: file.name);
      } else {
        final f = File(file.path);
        result = await _ai.analyze(file: f);
      }

      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
}
