import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'pokemon_service.dart';
import 'favorites_service.dart';
import 'pokemon_model.dart';
import 'theme_provider.dart';
import 'favorite_page.dart';
import 'pokemon_detail_page.dart';
import 'pokemon_card.dart';
import 'pokemon_comparator.dart';

class HomePage extends StatefulWidget {
  final FavoritesService favoritesService;

  const HomePage({super.key, required this.favoritesService});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final PokemonService _pokemonService = PokemonService();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _bgAnimationController;
  late Animation<Color?> _bgColorAnimation;

  List<Pokemon> _pokemonList = [];
  List<Pokemon> _displayedList = [];
  Set<int> _favoritePokemon = {};
  bool _isLoading = false;
  int _offset = 0;
  final int _limit = 50;
  bool _hasMore = true;

  String _selectedType = 'all';
  bool _isAscending = true;
  String _searchQuery = '';
  bool _isGridView = true; // Controla si la vista es de cuadrícula o lista

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _loadPokemon();
    _loadFavorites();
    _initializeNotifications();
    _scrollController.addListener(_scrollListener);

    _bgAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _bgColorAnimation = ColorTween(
      begin: Colors.pink[50],
      end: Colors.purple[50],
    ).animate(_bgAnimationController);
  }

  @override
  void dispose() {
    _bgAnimationController.dispose();
    super.dispose();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _loadPokemon() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    List<Pokemon> newPokemon = await _pokemonService.fetchPokemonList(offset: _offset, limit: _limit);

    if (newPokemon.isEmpty) {
      _hasMore = false;
    } else {
      setState(() {
        _pokemonList.addAll(newPokemon);
        _offset += newPokemon.length;
        _applyFilters();
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadFavorites() async {
    List<int> favoriteIds = await widget.favoritesService.getFavorites();
    setState(() {
      _favoritePokemon = favoriteIds.toSet();
    });
  }

  void _toggleFavorite(Pokemon pokemon) async {
    if (_favoritePokemon.contains(pokemon.id)) {
      await widget.favoritesService.removeFavorite(pokemon.id);
      _showNotification("${pokemon.name} eliminado de favoritos!");
    } else {
      await widget.favoritesService.saveFavorite(pokemon.id);
      // Mostrar un SnackBar immediatament
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${pokemon.name} està afegit a favorits"),
          duration: const Duration(seconds: 2),
        ),
      );
      // Notificació retardada després de 3 segons
      Future.delayed(const Duration(seconds: 3), () {
        _showNotification("¡${pokemon.name} està afegit a favorits!");
      });
    }
    _loadFavorites();
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

    await _notificationsPlugin.show(0, 'Pokédex', message, platformChannelSpecifics);
  }

  void _applyFilters() {
    List<Pokemon> filteredList = List.from(_pokemonList);

    if (_selectedType != 'all') {
      filteredList = filteredList.where((pokemon) => pokemon.types.contains(_selectedType)).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filteredList = filteredList
          .where((pokemon) => pokemon.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    _displayedList = _pokemonService.sortPokemonList(filteredList, _isAscending);
    setState(() {});
  }

  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
      _applyFilters();
    });
  }

  void _compareRandomPokemon() {
    if (_pokemonList.length < 2) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No hay suficientes Pokémon para comparar.')));
      return;
    }
    final random = Random();
    int index1 = random.nextInt(_pokemonList.length);
    int index2;
    do {
      index2 = random.nextInt(_pokemonList.length);
    } while (index2 == index1);

    final pokemon1 = _pokemonList[index1];
    final pokemon2 = _pokemonList[index2];

    showDialog(
      context: context,
      builder: (context) => PokemonComparatorDialog(
        pokemon1: pokemon1,
        pokemon2: pokemon2,
      ),
    );
  }

  void _showRandomPokemon() async {
    Pokemon randomPokemon = await _pokemonService.fetchRandomPokemon();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PokemonDetailPage(pokemon: randomPokemon),
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadPokemon();
    }
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return AnimatedBuilder(
      animation: _bgColorAnimation,
      builder: (context, child) => Scaffold(
        backgroundColor: isDarkMode ? Colors.grey[900] : _bgColorAnimation.value,
        appBar: AppBar(
          title: const Text('Pokédex'),
          backgroundColor: isDarkMode ? Colors.pink[800] : Colors.pinkAccent.shade100,
          actions: [
            IconButton(
              icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
              onPressed: _toggleView,
            ),
            IconButton(icon: const Icon(Icons.casino), onPressed: _showRandomPokemon),
            IconButton(icon: Icon(_isAscending ? Icons.sort_by_alpha : Icons.sort_by_alpha_outlined), onPressed: _toggleSortOrder),
            IconButton(
              icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: () => themeProvider.toggleTheme(),
            ),
            IconButton(icon: const Icon(Icons.compare_arrows), onPressed: _compareRandomPokemon),
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritePage(
                      favoritesService: widget.favoritesService,
                      notificationsPlugin: _notificationsPlugin,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Buscar Pokémon...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: isDarkMode ? Colors.grey[800] : Colors.pink[100], // Canvi aquí
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (query) {
                      setState(() {
                        _searchQuery = query;
                        _applyFilters();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: _selectedType,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedType = newValue!;
                        _applyFilters();
                      });
                    },
                    items: <String>[
                      'all', 'water', 'fire', 'grass', 'electric', 'ground', 'rock', 'ice', 'fighting', 'poison', 'flying', 'psychic', 'bug', 'ghost', 'dragon', 'dark', 'steel', 'fairy'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.toUpperCase()),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isGridView
                  ? GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: _displayedList.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _displayedList.length) {
                    return _isLoading ? const Center(child: CircularProgressIndicator()) : const SizedBox();
                  }
                  return PokemonCard(
                    pokemon: _displayedList[index],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PokemonDetailPage(pokemon: _displayedList[index]),
                      ),
                    ),
                    isFavorite: _favoritePokemon.contains(_displayedList[index].id),
                    onFavoriteToggle: () => _toggleFavorite(_displayedList[index]),
                  );
                },
              )
                  : ListView.builder(
                controller: _scrollController,
                itemCount: _displayedList.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _displayedList.length) {
                    return _isLoading ? const Center(child: CircularProgressIndicator()) : const SizedBox();
                  }
                  return PokemonCard(
                    pokemon: _displayedList[index],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PokemonDetailPage(pokemon: _displayedList[index]),
                      ),
                    ),
                    isFavorite: _favoritePokemon.contains(_displayedList[index].id),
                    onFavoriteToggle: () => _toggleFavorite(_displayedList[index]),
                    isListView: true,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}