// lib/widgets/scan_screen.dart
import 'dart:typed_data';
import 'dart:io' show File; // Only used on mobile

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/ai_service.dart';
import 'image_preview.dart';

class qScanScreen extends StatelessWidget {
  const qScanScreen({super.key});

  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final _picker = ImagePicker();
  final _api = AIService();

  // Selection state
  Uint8List? _webBytes; // web image bytes
  String? _path;        // mobile file path

  // UI state
  bool _isLoading = false;

  /// Pick an image from gallery
  Future<void> _pickFromGallery() async {
    final XFile? x = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (x == null) return;

    if (kIsWeb) {
      final bytes = await x.readAsBytes();
      setState(() {
        _webBytes = bytes;
        _path = null;
      });
    } else {
      setState(() {
        _path = x.path;
        _webBytes = null;
      });
    }
  }

  /// Capture from camera (mobile only – web opens file dialog)
  Future<void> _pickFromCamera() async {
    final XFile? x = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (x == null) return;

    if (kIsWeb) {
      final bytes = await x.readAsBytes();
      setState(() {
        _webBytes = bytes;
        _path = null;
      });
    } else {
      setState(() {
        _path = x.path;
        _webBytes = null;
      });
    }
  }

  /// Run analysis and navigate to ResultsScreen
  Future<void> _analyze() async {
    if (kIsWeb && _webBytes == null || !kIsWeb && _path == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a photo first.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _api.analyze(
        file: kIsWeb ? null : File(_path!),
        bytes: kIsWeb ? _webBytes! : null,
        filename: 'photo.jpg',
      );

      if (!mounted) return;
      // Navigate with a direct constructor to avoid route-arg wiring
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultsScreen(results: result),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to analyze image: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Clear current selection
  void _clear() {
    setState(() {
      _webBytes = null;
      _path = null;
    });
  }

  Widget _preview() {
    if (_webBytes == null && _path == null) {
      return _placeholder();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: kIsWeb
          ? ImagePreview(
        webBytes: _webBytes!,
        height: 220,
      )
          : ImagePreview(
        path: _path,
        height: 220,
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: 220,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Your Bud')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _preview(),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickFromGallery,
                  icon: const Icon(Icons.photo),
                  label: const Text('Pick Photo'),
                ),
                ElevatedButton.icon(
                  onPressed: _pickFromCamera,
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('Take Photo'),
                ),
                OutlinedButton.icon(
                  onPressed: _clear,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                ),
                FilledButton.icon(
                  onPressed: _isLoading ? null : _analyze,
                  icon: _isLoading
                      ? const SizedBox(
                    height: 16, width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Icon(Icons.science),
                  label: Text(_isLoading ? 'Analyzing…' : 'Analyze'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Tip: Good lighting and focus improves results.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}