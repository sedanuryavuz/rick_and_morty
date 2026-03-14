import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../data/models/mock_data.dart';
import '../widgets/common/app_search_bar.dart';
import '../widgets/episode/episode_preview_card.dart';
import '../widgets/home/featured_universe_card.dart';
import '../widgets/home/story_category_item.dart';
import '../widgets/home/trending_character_card.dart';
import 'home_page.dart';

class DiscoveryHomePage extends StatefulWidget {
  const DiscoveryHomePage({super.key});

  @override
  State<DiscoveryHomePage> createState() => _DiscoveryHomePageState();
}

class _DiscoveryHomePageState extends State<DiscoveryHomePage> {
  void _goToSearchResults({
    String initialQuery = '',
    String initialFilter = 'All',
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String kRickMortyHeaderImage =
        'https://commons.wikimedia.org/wiki/Special:Redirect/file/Rick%20and%20Morty%20title%20card.png';
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
                onTap: () {
                  _goToSearchResults();
                },
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
                  itemCount: MockData.stories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final item = MockData.stories[index];

                    return StoryCategoryItem(
                      title: item.title,
                      imageUrl: item.image,
                      onTap: () {
                        _goToSearchResults(
                          initialQuery: item.query,
                          initialFilter: item.title == 'Alive'
                              ? 'Alive'
                              : item.title == 'Dead'
                              ? 'Dead'
                              : 'All',
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              FeaturedUniverseCard(
                onTap: () {
                  _goToSearchResults();
                },
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
                  itemCount: MockData.trendingCharacters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final trending = MockData.trendingCharacters[index];

                    return TrendingCharacterCard(
                      imageUrl: trending.image,
                      name: trending.name,
                      status: trending.status,
                      onTap: () {
                        _goToSearchResults(
                          initialQuery: trending.name,
                        );
                      },
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
                        itemCount: MockData.latestEpisodes.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final episodes = MockData.latestEpisodes[index];

                          return EpisodePreviewCard(
                            name: episodes.name,
                            code: episodes.code,
                            airDate: episodes.date,
                            onTap: () {},
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