import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

enum CharacterStatus {
  all,
  alive,
  dead,
  unknown;

  String get label {
    switch (this) {
      case CharacterStatus.all:
        return 'All';
      case CharacterStatus.alive:
        return 'Alive';
      case CharacterStatus.dead:
        return 'Dead';
      case CharacterStatus.unknown:
        return 'Unknown';
    }
  }

  String get apiValue {
    switch (this) {
      case CharacterStatus.all:
        return '';
      case CharacterStatus.alive:
        return 'alive';
      case CharacterStatus.dead:
        return 'dead';
      case CharacterStatus.unknown:
        return 'unknown';
    }
  }

  Color get color {
    switch (this) {
      case CharacterStatus.alive:
        return AppColors.alive;
      case CharacterStatus.dead:
        return AppColors.dead;
      case CharacterStatus.unknown:
        return AppColors.unknown;
      case CharacterStatus.all:
        return AppColors.unknown;
    }
  }

  static CharacterStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'alive':
        return CharacterStatus.alive;
      case 'dead':
        return CharacterStatus.dead;
      case 'unknown':
        return CharacterStatus.unknown;
      default:
        return CharacterStatus.unknown;
    }
  }
}