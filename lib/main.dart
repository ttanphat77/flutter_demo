import 'dart:developer';

import 'package:flutter/material.dart';

import 'globalDrawer.dart';
import 'counter/counter.dart';
import 'neuralNumbers/neuralNumbers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const MyHomePage(title: 'Flutter'),
        '/counter': (BuildContext context) => const Counter(),
        '/neuralNumbers': (BuildContext context) => const NeuralNumbers(),
      },
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
      body: const Center(
        child: Text(
          'Hello World',
        ),
      ),
      drawer: const GlobalDrawer(),

    );

  }
}