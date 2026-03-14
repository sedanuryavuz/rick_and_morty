import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';

class FilterChipItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterChipItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.chipBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
          ),
        ),
        child: Text(
          title,
          style: AppTextStyles.chip.copyWith(
            color: isSelected ? Colors.black : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}