import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonList extends ChangeNotifier {
  late List<Pokemon> pokemons = [];

  getPokemons() async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151'));
    if (response.statusCode == 200) {
      pokemons = (jsonDecode(response.body)['results'] as List)
          .map((e) => Pokemon.fromJson(e))
          .toList();
      for (int i = 0; i < pokemons.length; i++) {
        final response = await http.get(Uri.parse(pokemons[i].url));
        if (response.statusCode == 200) {
          pokemons[i].info = jsonDecode(response.body);
        }
      }
      notifyListeners();
    } else {
      throw Exception('Failed to load pokemons');
    }
  }
}

class Pokemon {
  final String name;
  final String url;
  dynamic info;

  Pokemon(this.info, this.url, {required this.name});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(json['info'], json['url'], name: json['name']);
  }
}

class PokeApiPokemonDetails {
  final String name;
  final String url;
  final int height;
  final int weight;
  final List<dynamic> types;
  final List<dynamic> abilities;
  final List<dynamic> stats;
  final List<dynamic> moves;
  final List<dynamic> sprites;

  PokeApiPokemonDetails(
      {required this.name,
      required this.url,
      required this.height,
      required this.weight,
      required this.types,
      required this.abilities,
      required this.stats,
      required this.moves,
      required this.sprites});

  factory PokeApiPokemonDetails.fromJson(Map<String, dynamic> json) {
    return PokeApiPokemonDetails(
        name: json['name'],
        url: json['url'],
        height: json['height'],
        weight: json['weight'],
        types: json['types'],
        abilities: json['abilities'],
        stats: json['stats'],
        moves: json['moves'],
        sprites: json['sprites']);
  }
}

const Map<String, dynamic> pokemonTypeColors = {
  'normal': {
    'color': Color(0xFFA8A77A),
    'lightColor': Color(0xFFC6C6A7),
    'textColor': Color(0xFF000000),
  },
  'fire': {
    'color': Color(0xFFEE8130),
    'lightColor': Color(0xFFF5AC78),
    'textColor': Color(0xFFFFFFFF),
  },
  'water': {
    'color': Color(0xFF6390F0),
    'lightColor': Color(0xFF9DB7F5),
    'textColor': Color(0xFFFFFFFF),
  },
  'electric': {
    'color': Color(0xFFF7D02C),
    'lightColor': Color(0xFFF7E078),
    'textColor': Color(0xFF000000),
  },
  'grass': {
    'color': Color(0xFF7AC74C),
    'lightColor': Color(0xFFA7DB8D),
    'textColor': Color(0xFF000000),
  },
  'ice': {
    'color': Color(0xFF96D9D6),
    'lightColor': Color(0xFFBCE6E6),
    'textColor': Color(0xFF000000),
  },
  'fighting': {
    'color': Color(0xFFC22E28),
    'lightColor': Color(0xFFD67873),
    'textColor': Color(0xFFFFFFFF),
  },
  'poison': {
    'color': Color(0xFFA33EA1),
    'lightColor': Color(0xFFC183C1),
    'textColor': Color(0xFFFFFFFF),
  },
  'ground': {
    'color': Color(0xFFE2BF65),
    'lightColor': Color(0xFFEBD69D),
    'textColor': Color(0xFF000000),
  },
  'flying': {
    'color': Color(0xFFA98FF3),
    'lightColor': Color(0xFFC6B7F5),
    'textColor': Color(0xFFFFFFFF),
  },
  'psychic': {
    'color': Color(0xFFF95587),
    'lightColor': Color(0xFFFA92B2),
    'textColor': Color(0xFFFFFFFF),
  },
  'bug': {
    'color': Color(0xFFA6B91A),
    'lightColor': Color(0xFFC6D16E),
    'textColor': Color(0xFFFFFFFF),
  },
  'rock': {
    'color': Color(0xFFB6A136),
    'lightColor': Color(0xFFD1C17D),
    'textColor': Color(0xFFFFFFFF),
  },
  'ghost': {
    'color': Color(0xFF735797),
    'lightColor': Color(0xFFA292BC),
    'textColor': Color(0xFFFFFFFF),
  },
  'dragon': {
    'color': Color(0xFF6F35FC),
    'lightColor': Color(0xFFA27DFA),
    'textColor': Color(0xFFFFFFFF),
  },
  'dark': {
    'color': Color(0xFF705746),
    'lightColor': Color(0xFFA29288),
    'textColor': Color(0xFFFFFFFF),
  },
  'steel': {
    'color': Color(0xFFB7B7CE),
    'lightColor': Color(0xFFD1D1E0),
    'textColor': Color(0xFF000000),
  },
  'fairy': {
    'color': Color(0xFFD685AD),
    'lightColor': Color(0xFFF4BDC9),
    'textColor': Color(0xFF000000),
  },
};


