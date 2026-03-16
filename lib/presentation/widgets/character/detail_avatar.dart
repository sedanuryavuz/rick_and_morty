import 'package:flutter/material.dart';
import 'package:rick_and_morty/data/models/character_model.dart';
import '../../../app/theme/app_colors.dart';

class DetailAvatar extends StatelessWidget {
  final CharacterModel characterModel;

  const DetailAvatar({
    super.key,
    required this.characterModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      height: 190,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary,
          width: 5,
        ),
      ),
      child: ClipOval(
        child: Image.network(
          characterModel.image,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.surface,
            alignment: Alignment.center,
            child: const Icon(
              Icons.broken_image_outlined,
              color: AppColors.textSecondary,
              size: 44,
            ),
          ),
        ),
      ),
    );
  }
}