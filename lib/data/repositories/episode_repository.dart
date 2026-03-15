import '../models/episode_model.dart';
import '../services/episode_service.dart';

class EpisodeRepository {
  final EpisodeService _service;

  EpisodeRepository(this._service);

  Future<List<EpisodeModel>> getEpisodesByIds(List<int> ids) {
    return _service.fetchMultipleEpisodes(ids);
  }
}