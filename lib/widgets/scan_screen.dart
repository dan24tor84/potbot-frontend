// lib/widgets/scan_screen.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/api_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
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
      appBar: AppBar(
        title: const Text('PotBot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: () =>
                Navigator.of(context).pushNamed('/leaderboard'),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              box,
              const SizedBox(height: 16),
              if (_isLoading) const LinearProgressIndicator(),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: Colors.redAccent)),
              ],
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.photo_camera),
                    label: const Text('Camera'),
                    onPressed: () => _pick(ImageSource.camera),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                    onPressed: () => _pick(ImageSource.gallery),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.science),
                    label: const Text('Scan'),
                    onPressed: _isLoading || _imageFile == null ? null : _scan,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
