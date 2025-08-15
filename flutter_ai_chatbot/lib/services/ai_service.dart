import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class AIService {
  final String endpoint = 'https://api.openai.com/v1/chat/completions';

  Future<String> sendMessage(String question) async {
    final response = await http
        .post(
          Uri.parse(endpoint),
          headers: {
            'Authorization': 'Bearer $API_KEY',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'model': 'gpt-3.5-turbo',
            'messages': [
              {
                'role': 'system',
                'content': 'Tu es un assistant expert en g\u00e9nie civil.'
              },
              {'role': 'user', 'content': question}
            ]
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Erreur ${response.statusCode}');
    }
  }
}
