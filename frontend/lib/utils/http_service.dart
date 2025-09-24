import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'http://192.168.1.2:4000/api';
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };

  static Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {...defaultHeaders, ...?headers},
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform GET request: $e');
    }
  }

  static Future<dynamic> post(
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {...defaultHeaders, ...?headers},
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform POST request: $e');
    }
  }

  static dynamic _handleResponse(http.Response response) {
    final responseData = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (responseData is Map && responseData.containsKey('data')) {
        return responseData['data'];
      }
      return responseData;
    } else {
      throw Exception(
        'Request failed with status: ${response.statusCode}. Message: ${responseData['message'] ?? responseData.toString()}',
      );
    }
  }
}
