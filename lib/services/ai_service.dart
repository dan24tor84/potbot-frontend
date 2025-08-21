// lib/services/ai_service.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

/// Reads API_URL at build time (Railway Nixpacks injects POTBOT_API_URL -> API_URL)
final String _backendBase = const String.fromEnvironment(
  'API_URL',
  defaultValue: 'https://potbot-production.up.railway.app', // <-- correct backend
);

Uri _analyzeUri() => Uri.parse('$_backendBase/api/analyze');

class AIService {
  AIService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  /// Send raw bytes via multipart/form-data (field name "image")
  Future<Map<String, dynamic>> analyzeBytes(
    Uint8List bytes, {
    String filename = 'upload.jpg',
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final req = http.MultipartRequest('POST', _analyzeUri())
      ..files.add(
        http.MultipartFile.fromBytes(
          'image', // <-- matches backend server.js
          bytes,
          filename: filename,
        ),
      );

    final streamed = await _client.send(req).timeout(timeout);
    final res = await http.Response.fromStream(streamed);

    if (res.statusCode == 200) {
      return (res.body.isEmpty)
          ? <String, dynamic>{}
          : jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception(
      'Analyze failed: ${res.statusCode} ${res.reasonPhrase}\n${res.body}',
    );
  }

  /// Alternative: send a base64 string in JSON (key "image_base64")
  Future<Map<String, dynamic>> analyzeBase64(
    String base64Image, {
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final res = await _client
        .post(
          _analyzeUri(),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'image_base64': base64Image}), // <-- correct key
        )
        .timeout(timeout);

    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception(
      'Analyze failed: ${res.statusCode} ${res.reasonPhrase}\n${res.body}',
    );
  }
}
