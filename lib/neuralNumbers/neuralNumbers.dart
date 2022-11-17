import 'dart:ffi';
import 'dart:typed_data';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signature/signature.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'classifier.dart';

class NeuralNumbers extends StatefulWidget {
  const NeuralNumbers({super.key});

  @override
  State<NeuralNumbers> createState() => _NeuralNumbersState();
}

class _NeuralNumbersState extends State<NeuralNumbers> {
  var finalImage = Uint8List(0);
  static const platform = MethodChannel('samples.flutter.dev/battery');
  String _batteryLevel = 'Unknown battery level.';

  late Classifier _classifier;

  @override
  void initState() {
    super.initState();
    _classifier = Classifier();
  }

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  final SignatureController control = SignatureController(
      penStrokeWidth: 20,
      penColor: Colors.deepPurple,
      exportBackgroundColor: Colors.white);

  makeSquare(img.Image image) {
    int size = image.width > image.height ? image.width : image.height;
    img.Image square = img.Image(size, size);
    square.fill(0xffffffff);
    int x = (size - image.width) ~/ 2;
    int y = (size - image.height) ~/ 2;
    square = img.copyInto(square, image, dstX: x, dstY: y);
    return square;
  }

  @override
  Widget build(BuildContext context) {
    control.onDrawEnd = () async {
      img.Image? image = img.decodeImage((await control.toPngBytes())!);
      image = makeSquare(image!);
      image = img.copyResize(image!, width: 28, height: 28);
      image = img.grayscale(image);
      finalImage = Uint8List.fromList(img.encodeJpg(image));
      print(_classifier.predict(image));
      setState(() {});
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Neural Numbers'),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: _getBatteryLevel, child: const Text('Get Battery Level')),
            Text(_batteryLevel),
            const Text(
              'Neural Numbers',
            ),
            SizedBox(
              height: 250,
              width: 250,
              child: Container(
                child: Signature(
                  controller: control,
                  height: 300,
                  width: 300,
                ),
              ),
            ),
            SizedBox(
              height: 250,
              width: 250,
              child: Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: Image.memory(finalImage, height: 250, width: 250, fit: BoxFit.fill),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    control.clear();
                  },
                  child: const Text('Clear'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
