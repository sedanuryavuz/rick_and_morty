import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';

class EpisodePreviewCard extends StatelessWidget {
  final String name;
  final String code;
  final String airDate;

  const EpisodePreviewCard({
    super.key,
    required this.name,
    required this.code,
    required this.airDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              code,
              style: AppTextStyles.label.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: AppTextStyles.cardTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  airDate,
                  style: AppTextStyles.label,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}