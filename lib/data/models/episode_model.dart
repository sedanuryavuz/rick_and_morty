class EpisodeModel {
  final int id;
  final String name;
  final String airDate;
  final String code;

  const EpisodeModel({
    required this.id,
    required this.name,
    required this.airDate,
    required this.code,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      airDate: json['air_date'] as String? ?? '',
      code: json['episode'] as String? ?? '',
    );
  }
}