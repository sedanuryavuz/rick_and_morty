import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';

class FeaturedUniverseCard extends StatelessWidget {
  final VoidCallback onTap;

  const FeaturedUniverseCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 205,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF14352A),
              Color(0xFF0A1E25),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              top: 10,
              bottom: 10,
              child: Container(
                width: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              right: 15,
              top: 34,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Image.network(
                  'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
                  width: 130,
                  height: 136,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: SizedBox(
                width: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Dimension C-137',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Enter the\nMultiverse',
                      style: AppTextStyles.pageTitle.copyWith(height: 1.05),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Find characters across infinite realities.',
                      style: AppTextStyles.cardSubtitle,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}