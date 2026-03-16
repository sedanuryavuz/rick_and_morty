import 'package:flutter/material.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../data/models/character_model.dart';
import 'story_category_item.dart';

class QuickDiscoverSection extends StatelessWidget {
  final List<CharacterModel> characters;
  final ValueChanged<CharacterModel> onCharacterTap;

  const QuickDiscoverSection({
    super.key,
    required this.characters,
    required this.onCharacterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Discover',
          style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 102,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: characters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final character = characters[index];

              return StoryCategoryItem(
                characterModel: character,
                onTap: () => onCharacterTap(character),
              );
            },
          ),
        ),
      ],
    );
  }
}