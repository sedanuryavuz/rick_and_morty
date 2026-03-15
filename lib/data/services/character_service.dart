import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/character_response_model.dart';

class CharacterService {
  final ApiClient _apiClient;

  CharacterService(this._apiClient);

  Future<CharacterResponseModel> fetchCharacters({
    int page = 1,
    String? name,
    String? status,
  }) async {
    final queryParameters = <String, String>{
      'page': '$page',
    };

    if (name != null && name.trim().isNotEmpty) {
      queryParameters['name'] = name.trim();
    }

    if (status != null &&
        status.trim().isNotEmpty &&
        status.toLowerCase() != 'all') {
      queryParameters['status'] = status.toLowerCase();
    }

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.characterEndpoint}',
    ).replace(queryParameters: queryParameters);

    final json = await _apiClient.get(uri);
    return CharacterResponseModel.fromJson(json);
  }
}