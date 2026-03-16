import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../data/models/character_model.dart';
import '../controllers/character_list_provider.dart';
import '../widgets/character/character_preview_card.dart';
import '../widgets/common/app_search_bar.dart';
import '../widgets/common/filter_chip.dart';
import '../widgets/common/scroll_to_top_button.dart';
import 'character_detail_page.dart';

class CharacterListPage extends StatelessWidget {
  const CharacterListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CharacterListProvider(
        context.read(),
      )..loadInitialCharacters(),
      child: const _CharacterListView(),
    );
  }
}

class _CharacterListView extends StatefulWidget {
  const _CharacterListView();

  @override
  State<_CharacterListView> createState() => _CharacterListViewState();
}

class _CharacterListViewState extends State<_CharacterListView> {
  late final ScrollController _scrollController;

  bool showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    if (position.pixels > 500 && !showScrollToTop) {
      setState(() {
        showScrollToTop = true;
      });
    } else if (position.pixels <= 500 && showScrollToTop) {
      setState(() {
        showScrollToTop = false;
      });
    }

    if (position.pixels >= position.maxScrollExtent - 250) {
      context.read<CharacterListProvider>().loadMoreCharacters();
    }
  }

  Future<void> _scrollToTop() async {
    await _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildHeader(CharacterListProvider provider) {
    return Row(
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
                provider.totalCount > 0
                    ? '${provider.characters.length} / ${provider.totalCount} characters'
                    : 'Search and explore Rick & Morty characters.',
                style: AppTextStyles.pageSubtitle,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilters(CharacterListProvider provider) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: provider.filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return FilterChipItem(
            title: provider.filters[index].label,
            isSelected: provider.selectedFilterIndex == index,
            onTap: () => provider.onFilterChanged(index),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.textSecondary,
            size: 34,
          ),
          const SizedBox(height: 12),
          Text('Something went wrong', style: AppTextStyles.cardTitle),
          const SizedBox(height: 6),
          Text(
            errorMessage,
            style: AppTextStyles.cardSubtitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
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
          Text('No characters found', style: AppTextStyles.cardTitle),
          const SizedBox(height: 6),
          Text(
            'Try a different name or change the selected filter.',
            style: AppTextStyles.cardSubtitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterList(CharacterListProvider provider) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: provider.characters.length +
          (provider.isPaginationLoading ? 1 : 0) +
          (!provider.hasMore && provider.characters.isNotEmpty ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < provider.characters.length) {
          final CharacterModel character = provider.characters[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CharacterPreviewCard(
              character: character,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CharacterDetailPage(
                      characterModel: character,
                    ),
                  ),
                );
              },
            ),
          );
        }

        if (provider.isPaginationLoading &&
            index == provider.characters.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Text(
              'No more characters',
              style: AppTextStyles.cardSubtitle,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterListProvider>(
      builder: (context, provider, child) {
        final showEmpty = !provider.isInitialLoading &&
            provider.errorMessage == null &&
            provider.characters.isEmpty;

        return Scaffold(
          floatingActionButton: showScrollToTop
              ? ScrollToTopButton(onTap: _scrollToTop)
              : null,
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  children: [
                    _buildHeader(provider),
                    const SizedBox(height: 22),
                    AppSearchBar(
                      hintText: 'Search characters',
                      onChanged: provider.onSearchChanged,
                    ),
                    const SizedBox(height: 18),
                    _buildFilters(provider),
                    const SizedBox(height: 14),
                    if (provider.isRefreshing)
                      const LinearProgressIndicator(),
                    const SizedBox(height: 10),
                    Expanded(
                      child: provider.isInitialLoading
                          ? const Center(
                        child: CircularProgressIndicator(),
                      )
                          : provider.errorMessage != null
                          ? Center(
                        child: _buildErrorState(
                          provider.errorMessage!,
                        ),
                      )
                          : showEmpty
                          ? Center(child: _buildEmptyState())
                          : _buildCharacterList(provider),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}