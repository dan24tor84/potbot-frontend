import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // <-- needed for kIsWeb
import 'package:potbot_frontend_flutter/widgets/image_preview.dart';

class ResultsScreen extends StatelessWidget {
  final String? path;
  final Uint8List? webBytes;
  final Map<String, dynamic> results;

  const ResultsScreen({
    super.key,
    this.path,
    this.webBytes,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Results'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _preview(),
            const SizedBox(height: 20),
            _resultsList(),
          ],
        ),
      ),
    );
  }

  Widget _preview() {
    if (kIsWeb) {
      if (webBytes == null) return _placeholder();
      return ImagePreview(
        webBytes: webBytes,
        height: 220,
      );
    } else {
      if (path == null) return _placeholder();
      return ImagePreview(
        path: path,
        height: 220,
      );
    }
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        border: Border.all(
          // using withValues (non-deprecated) instead of withOpacity
          color: Colors.tealAccent.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: const Text(
        'No image selected',
        style: TextStyle(color: Colors.white54),
      ),
    );
  }

  Widget _resultsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: results.entries.map((entry) {
        final key = entry.key;
        final value = entry.value;

        // Example thresholds: `<50` low quality, `>80` high quality (text in backticks avoids doc-comment HTML)
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            title: Text(
              key,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(value.toString()),
          ),
        );
      }).toList(),
    );
  }
}