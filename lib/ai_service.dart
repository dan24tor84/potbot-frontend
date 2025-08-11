import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

Future<String> analyzeImage(File imageFile) async {
  final String apiUrl = dotenv.env['POTBOT_API_URL']!;
  final String replicateToken = dotenv.env['REPLICATE_API_TOKEN']!;

  final uri = Uri.parse('$apiUrl/api/analyze'); // Your real Railway endpoint

  final request = http.MultipartRequest('POST', uri)
    ..headers['Authorization'] = 'Bearer $replicateToken'
    ..files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: basename(imageFile.path),
      ),
    );

  try {
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['result'] ?? 'No result returned';
    } else {
      return 'Error: ${response.statusCode} - ${response.body}';
    }
  } catch (e) {
    return 'Exception occurred: $e';
  }
}