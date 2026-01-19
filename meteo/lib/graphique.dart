import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphiqueMeteo extends StatelessWidget {
  final List<dynamic> previsions;
  const GraphiqueMeteo({super.key, required this.previsions});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              5,
              (i) => FlSpot(
                i.toDouble(),
                previsions[i * 8]['main']['temp'].toDouble(),
              ),
            ),
            isCurved: true,
            color: Colors.white,
            barWidth: 3,
            belowBarData: BarAreaData(show: true, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
