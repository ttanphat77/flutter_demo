import 'dart:io' as io;
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart' as object_detection;
import 'package:image_picker/image_picker.dart';

class ObjectDetector extends StatefulWidget {
  const ObjectDetector({Key? key}) : super(key: key);

  @override
  _ObjectDetectorState createState() => _ObjectDetectorState();
}
  
class _ObjectDetectorState extends State<ObjectDetector> {
  final ImagePicker _picker = ImagePicker();
  late object_detection.ObjectDetector _objectDetector;
  XFile? _image;
  ui.Image? _imageUI;
  CustomPaint? _customPaint;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getModel();
  }

  getModel() async {
    final path = '${(await getApplicationSupportDirectory()).path}/assets/objectDetectionModel/object_labeler.tflite';
    await io.Directory(dirname(path)).create(recursive: true);
    final file = io.File(path);
    if (!await file.exists()) {
      final data = await rootBundle.load('assets/objectDetectionModel/object_labeler.tflite');
      final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await file.writeAsBytes(bytes, flush: true);
    }


    final options = object_detection.LocalObjectDetectorOptions(
      mode: object_detection.DetectionMode.single,
      modelPath: file.path,
      classifyObjects: true,
      multipleObjects: true,
    );
    _objectDetector = object_detection.ObjectDetector(options: options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Object Detector'),
      ),
      body: Center(
        child: ListView(
          children: [
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () async {
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                object_detection.InputImage inputImage = object_detection.InputImage.fromFilePath(image!.path);
                final objects = await _objectDetector.processImage(inputImage);
                print(objects.length);
                _image = XFile(image!.path);
                _imageUI = await decodeImageFromList(await _image!.readAsBytes());
                final painter = BoundingBoxesPainter(image: _imageUI!, objects: objects);
                setState(() {
                  _customPaint = CustomPaint(painter: painter);
                });
              },
              child: const Text('Pick Image'),
            ),
            _imageUI == null ? const Text('No Image') : FittedBox(
                child: SizedBox(
                  width: _imageUI?.width.toDouble(),
                  height: _imageUI?.height.toDouble(),
                  child: _customPaint,
                )
            ),

          ],
        ),
      ),
    );
  }
}

class BoundingBoxesPainter extends CustomPainter {
  final List<object_detection.DetectedObject> objects;
  final ui.Image image;
  BoundingBoxesPainter({
    required this.image,
    required this.objects,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.red;
    canvas.drawCircle(const Offset(0, 0), 2, paint);
    canvas.drawImage(image, Offset.zero, Paint());
    for (int i = 0; i < objects.length; i++) {
      final rect = objects[i].boundingBox;
      canvas.drawRect(
        Rect.fromLTRB(
          rect.left,
          rect.top,
          rect.right,
          rect.bottom,
        ),
        paint,
      );
      for (int j = 0; j < objects[i].labels.length; j++) {
        final TextPainter textPainter = TextPainter(
            text: TextSpan(text: '${objects[i].labels[j].text} ${objects[i].labels[j].confidence}', style: const TextStyle(
              backgroundColor: Colors.black,
              color: Colors.white,
              fontSize: 20)),
            textAlign: TextAlign.justify,
            textDirection: TextDirection.ltr
        )..layout();
        textPainter.paint(canvas, Offset(rect.left, rect.top + 25*j));
      }
    }
  }

  @override
  bool shouldRepaint(BoundingBoxesPainter oldDelegate) {
    return oldDelegate.objects != objects;
  }
}