import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/network/api_client.dart';
import '../data/repositories/character_repository.dart';
import '../data/repositories/episode_repository.dart';
import '../data/services/character_service.dart';
import '../data/services/episode_service.dart';
import '../presentation/pages/discovery_home_page.dart';
import 'theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>(
          create: (_) => ApiClient(),
        ),
        Provider<CharacterRepository>(
          create: (context) => CharacterRepository(
            CharacterService(
              context.read<ApiClient>(),
            ),
          ),
        ),
        Provider<EpisodeService>(
          create: (_) => EpisodeService(),
        ),
        Provider<EpisodeRepository>(
          create: (_) => EpisodeRepository(
            EpisodeService(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Rick & Morty',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const DiscoveryHomePage(),
      ),
    );
  }
}