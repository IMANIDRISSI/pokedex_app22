import 'package:shared_preferences/shared_preferences.dart';
//CLASSE PER A QUE SEM GUARDI EL LIKE DE FAVORITO AMB SHAREDPREFERENCES
class FavoritesService {
  static const String _favoritesKey = 'favorite_pokemon_ids';

  Future<void> saveFavorite(int pokemonId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];

    if (!favorites.contains(pokemonId.toString())) {
      favorites.add(pokemonId.toString());
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  Future<void> removeFavorite(int pokemonId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];

    favorites.remove(pokemonId.toString());
    await prefs.setStringList(_favoritesKey, favorites);
  }

  Future<List<int>> getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];

    return favorites.map((id) => int.parse(id)).toList();
  }

  Future<bool> isFavorite(int pokemonId) async {
    List<int> favorites = await getFavorites();
    return favorites.contains(pokemonId);
  }
}
