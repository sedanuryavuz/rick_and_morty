import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/network/api_client.dart';

import '../../data/models/character_model.dart';
import '../../data/models/episode_model.dart';

import '../../data/repositories/character_repository.dart';
import '../../data/services/character_service.dart';
import '../../data/services/episode_service.dart';

import '../widgets/home/discovery_header.dart';
import '../widgets/home/featured_universe_card.dart';
import '../widgets/home/latest_episodes_section.dart';
import '../widgets/home/quick_discover_section.dart';

import '../widgets/home/trending_characters_section.dart';
import 'character_detail_page.dart';
import 'character_list_page.dart';

class DiscoveryHomePage extends StatefulWidget {
  const DiscoveryHomePage({super.key});

  @override
  State<DiscoveryHomePage> createState() => _DiscoveryHomePageState();
}

class _DiscoveryHomePageState extends State<DiscoveryHomePage> {
  late final CharacterRepository _characterRepository;
  late final EpisodeService _episodeService;

  List<CharacterModel> storyCharacters = [];
  List<CharacterModel> trendingCharacters = [];
  List<EpisodeModel> latestEpisodes = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _characterRepository = CharacterRepository(CharacterService(ApiClient()));
    _episodeService = EpisodeService();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final charactersResponse =
      await _characterRepository.getCharacters(page: 1);
      final episodesResponse =
      await _episodeService.fetchEpisodes(page: 1);

      setState(() {
        storyCharacters = charactersResponse.results.take(6).toList();
        trendingCharacters = charactersResponse.results.take(4).toList();
        latestEpisodes = episodesResponse.take(5).toList();
        isLoading = false;
      });
    } catch (_) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _openCharacter(CharacterModel character) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CharacterDetailPage(
          characterModel: character,
        ),
      ),
    );
  }

  void _goToSearchResults() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CharacterListPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundTop,
              AppColors.backgroundBottom,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
            children: [
              DiscoveryHeader(onSearchTap: _goToSearchResults),
              const SizedBox(height: 26),
              QuickDiscoverSection(
                characters: storyCharacters,
                onCharacterTap: _openCharacter,
              ),
              const SizedBox(height: 28),
              FeaturedUniverseCard(
                onTap: _goToSearchResults,
              ),
              const SizedBox(height: 28),
              TrendingCharactersSection(
                characters: trendingCharacters,
                onCharacterTap: _openCharacter,
              ),
              const SizedBox(height: 26),
              LatestEpisodesSection(
                episodes: latestEpisodes,
              ),
            ],
          ),
        ),
      ),
    );
  }
}