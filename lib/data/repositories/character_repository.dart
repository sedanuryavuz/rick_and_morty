import '../models/character_response_model.dart';
import '../services/character_service.dart';

class CharacterRepository {
  final CharacterService _service;

  CharacterRepository(this._service);

  Future<CharacterResponseModel> getCharacters({
    required int page,
    String? name,
    String? status,
  }) {
    return _service.fetchCharacters(
      page: page,
      name: name,
      status: status,
    );
  }
}