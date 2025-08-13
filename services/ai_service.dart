import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

/// Centralized API client for PotBot.
class AIService {
  /// Prefer dart-define at build time; falls back to your Railway URL.
  static const String backendBase = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'https://potbot-production.up.railway.app',
  );

  /// Analyze for "bud" (quality) OR "plant" (grower mode).
  /// Provide either a [file] (mobile/desktop) OR [bytes] + [filename] (web).
  Future<Map<String, dynamic>> analyze({
    required String kind, // "bud" or "plant"
    File? file,
    Uint8List? bytes,
    String filename = 'photo.jpg',
  }) async {
    final uri = Uri.parse('$backendBase/analyze'); // backend route
    final req = http.MultipartRequest('POST', uri)
      ..fields['kind'] = kind;

    if (file != null) {
      req.files.add(await http.MultipartFile.fromPath('file', file.path));
    } else if (bytes != null) {
      req.files.add(http.MultipartFile.fromBytes('file', bytes, filename: filename));
    } else {
      throw Exception('Provide either file or bytes');
    }

    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data is Map<String, dynamic>) ? data : {'ok': true, 'data': data};
    }

    throw Exception('Server ${res.statusCode}: ${res.body}');
  }
}