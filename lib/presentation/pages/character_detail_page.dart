import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty/data/models/character_model.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../data/repositories/episode_repository.dart';
import '../../data/services/episode_service.dart';
import '../controllers/character_detail_provider.dart';

import '../widgets/character/detail_avatar.dart';
import '../widgets/character/detail_episode_tile.dart';
import '../widgets/character/detail_header.dart';
import '../widgets/character/detail_info_card.dart';
import '../widgets/character/detail_status_row.dart';
import '../widgets/common/scroll_to_top_button.dart';

class CharacterDetailPage extends StatelessWidget {
  final CharacterModel characterModel;

  const CharacterDetailPage({
    super.key,
    required this.characterModel,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CharacterDetailProvider(
        EpisodeRepository(
          EpisodeService(),
        ),
      )..loadEpisodes(characterModel.episodeUrls),
      child: _CharacterDetailView(
        characterModel: characterModel,
      ),
    );
  }
}

class _CharacterDetailView extends StatefulWidget {
  final CharacterModel characterModel;

  const _CharacterDetailView({
    required this.characterModel,
  });

  @override
  State<_CharacterDetailView> createState() => _CharacterDetailViewState();
}

class _CharacterDetailViewState extends State<_CharacterDetailView> {
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

  Widget _buildEpisodeSection() {
    return Consumer<CharacterDetailProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingEpisodes) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (provider.episodeError != null) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              provider.episodeError!,
              style: AppTextStyles.cardSubtitle,
            ),
          );
        }

        if (provider.episodes.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'No episodes found.',
              style: AppTextStyles.cardSubtitle,
            ),
          );
        }

        return Column(
          children: provider.episodes
              .map(
                (episode) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: DetailEpisodeTile(
                episodeModel: episode,
              ),
            ),
          )
              .toList(),
        );
      },
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
                  characterModel: widget.characterModel,
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
                characterModel: widget.characterModel,
              ),
              const SizedBox(height: 30),
              DetailInfoCard(
                characterModel: widget.characterModel,
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