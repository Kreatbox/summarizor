import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  final String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=';

  Future<String?> generateContent(String prompt) async {
    if (_apiKey.isEmpty) {
      print('Error: Gemini API key is missing.');
      return null;
    }

    final url = Uri.parse('$_baseUrl$_apiKey');
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'contents': [
        {'parts': [{'text': prompt}]}
      ]
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        final content = decodedResponse['candidates'][0]['content']['parts'][0]['text'];
        return content;
      } else {
        print('Error: API request failed with status code ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: An exception occurred during the API request: $e');
      return null;
    }
  }
}