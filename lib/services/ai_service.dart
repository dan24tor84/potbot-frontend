import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' show File; // File is not used on web
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class AIService {
  static const String backendUrl = 'https://potbot-production.up.railway.app';

  /// Convenience wrapper that calls the right method for web vs mobile.
  Future<Map<String, dynamic>> analyze({
    File? file,
    Uint8List? bytes,
    String filename = 'upload.jpg',
  }) async {
    if (kIsWeb) {
      if (bytes == null) {
        throw Exception('No image bytes provided for web.');
      }
      return analyzeBytes(bytes, filename: filename);
    } else {
      if (file == null) {
        throw Exception('No file provided for mobile/desktop.');
      }
      return analyzeFile(file);
    }
  }

  /// Mobile/desktop path
  Future<Map<String, dynamic>> analyzeFile(File imageFile) async {
    final req = http.MultipartRequest(
      'POST',
      Uri.parse('$backendUrl/analyze'),
    );
    req.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    final res = await http.Response.fromStream(await req.send());
    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Analyze failed: ${res.statusCode} ${res.reasonPhrase}');
  }

  /// Web path
  Future<Map<String, dynamic>> analyzeBytes(
      Uint8List data, {
        String filename = 'upload.jpg',
      }) async {
    final req = http.MultipartRequest(
      'POST',
      Uri.parse('$backendUrl/analyze'),
    );
    req.files.add(http.MultipartFile.fromBytes('image', data,
        filename: filename, contentType: null));
    final res = await http.Response.fromStream(await req.send());
    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Analyze failed: ${res.statusCode} ${res.reasonPhrase}');
  }
}