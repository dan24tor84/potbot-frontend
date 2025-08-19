import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

/// Backend base URL. Prefer passing at build time:
/// flutter build web --release --dart-define=API_URL=https://your-backend
const String _backendUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'https://potbot-production.up.railway.app',
);

class AIService {
  /// Send image bytes to the backend /analyze endpoint.
  Future<Map<String, dynamic>> analyzeBytes(
    Uint8List data, {
    String filename = 'upload.jpg',
  }) async {
    final req = http.MultipartRequest(
      'POST',
      Uri.parse('$_backendUrl/analyze'),
    )..files.add(
        http.MultipartFile.fromBytes(
          'image',
          data,
          filename: filename,
        ),
      );

    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);

    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    }

    throw Exception(
      'Analyze failed: ${res.statusCode} ${res.reasonPhrase}\n${res.body}',
    );
  }
}
