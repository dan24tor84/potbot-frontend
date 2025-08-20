import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' show File; // not used on web
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class AIService {
  // Keep this pointing at your backend
  static const String baseUrl = 'https://potbot-production.up.railway.app';
  static const String analyzePath = '/analyze'; // adjust if your route differs

  /// Backwards-compat convenience (matches older code calling `analyzeImage`)
  Future<Map<String, dynamic>> analyzeImage({
    File? file,
    Uint8List? bytes,
    String filename = 'upload.jpg',
  }) =>
      analyze(file: file, bytes: bytes, filename: filename);

  /// One entry point used by the UI. Provide *either* [file] (mobile/desktop)
  /// or [bytes] (web). Chooses the correct upload method for the platform.
  Future<Map<String, dynamic>> analyze({
    File? file,
    Uint8List? bytes,
    String filename = 'upload.jpg',
  }) async {
    if (kIsWeb) {
      if (bytes == null) {
        throw ArgumentError('bytes must be provided when running on web');
      }
      return analyzeBytes(bytes: bytes, filename: filename);
    } else {
      if (file == null) {
        throw ArgumentError('file must be provided on mobile/desktop');
      }
      return analyzeFile(file);
    }
  }

  /// Mobile/desktop: multipart upload from file path.
  Future<Map<String, dynamic>> analyzeFile(File imageFile) async {
    final uri = Uri.parse('$baseUrl$analyzePath');
    final req = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    final res = await http.Response.fromStream(await req.send());
    return _handleJson(res);
  }

  /// Web: multipart upload from raw bytes.
  Future<Map<String, dynamic>> analyzeBytes({
    required Uint8List bytes,
    String filename = 'upload.jpg',
  }) async {
    final uri = Uri.parse('$baseUrl$analyzePath');
    final req = http.MultipartRequest('POST', uri)
      ..files.add(
          http.MultipartFile.fromBytes('image', bytes, filename: filename));
    final res = await http.Response.fromStream(await req.send());
    return _handleJson(res);
  }

  Map<String, dynamic> _handleJson(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final body = res.body.isEmpty ? '{}' : res.body;
      return jsonDecode(body) as Map<String, dynamic>;
    }
    throw HttpException(
        'Analyze failed ${res.statusCode}: ${res.reasonPhrase} ${res.body}');
  }
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);
  @override
  String toString() => message;
}
