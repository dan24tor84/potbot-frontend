// lib/widgets/scan_screen.dart
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

  Future<void> _pick(ImageSource source) async {
    setState(() {
      _error = null;
    });
    final x = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1600,
    );
    if (x == null) return;
    setState(() => _imageFile = File(x.path));
  }

  Future<void> _scan() async {
    if (_imageFile == null) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final bytes = await _imageFile!.readAsBytes();
      final base64Image = base64Encode(bytes);

      final api = ApiService();
      final result = await api.scanImageBase64(base64Image);

      if (!mounted) return;
      Navigator.of(context).pushNamed(
        '/results',
        arguments: {'result': result},
      );
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final box = Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 360),
      child: AspectRatio(
        aspectRatio: 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24, width: 2),
            color: Colors.black12,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: _imageFile == null
                ? const Center(
                    child: Text(
                      'No image selected',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : Image.file(_imageFile!, fit: BoxFit.cover),
          ),
        ),
      ),
    );

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
