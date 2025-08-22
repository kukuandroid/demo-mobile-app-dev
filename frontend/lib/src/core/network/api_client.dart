import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  ApiClient({required this.baseUrl});

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    return Uri.parse(baseUrl).replace(
      path: path.startsWith('/') ? path : '/$path',
      queryParameters: query?.map((k, v) => MapEntry(k, v.toString())),
    );
  }

  Future<dynamic> getJson(String path, {Map<String, dynamic>? query}) async {
    final res = await http.get(_uri(path, query), headers: {
      'Accept': 'application/json',
    });
    _ensureSuccess(res);
    return jsonDecode(res.body);
  }

  Future<dynamic> postJson(String path, {Object? body}) async {
    final res = await http.post(_uri(path), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }, body: jsonEncode(body ?? {}));
    _ensureSuccess(res);
    return jsonDecode(res.body);
  }

  void _ensureSuccess(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw ApiException(res.statusCode, res.body);
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String body;
  ApiException(this.statusCode, this.body);
  @override
  String toString() => 'ApiException($statusCode): $body';
}
