import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/enums/character_status.dart';
import '../../core/network/api_client.dart';
import '../../data/models/character_model.dart';
import '../../data/repositories/character_repository.dart';
import '../../data/services/character_service.dart';
import '../widgets/character/character_preview_card.dart';
import '../widgets/common/app_search_bar.dart';
import '../widgets/common/filter_chip.dart';
import '../widgets/common/scroll_to_top_button.dart';
import 'character_detail_page.dart';

class CharacterListPage extends StatefulWidget {
  const CharacterListPage({super.key});

  @override
  State<CharacterListPage> createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  late final CharacterRepository _repository;
  late final ScrollController _scrollController;

  final List<CharacterStatus> filters = CharacterStatus.values;

  int selectedFilterIndex = 0;
  String searchQuery = '';

  List<CharacterModel> characters = [];

  bool isInitialLoading = true;
  bool isPaginationLoading = false;
  bool isRefreshing = false;
  bool hasMore = true;
  bool showScrollToTop = false;

  String? errorMessage;

  int currentPage = 1;
  int totalCount = 0;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _repository = CharacterRepository(CharacterService(ApiClient()));

    _scrollController = ScrollController()..addListener(_onScroll);

    _loadInitialCharacters();
  }

  @override
  void dispose() {
    _debounce?.cancel();
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
      _loadMoreCharacters();
    }
  }

  Future<void> _loadInitialCharacters() async {
    final bool firstLoad = characters.isEmpty;

    setState(() {
      if (firstLoad) {
        isInitialLoading = true;
      } else {
        isRefreshing = true;
      }

      errorMessage = null;
      currentPage = 1;
      hasMore = true;
    });

    try {
      final response = await _repository.getCharacters(
        page: 1,
        name: searchQuery.trim(),
        status: filters[selectedFilterIndex].apiValue,
      );

      setState(() {
        characters = response.results;
        totalCount = response.count;
        currentPage = 1;
        hasMore = response.next != null;
        isInitialLoading = false;
        isRefreshing = false;
      });
    } catch (e) {
      setState(() {
        characters = [];
        totalCount = 0;
        errorMessage = e.toString();
        hasMore = false;
        isInitialLoading = false;
        isRefreshing = false;
      });
    }
  }

  Future<void> _loadMoreCharacters() async {
    if (isInitialLoading || isPaginationLoading || !hasMore) return;

    setState(() {
      isPaginationLoading = true;
    });

    final nextPage = currentPage + 1;

    try {
      final response = await _repository.getCharacters(
        page: nextPage,
        name: searchQuery.trim(),
        status: filters[selectedFilterIndex].apiValue,
      );

      setState(() {
        characters.addAll(response.results);
        totalCount = response.count;
        currentPage = nextPage;
        hasMore = response.next != null;
        isPaginationLoading = false;
      });
    } catch (_) {
      setState(() {
        isPaginationLoading = false;
      });
    }
  }

  void _onSearchChanged(String value) {
    searchQuery = value;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _loadInitialCharacters();
    });
  }

  void _onFilterChanged(int index) {
    setState(() {
      selectedFilterIndex = index;
    });
    _loadInitialCharacters();
  }

  Future<void> _scrollToTop() async {
    await _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildHeader() {
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
                totalCount > 0
                    ? '${characters.length} / $totalCount characters'
                    : 'Search and explore Rick & Morty characters.',
                style: AppTextStyles.pageSubtitle,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return FilterChipItem(
            title: filters[index].label,
            isSelected: selectedFilterIndex == index,
            onTap: () => _onFilterChanged(index),
          );
        },
      ),
    );
  }

  Widget _buildErrorState() {
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
            errorMessage!,
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

  Widget _buildCharacterList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount:
          characters.length +
          (isPaginationLoading ? 1 : 0) +
          (!hasMore && characters.isNotEmpty ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < characters.length) {
          final character = characters[index];

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

        if (isPaginationLoading && index == characters.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
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
    final showEmpty =
        !isInitialLoading && errorMessage == null && characters.isEmpty;

    return Scaffold(
      floatingActionButton: showScrollToTop
          ? ScrollToTopButton(onTap: _scrollToTop)
          : null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 22),
                AppSearchBar(
                  hintText: 'Search characters',
                  onChanged: _onSearchChanged,
                ),
                const SizedBox(height: 18),
                _buildFilters(),
                const SizedBox(height: 14),

                if (isRefreshing) const LinearProgressIndicator(),

                const SizedBox(height: 10),

                Expanded(
                  child: isInitialLoading
                      ? const Center(child: CircularProgressIndicator())
                      : errorMessage != null
                      ? Center(child: _buildErrorState())
                      : showEmpty
                      ? Center(child: _buildEmptyState())
                      : _buildCharacterList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
