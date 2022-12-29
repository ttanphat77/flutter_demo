import 'package:fl_demo/pokedex/pokemonCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pokemonList.dart';

class Pokedex extends StatefulWidget {
  const Pokedex({super.key});

  @override
  _PokedexState createState() => _PokedexState();
}

class _PokedexState extends State<Pokedex> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final pokemonList = Provider.of<PokemonList>(context, listen: false);
    pokemonList.getPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex'),
      ),
      body: Consumer<PokemonList>(
        builder: (context, pokemonList, child) {
          return GridView.count(
            cacheExtent: 9999,
            padding: const EdgeInsets.all(8),
            crossAxisCount: 3,
            children: pokemonList.pokemons.map((pokemon) {
              return PokemonCard(pokemon: pokemon);
            }).toList(),
          );
        },
      ),
    );
  }
}
