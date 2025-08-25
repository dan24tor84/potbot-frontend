// lib/services/api_service.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://potbot-production.up.railway.app',
  );

  static final http.Client _client = http.Client();

  /// Analyze image using multipart upload
  static Future<Map<String, dynamic>> analyzeImage(
    Uint8List imageBytes, {
    String filename = 'upload.jpg',
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final uri = Uri.parse('$_baseUrl/api/analyze');
    
    final request = http.MultipartRequest('POST', uri)
      ..files.add(
        http.MultipartFile.fromBytes('image', imageBytes, filename: filename),
      );

    try {
      final streamedResponse = await _client.send(request).timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Analysis failed: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Get growing tips
  static Future<Map<String, dynamic>> getGrowTips({
    required String stage,
    String issue = '',
  }) async {
    final uri = Uri.parse('$_baseUrl/api/grow-tips');
    
    try {
      final response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'stage': stage,
          'issue': issue,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to get tips: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
