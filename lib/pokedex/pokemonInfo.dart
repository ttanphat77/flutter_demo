import 'package:fl_demo/pokedex/pokemonList.dart';
import 'package:flutter/material.dart';

class PokemonInfo extends StatelessWidget {
  const PokemonInfo({super.key, required this.pokemon});

  final Pokemon? pokemon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          pokemon!.info['species']?['info']['flavor_text_entries'][17]
                      ['flavor_text']
                  ?.replaceAll('\n', ' ') ??
              '',
        ),
      ],
    );
  }
}
