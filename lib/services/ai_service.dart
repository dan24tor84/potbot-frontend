// lib/services/ai_service.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

/// We pass the backend base URL at build time:
/// flutter build web --release --dart-define=API_URL=https://your-backend
///
/// On Railway, .nixpacks.toml injects POTBOT_API_URL into API_URL.
const String _backendUrl = String.fromEnvironment(
  'API_URL',
  // Safe fallback so the app still works if dart-define is missing.
  defaultValue: 'https://potbot-production.up.railway.app',
);

class AIService {
  AIService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// Sends image bytes to the backend and returns parsed JSON.
  /// Expects POST <_backendUrl>/api/analyze with multipart field "image".
  Future<Map<String, dynamic>> analyzeBytes(
    Uint8List data, {
    String filename = 'upload.jpg',
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final uri = Uri.parse('$_backendUrl/api/analyze'); // ensure /api
    final req = http.MultipartRequest('POST', uri)
      ..files.add(
        http.MultipartFile.fromBytes(
          'image',   // <-- must match backend's field name
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

    late final http.Response res;
    try {
      res = await http.Response.fromStream(streamed);
    } catch (e) {
      throw Exception('Failed to read response: $e');
    }

    if (res.statusCode == 200) {
      try {
        final jsonMap = json.decode(res.body) as Map<String, dynamic>;
        return jsonMap;
      } catch (e) {
        throw Exception('Response JSON parse error: $e\nBody: ${res.body}');
      }
    }

    // Non-200 → surface details for debugging in UI/console
    throw Exception(
      'Analyze failed: ${res.statusCode} ${res.reasonPhrase}\n${res.body}',
    );
  }
}
