import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomPieChart extends StatelessWidget {
  final List<int> data; // [easy, moderate, hard, insane]

  const CustomPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final counts = data.length >= 4 ? data : [0, 0, 0, 0]; // Ensure 4 values

    final sections = [
      PieChartSectionData(
        value: counts[0].toDouble(),
        title: 'Easy\n${counts[0]}',
        color: Theme.of(context).colorScheme.primaryContainer,
        radius: 75,
        titleStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      PieChartSectionData(
        value: counts[1].toDouble(),
        title: 'Moderate\n${counts[1]}',
        color: Theme.of(context).colorScheme.secondary,
        radius: 75,
        titleStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      PieChartSectionData(
        value: counts[2].toDouble(),
        title: 'Hard\n${counts[2]}',
        color: Theme.of(context).colorScheme.error,
        radius: 75,
        titleStyle: TextStyle(
          color: Theme.of(context).colorScheme.onError,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      PieChartSectionData(
        value: counts[3].toDouble(),
        title: 'Insane\n${counts[3]}',
        color: Theme.of(context).colorScheme.primary,
        radius: 75,
        titleStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    ].where((section) => section.value > 0).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Level Distribution',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        AspectRatio(
          aspectRatio: 1.3,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: PieChart(
              PieChartData(
                sections: sections,
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {},
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
