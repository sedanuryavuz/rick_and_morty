import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';

class DetailHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBackTap;

  const DetailHeader({
    super.key,
    required this.title,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.65),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onBackTap,
            icon: const Icon(
              Icons.arrow_back_rounded,
              size: 34,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.pageTitle.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 72),
      ],
    );
  }
}