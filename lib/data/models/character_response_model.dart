import 'character_model.dart';

class CharacterResponseModel {
  final int count;
  final int pages;
  final String? next;
  final String? prev;
  final List<CharacterModel> results;

  const CharacterResponseModel({
    required this.count,
    required this.pages,
    required this.next,
    required this.prev,
    required this.results,
  });

  factory CharacterResponseModel.fromJson(Map<String, dynamic> json) {
    final info = json['info'] as Map<String, dynamic>? ?? {};
    final results = json['results'] as List<dynamic>? ?? [];

    return CharacterResponseModel(
      count: info['count'] as int? ?? 0,
      pages: info['pages'] as int? ?? 0,
      next: info['next'] as String?,
      prev: info['prev'] as String?,
      results: results
          .map((item) => CharacterModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}