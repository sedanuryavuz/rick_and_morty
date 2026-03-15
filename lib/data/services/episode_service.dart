import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../../core/network/api_exception.dart';
import '../models/episode_model.dart';

class EpisodeService {
  final http.Client _client;

  EpisodeService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<EpisodeModel>> fetchMultipleEpisodes(List<int> ids) async {
    if (ids.isEmpty) return [];

    final idsPath = ids.join(',');
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.episodeEndpoint}/$idsPath');
    try {
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          return decoded
              .map((item) => EpisodeModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }

        if (decoded is Map<String, dynamic>) {
          return [EpisodeModel.fromJson(decoded)];
        }
      }

      throw ApiException(
        message: 'Failed to load episodes.',
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is ApiException) rethrow;

      throw const ApiException(
        message: 'Unexpected network error occurred while loading episodes.',
      );
    }
  }
  Future<List<EpisodeModel>> fetchEpisodes({int page = 1}) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.episodeEndpoint}?page=$page');

    try {
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);

        final results = decoded['results'] as List;

        return results
            .map((item) => EpisodeModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      throw ApiException(
        message: 'Failed to load episodes.',
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is ApiException) rethrow;

      throw const ApiException(
        message: 'Unexpected network error occurred while loading episodes.',
      );
    }
  }
  void dispose() {
    _client.close();
  }
}