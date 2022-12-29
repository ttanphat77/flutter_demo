import 'package:flutter/material.dart';

class UI with ChangeNotifier {
  double _fontSize = 0.5;

  set fontSize(double value) {
    _fontSize = value;
    notifyListeners();
  }

  double get fontSize => _fontSize * 30;
  double get sliderFontSie => _fontSize;
}