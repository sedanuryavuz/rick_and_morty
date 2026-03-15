import 'package:flutter/material.dart';
import 'package:rick_and_morty/data/models/character_model.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../data/models/episode_model.dart';
import '../../data/repositories/episode_repository.dart';
import '../../data/services/episode_service.dart';

import '../widgets/character/detail_avatar.dart';
import '../widgets/character/detail_episode_tile.dart';
import '../widgets/character/detail_header.dart';
import '../widgets/character/detail_info_card.dart';
import '../widgets/character/detail_status_row.dart';
import '../widgets/common/scroll_to_top_button.dart';

class CharacterDetailPage extends StatefulWidget {
  final CharacterModel characterModel;
  const CharacterDetailPage({
    super.key,
    required this.characterModel,
  });

  @override
  State<CharacterDetailPage> createState() => _CharacterDetailPageState();
}

class _CharacterDetailPageState extends State<CharacterDetailPage> {
  late final EpisodeRepository _episodeRepository;
  late final ScrollController _scrollController;

  List<EpisodeModel> episodes = [];

  bool isLoadingEpisodes = true;
  bool showScrollToTop = false;

  String? episodeError;

  @override
  void initState() {
    super.initState();

    _episodeRepository = EpisodeRepository(
      EpisodeService(),
    );

    _scrollController = ScrollController()..addListener(_onScroll);

    _loadEpisodes();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.offset > 500 && !showScrollToTop) {
      setState(() {
        showScrollToTop = true;
      });
    } else if (_scrollController.offset <= 500 && showScrollToTop) {
      setState(() {
        showScrollToTop = false;
      });
    }
  }

  Future<void> _scrollToTop() async {
    await _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  List<int> _extractEpisodeIds(List<String> urls) {
    return urls
        .map((url) => int.tryParse(url.split('/').last))
        .whereType<int>()
        .toList();
  }

  Future<void> _loadEpisodes() async {
    setState(() {
      isLoadingEpisodes = true;
      episodeError = null;
    });

    try {
      final ids = _extractEpisodeIds(widget.characterModel.episodeUrls);
      final result = await _episodeRepository.getEpisodesByIds(ids);

      setState(() {
        episodes = result;
        isLoadingEpisodes = false;
      });
    } catch (e) {
      setState(() {
        episodes = [];
        episodeError = e.toString();
        isLoadingEpisodes = false;
      });
    }
  }

  Widget _buildEpisodeSection() {
    if (isLoadingEpisodes) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (episodeError != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          'Episodes could not be loaded.',
          style: AppTextStyles.cardSubtitle,
        ),
      );
    }

    if (episodes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          'No episodes found.',
          style: AppTextStyles.cardSubtitle,
        ),
      );
    }

    return Column(
      children: episodes
          .map(
            (episode) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: DetailEpisodeTile(
            title: episode.name,
            code: episode.code,
            onTap: () {},
          ),
        ),
      )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: showScrollToTop
          ? ScrollToTopButton(
        onTap: _scrollToTop,
      )
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
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(28, 18, 28, 24),
            children: [
              DetailHeader(
                title: 'Character Details',
                onBackTap: () => Navigator.pop(context),
              ),

              const SizedBox(height: 34),

              Center(
                child: DetailAvatar(
                  imageUrl: widget.characterModel.image,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                widget.characterModel.name,
                textAlign: TextAlign.center,
                style: AppTextStyles.pageTitle.copyWith(
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ),

              const SizedBox(height: 18),

              DetailStatusRow(
                status: widget.characterModel.status.label,
                species: widget.characterModel.species,
              ),

              const SizedBox(height: 30),

              DetailInfoCard(
                origin: widget.characterModel.originName,
                location: widget.characterModel.locationName,
                gender: widget.characterModel.gender,
              ),

              const SizedBox(height: 28),

              Text(
                'Episodes',
                style: AppTextStyles.cardTitle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 16),

              _buildEpisodeSection(),
            ],
          ),
        ),
      ),
    );
  }
}