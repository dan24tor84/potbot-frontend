// lib/services/ai_service.dart
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

/// Backend base URL. We pass this at build time with:
/// flutter build web --release --dart-define=API_URL=https://your-backend
///
/// On Railway, the Nixpacks build injects POTBOT_API_URL into API_URL,
/// so this will be set automatically in production.
const String _backendUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'https://potbot-production.up.railway.app', // safe fallback
);

class AIService {
  AIService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// Sends image bytes to the backend and returns the parsed JSON map.
  /// Expects the backend route: POST <_backendUrl>/api/analyze
  /// with multipart field name: "image".
  Future<Map<String, dynamic>> analyzeBytes(
    Uint8List data, {
    String filename = 'upload.jpg',
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final uri = Uri.parse('$_backendUrl/api/analyze'); // <— ensure /api
    final req = http.MultipartRequest('POST', uri)
      ..files.add(
        http.MultipartFile.fromBytes(
          'image', // <— field name your backend expects
          data,
          filename: filename,
        ),
      );

    http.StreamedResponse streamed;
    try {
      streamed = await _client.send(req).timeout(timeout);
    } on Exception catch (e) {
      throw Exception('Network error sending image: $e');
    }

    late final http.Response res;
    try {
      res = await http.Response.fromStream(streamed);
    } on Exception catch (e) {
      throw Exception('Failed to read server response: $e');
    }

    if (res.statusCode == 200) {
      try {
        final body = json.decode(res.body);
        if (body is Map<String, dynamic>) return body;
        throw Exception('Unexpected JSON: not an object');
      } on Exception catch (e) {
        throw Exception('Bad JSON from server: $e\nBody: ${res.body}');
      }
    }

    // Helpful error with status + body for debugging in UI/toast
    throw Exception(
      'Analyze failed (${res.statusCode} ${res.reasonPhrase}): ${res.body}',
    );
  }

  void close() => _client.close();
}
