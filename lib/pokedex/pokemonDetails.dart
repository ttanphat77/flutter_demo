import 'dart:convert';
import 'dart:ui';

import 'package:fl_demo/pokedex/pokemonInfo.dart';
import 'package:fl_demo/pokedex/pokemonList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

class PokemonDetails extends StatefulWidget {
  Pokemon pokemon;

  PokemonDetails({super.key, required this.pokemon});

  @override
  _PokemonDetailsState createState() => _PokemonDetailsState();
}

class _PokemonDetailsState extends State<PokemonDetails>
    with TickerProviderStateMixin {
  Pokemon? pokemon;
  CarouselController buttonCarouselController = CarouselController();
  late TabController? _tabController;

  final SliverOverlapAbsorberHandle appBar = SliverOverlapAbsorberHandle();
  final SliverOverlapAbsorberHandle tabBar = SliverOverlapAbsorberHandle();

  @override
  void initState() {
    getPokemonDetails(widget.pokemon);
    _tabController = TabController(length: 1, vsync: this);
    super.initState();
  }

  getPokemonDetails(Pokemon current) async {
    pokemon = current;
    setState(() {});
    final response = await http.get(Uri.parse(pokemon!.info['species']['url']));
    if (response.statusCode == 200) {
      setState(() {
        pokemon!.info['species']['info'] = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load pokemon');
    }
  }

  @override
  Widget build(BuildContext context) {
    final pokemonList = Provider.of<PokemonList>(context, listen: false);
    final types = pokemon?.info['types'];
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: appBar,
              sliver: SliverAppBar(
                expandedHeight: 300,
                forceElevated: innerBoxIsScrolled,
                pinned: true,
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 8, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '#${pokemon?.info['id']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          pokemon?.info['species']['info']?['genera']?[7]
                                  ['genus'] ??
                              '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                // automaticallyImplyLeading: false,
                flexibleSpace: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          pokemonTypeColors[types[0]['type']['name']]['color']!,
                          types.length > 1
                              ? pokemonTypeColors[types[1]['type']['name']]
                                  ['color']
                              : pokemonTypeColors[types[0]['type']['name']]
                                  ['color']
                        ],
                        stops: const [
                          0.65,
                          0.8
                        ]),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return FlexibleSpaceBar(
                          titlePadding: const EdgeInsets.only(
                              bottom: 38, top: 4, left: 8, right: 8),
                          title: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: constraints.biggest.height < 150 ? 1 : 0,
                            child: Image.network(
                              pokemon?.info['sprites']['versions']
                                          ['generation-v']['black-white']
                                      ['animated']['front_default'] ??
                                  '',
                            ),
                          ),
                          background: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              const DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment(0.0, 0.8),
                                    end: Alignment.center,
                                    colors: <Color>[
                                      Color(0x60000000),
                                      Color(0x00000000),
                                    ],
                                  ),
                                ),
                              ),
                              CarouselSlider(
                                carouselController: buttonCarouselController,
                                options: CarouselOptions(
                                  enlargeCenterPage: true,
                                  viewportFraction: 0.4,
                                  enlargeStrategy:
                                      CenterPageEnlargeStrategy.scale,
                                  initialPage: pokemon?.info['id'] - 1 ?? 0,
                                  onPageChanged: (index, reason) {
                                    getPokemonDetails(
                                        pokemonList.pokemons[index]);
                                  },
                                ),
                                items: pokemonList.pokemons.map((i) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return AnimatedScale(
                                          scale: i.info['id'] ==
                                                  pokemon?.info['id']
                                              ? 1.5
                                              : 0.7,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          child: Hero(
                                            transitionOnUserGestures: true,
                                            tag: constraints.biggest.height >=
                                                        150 &&
                                                    i.info['id'] ==
                                                        pokemon?.info['id']
                                                ? pokemon?.name
                                                : i.info['id'],
                                            child: GestureDetector(
                                              onTap: () {
                                                if (i.info['id'] <
                                                        pokemon?.info['id'] ??
                                                    0) {
                                                  buttonCarouselController
                                                      .previousPage(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      100),
                                                          curve: Curves.ease);
                                                } else if (i.info['id'] >
                                                        pokemon?.info['id'] ??
                                                    0) {
                                                  buttonCarouselController
                                                      .nextPage(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      100),
                                                          curve: Curves.ease);
                                                }
                                              },
                                              child: Image.network(
                                                i.info['sprites']['other']
                                                            ['official-artwork']
                                                        ['front_default'] ??
                                                    '',
                                                color: i.info['id'] ==
                                                        pokemon?.info['id']
                                                    ? null
                                                    : Colors.black
                                                        .withOpacity(0.3),
                                              ),
                                            ),
                                          ));
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ));
                    },
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(50),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: types.map<Widget>((type) {
                                var typeName = type['type']['name'];
                                return Chip(
                                  backgroundColor: pokemonTypeColors[typeName]
                                      ['color'],
                                  label: Text(
                                    typeName,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  shape: const StadiumBorder(
                                    side: BorderSide(
                                        color: Colors.white, width: 1),
                                  ),
                                );
                              }).toList() ??
                              [],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios),
                              color: Colors.white,
                              onPressed: () {
                                buttonCarouselController.previousPage(
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.ease);
                              },
                            ),
                            Text(
                              pokemon!.name.capitalize(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              color: Colors.white,
                              onPressed: () {
                                buttonCarouselController.nextPage(
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.ease);
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverOverlapAbsorber(
              handle: tabBar,
              sliver: SliverAppBar(
                pinned: true,
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                title: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.black,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(
                      text: 'About',
                    ),
                    Tab(
                      text: 'Stats',
                    ),
                    Tab(
                      text: 'Moves',
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  builder: (BuildContext context) {
                    return CustomScrollView(slivers: [
                      SliverOverlapInjector(
                        handle: appBar,
                      ),
                      SliverOverlapInjector(
                        handle: tabBar,
                      ),
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: PokemonInfo(pokemon: pokemon),
                      )
                    ]);
                  },
                ))
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
