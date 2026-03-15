import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../widgets/character/detail_avatar.dart';
import '../widgets/character/detail_episode_tile.dart';
import '../widgets/character/detail_header.dart';
import '../widgets/character/detail_info_card.dart';
import '../widgets/character/detail_status_row.dart';

class CharacterDetailPage extends StatelessWidget {
  final String name;
  final String status;
  final String species;
  final String imageUrl;
  final String origin;
  final String location;
  final String gender;
  final List<Map<String, String>> episodes;

  const CharacterDetailPage({
    super.key,
    required this.name,
    required this.status,
    required this.species,
    required this.imageUrl,
    required this.origin,
    required this.location,
    required this.gender,
    required this.episodes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundTop,
              AppColors.backgroundBottom,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(28, 18, 28, 24),
                  children: [
                    DetailHeader(
                      title: 'Character Details',
                      onBackTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 34),
                    Center(
                      child: DetailAvatar(imageUrl: imageUrl),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.pageTitle.copyWith(
                        fontSize: 38,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 18),
                    DetailStatusRow(
                      status: status,
                      species: species,
                    ),
                    const SizedBox(height: 30),
                    DetailInfoCard(
                      origin: origin,
                      location: location,
                      gender: gender,
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Episodes',
                      style: AppTextStyles.cardTitle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...episodes.map(
                          (episode) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: DetailEpisodeTile(
                          title: episode['name'] ?? '',
                          code: episode['code'] ?? '',
                          onTap: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}