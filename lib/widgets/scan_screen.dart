import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/api_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key, required this.apiUrl});

  // Kept to match main.dart. The current AIService uses its own baseUrl.
  final String apiUrl;

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ImagePicker _picker = ImagePicker();
  final AIService _apiService = AIService();

  bool _isLoading = false;
  String? _error;
  String? _result;
  XFile? _picked;

  Future<void> _pick(ImageSource source) async {
    setState(() {
      _error = null;
      _result = null;
    });

    final file = await _picker.pickImage(source: source, maxWidth: 1600);
    if (file == null) return;

    setState(() {
      _picked = file;
    });

    await _scan();
  }

  Future<void> _scan() async {
    if (_picked == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      final bytes = await _picked!.readAsBytes();
      final base64Image = base64Encode(bytes);

      final aiText = await _apiService.analyzeImage(base64Image);

      setState(() {
        _result = aiText;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _pick(ImageSource.camera),
                  child: const Text('Camera'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => _pick(ImageSource.gallery),
                  child: const Text('Gallery'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isLoading) const CircularProgressIndicator(),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_result != null) Expanded(child: SingleChildScrollView(child: Text(_result!))),
          ],
        ),
      ),
    );
  }
}