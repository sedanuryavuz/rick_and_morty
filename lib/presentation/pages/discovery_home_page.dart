import 'package:flutter/material.dart';
import 'package:rick_and_morty/data/models/character_response_model.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/network/api_client.dart';

import '../../data/models/character_model.dart';
import '../../data/models/episode_model.dart';

import '../../data/repositories/character_repository.dart';
import '../../data/services/character_service.dart';
import '../../data/services/episode_service.dart';

import '../widgets/common/app_search_bar.dart';
import '../widgets/episode/episode_preview_card.dart';
import '../widgets/home/featured_universe_card.dart';
import '../widgets/home/story_category_item.dart';
import '../widgets/home/trending_character_card.dart';

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

    _characterRepository =
        CharacterRepository(CharacterService(ApiClient()));

    _episodeService = EpisodeService();

    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        _characterRepository.getCharacters(page: 1),
        _episodeService.fetchEpisodes(page: 1),
      ]);

      final charactersResponse = results[0] as CharacterResponseModel;
      final episodesResponse = results[1] as List<EpisodeModel>;

      setState(() {
        storyCharacters = charactersResponse.results.take(6).toList();
        trendingCharacters = charactersResponse.results.take(4).toList();
        latestEpisodes = episodesResponse.take(5).toList();
        isLoading = false;
      });
    } catch (e) {
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
    const String kRickMortyHeaderImage =
        'https://upload.wikimedia.org/wikipedia/commons/b/b1/Rick_and_Morty.svg';

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
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
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Center(
                  child: Image.network(
                    kRickMortyHeaderImage,
                    height: 64,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) {
                      return Text(
                        'Rick & Morty',
                        style: AppTextStyles.pageTitle,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 22),

              GestureDetector(
                onTap: _goToSearchResults,
                child: AbsorbPointer(
                  child: AppSearchBar(
                    hintText: 'Search characters',
                    onChanged: (_) {},
                  ),
                ),
              ),

              const SizedBox(height: 26),

              Text(
                'Quick Discover',
                style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
              ),

              const SizedBox(height: 14),

              SizedBox(
                height: 102,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: storyCharacters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final character = storyCharacters[index];

                    return StoryCategoryItem(
                      title: character.name,
                      imageUrl: character.image,
                      onTap: () => _openCharacter(character),
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              FeaturedUniverseCard(
                onTap: _goToSearchResults,
              ),

              const SizedBox(height: 28),

              Text(
                'Trending Characters',
                style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
              ),

              const SizedBox(height: 14),

              SizedBox(
                height: 230,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: trendingCharacters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final character = trendingCharacters[index];

                    return TrendingCharacterCard(
                      character: character,
                      onTap: () => _openCharacter(character),
                    );
                  },
                ),
              ),

              const SizedBox(height: 26),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Latest Episodes',
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 150,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: latestEpisodes.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final episode = latestEpisodes[index];

                          return EpisodePreviewCard(
                            name: episode.name,
                            code: episode.code,
                            airDate: episode.airDate,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}