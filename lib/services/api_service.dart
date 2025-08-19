import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ScanResult {
  final String label;
  final double score;
  final String message;

  ScanResult({required this.label, required this.score, required this.message});

  factory ScanResult.fromJson(Map<String, dynamic> j) => ScanResult(
    label: j['label'] ?? j['result'] ?? 'Unknown',
    score: (j['score'] is int) ? (j['score'] as int).toDouble() : (j['score'] ?? 0.0).toDouble(),
    message: j['message'] ?? '',
  );
}

class ApiService {
  final String baseUrl;

  ApiService() : baseUrl = dotenv.get('API_URL');

  Future<ScanResult> scanImageBase64(String base64Image) async {
    final uri = Uri.parse('$baseUrl/api/scan');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'image': base64Image}),
    );

    if (res.statusCode != 200) {
      throw Exception('Scan failed: ${res.statusCode} ${res.body}');
    }

    final data = jsonDecode(res.body);
    // accept either a top-level object or { result: {...} }
    final obj = (data is Map && data['result'] is Map) ? data['result'] : data;
    return ScanResult.fromJson(obj as Map<String, dynamic>);
  }
}
