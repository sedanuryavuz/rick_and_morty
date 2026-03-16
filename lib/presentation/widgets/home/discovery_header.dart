import 'package:flutter/material.dart';
import '../../../app/theme/app_text_styles.dart';
import '../common/app_search_bar.dart';

class DiscoveryHeader extends StatelessWidget {
  final VoidCallback onSearchTap;

  const DiscoveryHeader({
    super.key,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    const String headerImage =
        'https://upload.wikimedia.org/wikipedia/commons/b/b1/Rick_and_Morty.svg';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 8),
          child: Center(
            child: Image.network(
              headerImage,
              height: 64,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) {
                return Text(
                  'Rick & Morty',
                  style: AppTextStyles.pageTitle,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 22),
        GestureDetector(
          onTap: onSearchTap,
          child: AbsorbPointer(
            child: AppSearchBar(
              hintText: 'Search characters',
              onChanged: (_) {},
            ),
          ),
        ),
      ],
    );
  }
}