import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/theme/app_colors.dart';
import '../../data/models/character_model.dart';
import '../../data/services/episode_service.dart';
import '../../data/repositories/character_repository.dart';
import '../controllers/discovery_home_provider.dart';

import '../widgets/home/discovery_header.dart';
import '../widgets/home/featured_universe_card.dart';
import '../widgets/home/latest_episodes_section.dart';
import '../widgets/home/quick_discover_section.dart';
import '../widgets/home/trending_characters_section.dart';
import 'character_detail_page.dart';
import 'character_list_page.dart';

class DiscoveryHomePage extends StatelessWidget {
  const DiscoveryHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DiscoveryHomeProvider(
        characterRepository: context.read<CharacterRepository>(),
        episodeService: context.read<EpisodeService>(),
      )..loadData(),
      child: const _DiscoveryHomeView(),
    );
  }
}

class _DiscoveryHomeView extends StatelessWidget {
  const _DiscoveryHomeView();

  void _openCharacter(BuildContext context, CharacterModel character) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CharacterDetailPage(
          characterModel: character,
        ),
      ),
    );
  }

  void _goToSearchResults(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CharacterListPage(),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: Colors.white70,
            ),
            const SizedBox(height: 12),
            const Text(
              'Something went wrong',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<DiscoveryHomeProvider>().loadData();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DiscoveryHomeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (provider.errorMessage != null) {
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
                child: _buildErrorState(context, provider.errorMessage!),
              ),
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
                  DiscoveryHeader(
                    onSearchTap: () => _goToSearchResults(context),
                  ),
                  const SizedBox(height: 26),
                  QuickDiscoverSection(
                    characters: provider.storyCharacters,
                    onCharacterTap: (character) =>
                        _openCharacter(context, character),
                  ),
                  const SizedBox(height: 28),
                  FeaturedUniverseCard(
                    onTap: () => _goToSearchResults(context),
                  ),
                  const SizedBox(height: 28),
                  TrendingCharactersSection(
                    characters: provider.trendingCharacters,
                    onCharacterTap: (character) =>
                        _openCharacter(context, character),
                  ),
                  const SizedBox(height: 26),
                  LatestEpisodesSection(
                    episodes: provider.latestEpisodes,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}