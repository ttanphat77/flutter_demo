import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_demo/model/ui.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<UI>(
        builder: (context, ui, child) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Font Size: ${ui.fontSize.toInt()}',
                  style: TextStyle(fontSize: Theme.of(context).textTheme.headline5!.fontSize),
                ),
              ),
              Slider(
                value: ui.sliderFontSie,
                min: 0,
                max: 1,
                divisions: 10,
                label: ui.fontSize.toString(),
                onChanged: (double value) {
                  ui.fontSize = value;
                },
              ),
            ],
          );
        },
      ),
    );
  }
}