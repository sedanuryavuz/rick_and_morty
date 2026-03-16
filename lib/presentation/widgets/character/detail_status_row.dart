import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../data/models/character_model.dart';

class DetailStatusRow extends StatelessWidget {
  final CharacterModel characterModel;

  const DetailStatusRow({
    super.key,
    required this.characterModel,
  });

  @override
  Widget build(BuildContext context) {
    final color = characterModel.status.color;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                characterModel.status.label,
                style: TextStyle(
                  color: color,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 28),
        Text(
          characterModel.species,
          style: AppTextStyles.pageSubtitle.copyWith(
            fontSize: 17,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}