import 'package:flutter/material.dart';
import 'constants.dart';
import 'drawingPainter.dart';
import 'classifier.dart';
import 'package:fl_chart/fl_chart.dart';

class NeuralNumbers extends StatefulWidget {
  const NeuralNumbers({super.key});

  @override
  State<NeuralNumbers> createState() => _NeuralNumbers();
}

class _NeuralNumbers extends State<NeuralNumbers> {
  List<Offset?> points = [];
  Classifier classifier = Classifier();
  List<BarChartGroupData> chartItems = [];

  void _cleanDrawing() {
    setState(() {
      points = [];
    });
  }

  @override
  void initState() {
    super.initState();
    classifier.loadModel();
    _buildChart(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neural Numbers'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 3.0,
                  color: Colors.blue,
                ),
              ),
              child: Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        RenderBox renderBox = context.findRenderObject() as RenderBox;
                        points.add(
                            renderBox.globalToLocal(details.globalPosition));
                      });
                    },
                    onPanStart: (details) {
                      setState(() {
                        RenderBox renderBox = context.findRenderObject() as RenderBox;
                        points.add(
                            renderBox.globalToLocal(details.globalPosition));
                      });
                    },
                    onPanEnd: (details) async {
                      points.add(null);
                      List? predictions = await await classifier.processCanvasPoints(points);
                      setState(() {
                        _buildChart(predictions);
                      });
                    },
                    child: ClipRect(
                      child: CustomPaint(
                        size: const Size(kCanvasSize, kCanvasSize),
                        painter: DrawingPainter(
                          offsetPoints: points,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                child: BarChart(
                  BarChartData(
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, title) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                          ),
                        ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                          ),
                        ),
                      ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: chartItems,
                  )
                )
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _cleanDrawing();
          _buildChart(null);
        },
        tooltip: 'Clean',
        child: Icon(Icons.delete),
      ),
    );
  }

  void _buildChart(List? predictions) {
    chartItems = [];

    for(var i = 0; i < 10; i++) {
      var barGroup = BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: 0,
            color: Colors.blue,
            width: 22,
            backDrawRodData: BackgroundBarChartRodData(
              toY: 1,
              color: Colors.transparent,
            ),
          ),
        ],
      );
      chartItems.add(barGroup);
    }
    if (predictions != null) {
      for (var num in predictions) {
        final idx = num["index"];
        if (0 <= idx && idx < 10) {
          chartItems[idx] = BarChartGroupData(
            x: idx,
            barRods: [
              BarChartRodData(
                toY: num["confidence"],
                color: Colors.blue,
                width: 22,
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 1,
                  color: Colors.transparent,
                ),
              ),
            ],
          );
        }
      }
    }
  }
}