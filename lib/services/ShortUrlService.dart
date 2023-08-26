import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShortUrlService extends GetxService {
  Future<String> shortenUrl(String longUrl, String accessToken) async {
    const apiUrl = 'https://api-ssl.bitly.com/v4/shorten';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({'long_url': longUrl}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['id']; // This will be the shortened URL
    } else {
      throw Exception('Failed to shorten URL');
    }
  }
}
