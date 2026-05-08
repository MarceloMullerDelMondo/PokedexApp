import 'dart:convert';
import 'package:http/http.dart' as http;

class PokemonService {
  static const String _base = 'https://pokeapi.co/api/v2';

  /// Busca os primeiros 20 Pokémon e retorna lista de nomes
  static Future<List<String>> fetchPokemonNames() async {
    final response = await http.get(Uri.parse('$_base/pokemon?limit=20'));
    if (response.statusCode != 200) {
      throw Exception('Erro ${response.statusCode}');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>;
    return results
        .map((item) => (item as Map<String, dynamic>)['name'] as String)
        .toList();
  }

  /// Busca Pokémon pelo nome; lança exceção se não existir (404)
  static Future<List<String>> fetchPokemonByName(String name) async {
    final response = await http.get(
      Uri.parse('$_base/pokemon/${name.toLowerCase()}'),
    );
    if (response.statusCode == 404) {
      throw Exception('Pokémon "$name" não encontrado');
    }
    if (response.statusCode != 200) {
      throw Exception('Erro ${response.statusCode}');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return [data['name'] as String];
  }

  /// Busca detalhes completos: name, spriteUrl, types
  static Future<Map<String, dynamic>> fetchPokemonDetails(String name) async {
    final response = await http.get(
      Uri.parse('$_base/pokemon/${name.toLowerCase()}'),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ${response.statusCode}');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    // Sprite com fallback para CDN
    final sprites = data['sprites'] as Map<String, dynamic>;
    final id = data['id'] as int;
    final spriteUrl =
        (sprites['front_default'] as String?) ??
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

    // Tipos como lista de strings
    final rawTypes = data['types'] as List<dynamic>;
    final types = rawTypes
        .map(
          (t) =>
              ((t as Map<String, dynamic>)['type']
                      as Map<String, dynamic>)['name']
                  as String,
        )
        .toList();

    return {
      'name': data['name'] as String,
      'spriteUrl': spriteUrl,
      'types': types,
    };
  }
}
