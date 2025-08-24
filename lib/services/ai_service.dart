import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

/// Backend base URL. Injected by build:
/// flutter build web --release --dart-define=API_URL=https://your-backend
const String _backendUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'https://potbot-production.up.railway.app',
);

class AIService {
  final http.Client _client;
  AIService({http.Client? client}) : _client = client ?? http.Client();

  /// Sends image bytes to the backend and returns the parsed JSON.
  /// Expects POST <_backendUrl>/api/analyze with multipart field name "image".
  Future<Map<String, dynamic>> analyzeBytes(
    Uint8List data, {
    String filename = 'upload.jpg',
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final uri = Uri.parse('$_backendUrl/api/analyze');

    final req = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes('image', data, filename: filename));

    http.StreamedResponse streamed;
    try {
      streamed = await _client.send(req).timeout(timeout);
    } catch (e) {
      throw Exception('Network error sending image: $e');
    }

    final res = await http.Response.fromStream(streamed);
    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Analyze failed: ${res.statusCode} ${res.reasonPhrase}\n${res.body}');
  }
}
