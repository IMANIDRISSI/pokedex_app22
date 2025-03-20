import 'package:flutter/material.dart';
import 'pokemon_model.dart';
import 'pokemon_card.dart';
import 'favorites_service.dart';
import 'pokemon_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FavoritePage extends StatefulWidget {
  final FavoritesService favoritesService;
  final FlutterLocalNotificationsPlugin notificationsPlugin;

  const FavoritePage({
    super.key,
    required this.favoritesService,
    required this.notificationsPlugin,
  });

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final PokemonService _pokemonService = PokemonService();
  List<Pokemon> _favoritePokemonList = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    List<int> favoriteIds = await widget.favoritesService.getFavorites();
    List<Pokemon> favorites = [];

    for (int id in favoriteIds) {
      Pokemon pokemon = await _pokemonService.fetchPokemonDetails("https://pokeapi.co/api/v2/pokemon/$id");
      favorites.add(pokemon);
    }

    setState(() {
      _favoritePokemonList = favorites;
    });
  }

  Future<void> _showNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'favorites_channel',
      'Favoritos',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await widget.notificationsPlugin.show(0, 'Pokédex', message, platformChannelSpecifics);
  }

  void _toggleFavorite(Pokemon pokemon) async {
    if (_favoritePokemonList.any((p) => p.id == pokemon.id)) {
      await widget.favoritesService.removeFavorite(pokemon.id);
      _showNotification("${pokemon.name} eliminado de favoritos!");
      _loadFavorites(); // Recargar la lista de favoritos
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pokémon Favoritos")),
      body: _favoritePokemonList.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              "Aún no tienes Pokémon favoritos.",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: _favoritePokemonList.length,
        itemBuilder: (context, index) {
          return PokemonCard(
            pokemon: _favoritePokemonList[index],
            onTap: () {},
            isFavorite: true, // Siempre es favorito en esta página
            onFavoriteToggle: () => _toggleFavorite(_favoritePokemonList[index]),
            isListView: true, // Usar diseño de lista
          );
        },
      ),
    );
  }
}