import 'package:fl_demo/pokedex/pokemonDetails.dart';
import 'package:fl_demo/pokedex/pokemonList.dart';
import 'package:flutter/material.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({super.key, required this.pokemon});

  final Pokemon pokemon;



  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PokemonDetails(pokemon: pokemon),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Hero(
                transitionOnUserGestures: true,
                tag: pokemon.name,
                child: SizedBox.fromSize(
                  size: const Size.square(65),
                  child: Image.network(pokemon.info['sprites']['other']
                  ['official-artwork']['front_default']),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${pokemon.info['id']}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  Row(
                    children: pokemon.info['types'].map<Widget>((type) {
                      var typeName = type['type']['name'];
                      return Container(
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.only(left: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: pokemonTypeColors[typeName]['color'],
                        ),
                        child: Text(
                          typeName.toString().capitalize(),
                          style: TextStyle(
                            color: pokemonTypeColors[typeName]['textColor'],
                            fontSize: 10,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Text(
                pokemon.name.toString().capitalize(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Path: lib/pokedex/pokemonDetails.da
