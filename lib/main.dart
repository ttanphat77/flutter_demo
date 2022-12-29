import 'dart:developer';

import 'package:fl_demo/pokedex/pokemonDetails.dart';
import 'package:fl_demo/pokedex/pokemonList.dart';
import 'package:flutter/material.dart';

import 'globalDrawer.dart';
import 'counter/counter.dart';
import 'neuralNumbers/neuralNumbers.dart';
import 'objectDetector/objectDetector.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:fl_demo/model/ui.dart';
import 'package:provider/provider.dart';
import 'settings/settings.dart';
import 'pokedex/pokedex.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UI()),
        ChangeNotifierProvider(create: (_) => PokemonList()),
      ],
      child: MaterialApp(
        title: 'Flutter',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => const MyHomePage(title: 'Flutter'),
          '/counter': (BuildContext context) => const Counter(),
          '/neuralNumbers': (BuildContext context) => const NeuralNumbers(),
          '/objectDetector': (BuildContext context) => const ObjectDetector(),
          '/pokedex': (BuildContext context) => const Pokedex(),
          '/settings': (BuildContext context) => const Settings(),
        },
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Consumer<UI>(
              builder: (context, ui, child) {
                return RichText(text:
                TextSpan(
                  text: lorem(paragraphs: 2, words: 100),
                  style: TextStyle(fontSize: ui.fontSize),
                ),
                );
              }
          ),
        )
      ),
      drawer: const GlobalDrawer(),

    );

  }
}