import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';

class DetailStatusRow extends StatelessWidget {
  final String status;
  final String species;

  const DetailStatusRow({
    super.key,
    required this.status,
    required this.species,
  });

  Color _statusColor() {
    switch (status.toLowerCase()) {
      case 'alive':
        return AppColors.alive;
      case 'dead':
        return AppColors.dead;
      default:
        return AppColors.unknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor();

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
                status,
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
          species,
          style: AppTextStyles.pageSubtitle.copyWith(
            fontSize: 17,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}