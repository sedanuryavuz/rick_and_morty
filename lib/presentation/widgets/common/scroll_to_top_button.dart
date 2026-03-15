import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class ScrollToTopButton extends StatelessWidget {
  final VoidCallback onTap;

  const ScrollToTopButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.black,
      child: const Icon(Icons.keyboard_arrow_up_rounded),
    );
  }
}