import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'pokemon_model.dart';

class PokemonService {
  final String _baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  Future<List<Pokemon>> fetchPokemonList({required int offset, int limit = 20}) async {
    final response = await http.get(Uri.parse('$_baseUrl?offset=$offset&limit=$limit'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Pokemon> pokemonList = [];

      for (var result in data['results']) {
        Pokemon pokemon = await fetchPokemonDetails(result['url']);
        pokemonList.add(pokemon);
      }

      return pokemonList;
    } else {
      throw Exception('Error al obtener la lista de Pokémon');
    }
  }

  Future<Pokemon> fetchPokemonDetails(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Pokemon.fromJson(data);
    } else {
      throw Exception('Error al obtener detalles del Pokémon');
    }
  }

  // METODE PER ORDENAR ALFABETICAMENT
  List<Pokemon> sortPokemonList(List<Pokemon> pokemonList, bool isAscending) {
    pokemonList.sort((a, b) => isAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
    return pokemonList;
  }

  // ✅ METODE PER A POKEMON ALEATORI
  Future<Pokemon> fetchRandomPokemon() async {
    final random = Random();
    int randomId = random.nextInt(898) + 1; // Hay 898 Pokémon en la API oficial
    return await fetchPokemonDetails('$_baseUrl/$randomId');
  }
}
