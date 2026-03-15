import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';

class DetailInfoCard extends StatelessWidget {
  final String origin;
  final String location;
  final String gender;

  const DetailInfoCard({
    super.key,
    required this.origin,
    required this.location,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
      decoration: BoxDecoration(
        color: const Color(0xFF041811).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(34),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Character Information',
            style: AppTextStyles.cardTitle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 28),
          _InfoRow(label: 'Origin', value: origin),
          const SizedBox(height: 22),
          _InfoRow(label: 'Location', value: location),
          const SizedBox(height: 22),
          _InfoRow(label: 'Gender', value: gender),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.pageSubtitle.copyWith(
              fontSize: 17,
              color: AppColors.textMuted,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.cardTitle.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}