class Pokemon {
  final String name;
  final String spriteUrl;
  final List<int> typeIds;
  int level;
  final List<String> moves;
  final double? latitude;
  final double? longitude;

  Pokemon({
    required this.name,
    required this.spriteUrl,
    required this.typeIds,
    required this.level,
    this.moves = const [],
    this.latitude,
    this.longitude,
  });

  bool get hasLocation => latitude != null && longitude != null;

  String get typeSpriteUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/types/generation-iii/firered-leafgreen/';

  factory Pokemon.fromDoc(Map<String, dynamic> data) {
    String spriteUrl = '';
    final raw = data['spriteUrl'];
    if (raw is String && raw.isNotEmpty) {
      spriteUrl = raw;
    } else {
      final id = data['spriteId'];
      if (id != null) {
        spriteUrl =
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
      }
    }

    return Pokemon(
      name: data['name'] ?? '',
      spriteUrl: spriteUrl,
      typeIds: const [],
      level: data['level'] ?? 1,
      moves: List<String>.from(data['moves'] ?? []),
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
    );
  }
}
