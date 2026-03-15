import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_exception.dart';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> get(Uri uri) async {
    try {
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }

      if (response.statusCode == 404) {
        throw const ApiException(
          message: 'No data found.',
          statusCode: 404,
        );
      }

      throw ApiException(
        message: 'Request failed.',
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is ApiException) rethrow;

      throw const ApiException(
        message: 'Unexpected network error occurred.',
      );
    }
  }

  void dispose() {
    _client.close();
  }
}