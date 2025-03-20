import 'package:flutter/material.dart';
import 'pokemon_model.dart';

class PokemonComparatorDialog extends StatelessWidget {
  final Pokemon pokemon1;
  final Pokemon pokemon2;

  const PokemonComparatorDialog({
    Key? key,
    required this.pokemon1,
    required this.pokemon2,
  }) : super(key: key);

  // Columna de comparación mejorada visualmente
  Widget _buildPokemonComparisonColumn(Pokemon pokemon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 45,
          backgroundImage: NetworkImage(pokemon.imageUrl),
          backgroundColor: Colors.transparent,
        ),
        const SizedBox(height: 10),
        Text(
          pokemon.name.toUpperCase(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text("Altura: ${pokemon.height} m",
            style: const TextStyle(fontSize: 14)),
        Text("Peso: ${pokemon.weight} kg",
            style: const TextStyle(fontSize: 14)),
        Text(
          "Tipos: ${pokemon.types.join(", ").toUpperCase()}",
          style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Divider(),
        ...pokemon.stats.entries.map((entry) => Text(
          "${entry.key.toUpperCase()}: ${entry.value}",
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        '⚡ Comparación de Pokémon ⚡',
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: _buildPokemonComparisonColumn(pokemon1)),
            const SizedBox(width: 12),
            Expanded(child: _buildPokemonComparisonColumn(pokemon2)),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.deepPurple,
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cerrar', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
