class Pokemon {
  final String name;
  final int id;
  final double height;
  final double weight;
  final List<String> types;
  final Map<String, int> stats;

  Pokemon({
    required this.name,
    required this.id,
    required this.height,
    required this.weight,
    required this.types,
    required this.stats,
  });

  String get imageUrl => 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      id: json['id'],
      height: json['height'] / 10, // Convertir a metros
      weight: json['weight'] / 10, // Convertir a kg
      types: (json['types'] as List).map((t) => t['type']['name'] as String).toList(),
      stats: {
        for (var stat in json['stats']) stat['stat']['name']: stat['base_stat'],
      },
    );
  }
}
