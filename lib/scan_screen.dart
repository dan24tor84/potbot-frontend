import 'dart:typed_data';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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

  bool _busy = false;
  String? _resultText;

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
      if (_webBytes == null) return _placeholder();
      return Image.memory(
        _webBytes!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 220,
      );
    } else {
      if (_path == null) return _placeholder();
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
      border: Border.all(color: Colors.tealAccent),
      borderRadius: BorderRadius.circular(12),
    ),
    alignment: Alignment.center,
    child: const Text('No image selected'),
  );

  Future<void> _analyze() async {
    if (_busy) return;
    if (!kIsWeb && _path == null) return;
    if (kIsWeb && _webBytes == null) return;

    final apiUrl = dotenv.env['POTBOT_API_URL'] ?? '';
    final token = dotenv.env['REPLICATE_API_TOKEN'] ?? '';
    if (apiUrl.isEmpty || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing API URL or token in .env')),
      );
      return;
    }

    setState(() => _busy = true);
    try {
      final uri = Uri.parse('$apiUrl/api/analyze');
      final req = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token';

      if (kIsWeb) {
        req.files.add(http.MultipartFile.fromBytes(
          'image',
          _webBytes!,
          filename: 'upload.jpg',
        ));
      } else {
        req.files.add(await http.MultipartFile.fromPath(
          'image',
          _path!,
          filename: 'upload.jpg',
        ));
      }

      final streamed = await req.send();
      final res = await http.Response.fromStream(streamed);

      if (res.statusCode == 200) {
        // Expecting JSON text; show as-is for now
        setState(() => _resultText = res.body);
        _showResultDialog(res.body);
      } else {
        _showResultDialog('Error ${res.statusCode}: ${res.body}');
      }
    } catch (e) {
      _showResultDialog('Request failed: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showResultDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Analysis Result'),
        content: SingleChildScrollView(child: Text(message)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

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
              onPressed: (kIsWeb ? _webBytes != null : _path != null) && !_busy ? _analyze : null,
              child: _busy ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Analyze with AI'),
            ),
            if (_resultText != null) ...[
              const SizedBox(height: 12),
              Text(
                _resultText!,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
            ]
          ],
        ),
      ),
    );
  }
}