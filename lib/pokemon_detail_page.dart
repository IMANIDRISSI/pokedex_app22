import 'package:flutter/material.dart';
import 'pokemon_model.dart';

class PokemonDetailPage extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailPage({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pokemon.name.toUpperCase())),
      body: Center( // Añadido widget Center aquí
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center, // Ajustado al centro verticalmente
            children: [
              Hero(
                tag: pokemon.id,
                child: Image.network(
                  pokemon.imageUrl,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                pokemon.name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Altura: ${pokemon.height} m",
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 6),
                      Text("Peso: ${pokemon.weight} kg",
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 6),
                      Text("Tipo(s): ${pokemon.types.join(", ").toUpperCase()}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Estadísticas",
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 300,
                child: Table(
                  border: TableBorder.all(color: Colors.grey.shade300),
                  columnWidths: const {
                    0: FractionColumnWidth(0.5),
                    1: FractionColumnWidth(0.5),
                  },
                  children: pokemon.stats.entries.map((entry) {
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(entry.key.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(entry.value.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16)),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
