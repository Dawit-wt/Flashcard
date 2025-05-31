import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutterfiretest/database.dart';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({super.key});

  @override
  LineChartWidgetState createState() => LineChartWidgetState();
}

class LineChartWidgetState extends State<LineChartWidget> {
  late Color avatarColor;
  late List<double> temp;

  @override
  void initState() {
    super.initState();
    avatarColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    temp = List.filled(15, 0.0); // Initialize with zeros
  }

  Future<List<FlSpot>> getSpots() async {
    temp = await DatabaseService().getAvgScore();
    for (int i = 0; i < temp.length; i++) {
      temp[i] = temp[i].ceilToDouble();
    }

    return List.generate(
      temp.length,
      (i) => FlSpot(i.toDouble(), temp[i]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: FutureBuilder<List<FlSpot>>(
        future: getSpots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          } else {
            final spots = snapshot.data!;
            return Column(
              children: [
                Text(
                  "15 days average score",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 300,
                  child: LineChart(
                    LineChartData(
                      titlesData: const FlTitlesData(show: false),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: avatarColor,
                          barWidth: 2,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
