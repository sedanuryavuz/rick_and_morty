import 'package:flutter/material.dart';
import '../../data/models/episode_model.dart';
import '../../data/repositories/episode_repository.dart';

class CharacterDetailProvider extends ChangeNotifier {
  final EpisodeRepository episodeRepository;

  CharacterDetailProvider(this.episodeRepository);

  List<EpisodeModel> _episodes = [];
  bool _isLoadingEpisodes = false;
  String? _episodeError;

  List<EpisodeModel> get episodes => _episodes;
  bool get isLoadingEpisodes => _isLoadingEpisodes;
  String? get episodeError => _episodeError;

  List<int> _extractEpisodeIds(List<String> urls) {
    return urls
        .map((url) => int.tryParse(url.split('/').last))
        .whereType<int>()
        .toList();
  }

  Future<void> loadEpisodes(List<String> episodeUrls) async {
    _isLoadingEpisodes = true;
    _episodeError = null;
    notifyListeners();

    try {
      final ids = _extractEpisodeIds(episodeUrls);

      if (ids.isEmpty) {
        _episodes = [];
        _isLoadingEpisodes = false;
        notifyListeners();
        return;
      }

      final result = await episodeRepository.getEpisodesByIds(ids);
      _episodes = result;
      _isLoadingEpisodes = false;
      notifyListeners();
    } catch (e) {
      _episodes = [];
      _episodeError = 'Episodes could not be loaded.';
      _isLoadingEpisodes = false;
      notifyListeners();
    }
  }

  void clear() {
    _episodes = [];
    _isLoadingEpisodes = false;
    _episodeError = null;
    notifyListeners();
  }
}