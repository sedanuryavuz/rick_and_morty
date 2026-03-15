import 'package:flutter/material.dart';
import 'package:rick_and_morty/presentation/pages/discovery_home_page.dart';
import 'theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick & Morty',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const DiscoveryHomePage(),
    );
  }
}