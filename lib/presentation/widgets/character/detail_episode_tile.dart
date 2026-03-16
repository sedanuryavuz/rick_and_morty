import 'package:flutter/material.dart';
import 'package:rick_and_morty/data/models/episode_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';

class DetailEpisodeTile extends StatelessWidget {
  final EpisodeModel episodeModel;

  const DetailEpisodeTile({
    super.key,
    required this.episodeModel,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 24,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF041811).withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  episodeModel.name,
                  style: AppTextStyles.cardTitle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                episodeModel.code,
                style: AppTextStyles.pageSubtitle.copyWith(
                  fontSize: 17,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}