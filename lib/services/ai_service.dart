// lib/services/ai_service.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

/// Backend base URL. Prefer passing at build time:
/// flutter build web --release --dart-define=API_URL=https://your-backend
///
/// On Railway, Nixpacks maps POTBOT_API_URL -> API_URL for production builds.
const String _backendUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'https://potbot-production.up.railway.app', // safe fallback
);

class AIService {
  AIService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  /// Sends image bytes to the backend and returns a parsed JSON map.
  /// Expects backend route: POST <_backendUrl>/api/analyze
  /// with multipart field name: "image".
  Future<Map<String, dynamic>> analyzeBytes(
    Uint8List data, {
    String filename = 'upload.jpg',
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final uri = Uri.parse('$_backendUrl/api/analyze'); // <- /api
    final req = http.MultipartRequest('POST', uri)
      ..files.add(
        http.MultipartFile.fromBytes(
          'image',           // <- must match backend field name
          data,
          filename: filename,
        ),
      );

    http.StreamedResponse streamed;
    try {
      streamed = await _client.send(req).timeout(timeout);
    } catch (e) {
      throw Exception('Network error while sending request: $e');
    }

    final res = await http.Response.fromStream(streamed);
    if (res.statusCode == 200) {
      try {
        return json.decode(res.body) as Map<String, dynamic>;
      } catch (_) {
        throw Exception('Invalid JSON from server: ${res.body}');
      }
    }

    // Bubble up structured error
    throw Exception(
      'Analyze failed: ${res.statusCode} ${res.reasonPhrase}\n${res.body}',
    );
  }
}
