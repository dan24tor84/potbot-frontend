import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/ai_service.dart';
import 'results_screen.dart';
import 'image_preview.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final _picker = ImagePicker();
  final _api = AIService();

  Uint8List? _bytes;
  bool _isLoading = false;
  Map<String, dynamic>? _lastResult;

  Future<void> _pick(ImageSource source) async {
    try {
      final x = await _picker.pickImage(source: source, imageQuality: 85);
      if (x == null) return;
      final b = await x.readAsBytes();
      if (!mounted) return;
      setState(() {
        _bytes = b;
        _lastResult = null;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> _analyze() async {
    try {
      setState(() {
        _isLoading = true;
        _lastResult = null;
      });

      if (_bytes == null) {
        throw Exception('Please pick an image first.');
      }

      final res = await _api.analyze(bytes: _bytes!, filename: 'photo.jpg');
      if (!mounted) return;

      setState(() {
        _lastResult = res;
        _isLoading = false;
      });

      // Navigate to results
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ResultsScreen(result: res, originalBytes: _bytes),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Analyze failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Bud Bot')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ImagePreview(webBytes: _bytes, height: 220),
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton.icon(
                      onPressed: () => _pick(ImageSource.gallery),
                      icon: const Icon(Icons.photo_outlined),
                      label: const Text('Choose Photo'),
                    ),
                    FilledButton.icon(
                      onPressed: kIsWeb ? null : () => _pick(ImageSource.camera),
                      icon: const Icon(Icons.photo_camera_outlined),
                      label: const Text('Use Camera'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _isLoading ? null : _analyze,
                      icon: _isLoading
                          ? const SizedBox(
                          width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.search),
                      label: Text(_isLoading ? 'Analyzing…' : 'Scan Bud'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_lastResult != null)
                  Text(
                    'Last result: ${_lastResult!['summary'] ?? _lastResult}',
                    style: theme.textTheme.bodyMedium,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}