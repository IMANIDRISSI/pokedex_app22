import 'package:flutter/material.dart';
import 'pokemon_model.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final bool isListView;

  const PokemonCard({
    Key? key,
    required this.pokemon,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.isListView = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: isDarkMode ? Colors.grey[800] : Color(0xFFFFF0F5), // Blanc amb to rosat
        child: isListView
            ? _buildListViewLayout(context, isDarkMode)
            : _buildGridViewLayout(context, isDarkMode),
      ),
    );
  }

  Widget _buildGridViewLayout(BuildContext context, bool isDarkMode) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          pokemon.imageUrl,
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 8),
        Text(
          pokemon.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        Text(
          pokemon.types.join(", "),
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
          ),
        ),
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : (isDarkMode ? Colors.white : Colors.black),
          ),
          onPressed: onFavoriteToggle,
        ),
      ],
    );
  }

  Widget _buildListViewLayout(BuildContext context, bool isDarkMode) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            pokemon.imageUrl,
            height: 80,
            width: 80,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                pokemon.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Text(
                pokemon.types.join(", "),
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : (isDarkMode ? Colors.white : Colors.black),
          ),
          onPressed: onFavoriteToggle,
        ),
      ],
    );
  }
}