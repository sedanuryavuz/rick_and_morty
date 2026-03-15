import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../data/models/character_model.dart';
import '../../data/models/mock_data.dart';
import '../widgets/character/character_preview_card.dart';
import '../widgets/common/app_search_bar.dart';
import '../widgets/common/filter_chip.dart';
import 'character_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedFilterIndex = 0;
  String searchQuery = '';

  List<CharacterModel> get filteredCharacters {
    return MockData.allCharacters.where((character) {
      final matchesSearch = character.name
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      final selectedFilter = MockData.filters[selectedFilterIndex].toLowerCase();

      final matchesFilter = selectedFilter == 'all'
          ? true
          : character.status.toLowerCase() == selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = filteredCharacters;

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
          child: Column(

            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(alpha: 0.7),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              color: AppColors.textPrimary,
                              size: 28,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Character Search',
                                style: AppTextStyles.pageTitle.copyWith(fontSize: 24),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Search and explore Rick & Morty characters.',
                                style: AppTextStyles.pageSubtitle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const SizedBox(height: 22),
                    AppSearchBar(
                      hintText: 'Search characters',
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 44,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: MockData.filters.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          return FilterChipItem(
                            title: MockData.filters[index],
                            isSelected: selectedFilterIndex == index,
                            onTap: () {
                              setState(() {
                                selectedFilterIndex = index;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '${results.length} result${results.length == 1 ? '' : 's'}',
                      style: AppTextStyles.label,
                    ),
                    const SizedBox(height: 14),
                    if (results.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 28,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.search_off_rounded,
                              color: AppColors.textSecondary,
                              size: 34,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No characters found',
                              style: AppTextStyles.cardTitle,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Try a different name or change the selected filter.',
                              style: AppTextStyles.cardSubtitle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    else
                      ...results.map(
                            (character) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CharacterPreviewCard(
                            imageUrl: character.image,
                            name: character.name,
                            status: character.status,
                            species: character.species,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CharacterDetailPage(
                                    name: character.name,
                                    status: character.status,
                                    species: character.species,
                                    imageUrl: character.image,
                                    origin: character.name == 'Rick Sanchez'
                                        ? 'Earth (C-137)'
                                        : 'Unknown',
                                    location: character.name == 'Rick Sanchez'
                                        ? 'Citadel of Ricks'
                                        : 'Unknown',
                                    gender: character.name == 'Rick Sanchez'
                                        ? 'Male'
                                        : 'Unknown',
                                    episodes: MockData.characterDetailEpisodes,
                                  ),
                                ),
                              );
                            },
                          ),
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