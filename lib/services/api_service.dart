import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  final String baseUrl = 'https://potbot-backend-production.up.railway.app/api/analyze';

  Future<String> analyzeImage(String base64Image) async {
    final url = Uri.parse(baseUrl);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'image': base64Image}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Adjust this key based on your backend's JSON response
      return data['result'] ?? 'Analysis complete.';
    } else {
      throw Exception('Failed to analyze image: ${response.body}');
    }
  }
}