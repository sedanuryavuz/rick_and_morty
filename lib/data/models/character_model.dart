class CharacterModel {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String image;
  final String originName;
  final String locationName;
  final List<String> episodeUrls;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.image,
    required this.originName,
    required this.locationName,
    required this.episodeUrls,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      species: json['species'] as String? ?? '',
      type: json['type'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      image: json['image'] as String? ?? '',
      originName:
      (json['origin'] as Map<String, dynamic>?)?['name'] as String? ?? '',
      locationName:
      (json['location'] as Map<String, dynamic>?)?['name'] as String? ?? '',
      episodeUrls: (json['episode'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}