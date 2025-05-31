import 'package:flutter/material.dart';
import 'package:flutterfiretest/database.dart';
import 'package:flutterfiretest/stats/line_chart.dart';
import 'package:flutterfiretest/stats/pie_chart.dart'; // Contains CustomPieChart

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  StatsPageState createState() => StatsPageState();
}

class StatsPageState extends State<StatsPage> {
  late final Widget _lineChart;
  late Widget _pieChart;
  List<int>? count;
  List<int>? levelCounts;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _lineChart = const LineChartWidget();
    _pieChart = CustomPieChart(data: [0, 0, 0, 0]);
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final totalResult = await DatabaseService().getTotalCount();
      final levelResult = await DatabaseService().getLevelCount();
      if (!mounted) return;
      setState(() {
        count = totalResult;
        levelCounts = levelResult;
        while (levelCounts!.length < 4) levelCounts!.add(0);
        _pieChart = CustomPieChart(data: levelCounts!);
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'Failed to load data: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Statistics',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Text(
                    error!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Theme.of(context).colorScheme.surface,
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildCountButton(
                                  context,
                                  label: 'Decks',
                                  count: count != null && count!.isNotEmpty
                                      ? count![0].toString()
                                      : 'N/A',
                                ),
                                _buildCountButton(
                                  context,
                                  label: 'Cards',
                                  count: count != null && count!.isNotEmpty
                                      ? count![1].toString()
                                      : 'N/A',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Theme.of(context).colorScheme.surface,
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _lineChart,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Theme.of(context).colorScheme.surface,
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _pieChart,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildCountButton(BuildContext context,
      {required String label, required String count}) {
    return TextButton(
      onPressed: null,
      style: TextButton.styleFrom(
        backgroundColor:
            Theme.of(context).colorScheme.primaryContainer.withAlpha(50),
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        minimumSize: const Size(100, 40),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.0,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
          Text(
            count,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
