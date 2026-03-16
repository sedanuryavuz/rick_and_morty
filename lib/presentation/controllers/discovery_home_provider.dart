import 'package:flutter/material.dart';

import '../../data/models/character_model.dart';
import '../../data/models/episode_model.dart';
import '../../data/repositories/character_repository.dart';
import '../../data/services/episode_service.dart';

class DiscoveryHomeProvider extends ChangeNotifier {
  final CharacterRepository characterRepository;
  final EpisodeService episodeService;

  DiscoveryHomeProvider({
    required this.characterRepository,
    required this.episodeService,
  });

  List<CharacterModel> _storyCharacters = [];
  List<CharacterModel> get storyCharacters => _storyCharacters;

  List<CharacterModel> _trendingCharacters = [];
  List<CharacterModel> get trendingCharacters => _trendingCharacters;

  List<EpisodeModel> _latestEpisodes = [];
  List<EpisodeModel> get latestEpisodes => _latestEpisodes;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final charactersResponse = await characterRepository.getCharacters(page: 1);
      final episodesResponse = await episodeService.fetchEpisodes(page: 1);

      _storyCharacters = charactersResponse.results.take(6).toList();
      _trendingCharacters = charactersResponse.results.take(4).toList();
      _latestEpisodes = episodesResponse.take(5).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Home data could not be loaded.';
      notifyListeners();
    }
  }
}