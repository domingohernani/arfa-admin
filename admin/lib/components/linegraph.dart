import 'package:admin/constants/constant.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineGraph extends StatelessWidget {
  const LineGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        backgroundColor: Colors.white,
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 50),
            axisNameWidget: Text("Orders"),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 25),
            axisNameSize: 30,
            axisNameWidget: Text("Month of July"),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.green),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(1, 1),
              const FlSpot(2, 10),
              const FlSpot(3, 60),
              const FlSpot(4, 30),
              const FlSpot(5, 40),
              const FlSpot(6, 50),
              const FlSpot(7, 40),
              const FlSpot(8, 70),
              const FlSpot(9, 80),
              const FlSpot(10, 90),
              const FlSpot(11, 110),
              const FlSpot(12, 110),
              const FlSpot(13, 110),
              const FlSpot(14, 110),
              const FlSpot(15, 110),
              const FlSpot(16, 110),
              const FlSpot(17, 110),
              const FlSpot(18, 110),
              const FlSpot(19, 110),
              const FlSpot(20, 110),
              const FlSpot(21, 110),
              const FlSpot(22, 110),
              const FlSpot(23, 110),
              const FlSpot(24, 110),
              const FlSpot(25, 110),
              const FlSpot(26, 110),
              const FlSpot(27, 110),
              const FlSpot(28, 110),
              const FlSpot(29, 110),
              const FlSpot(30, 110),
              const FlSpot(31, 110),
            ],
            isCurved: true,
            color: secondary,
            barWidth: 2,
            belowBarData: BarAreaData(show: false),
            dotData: const FlDotData(show: false),
          ),
          LineChartBarData(
            spots: [
              const FlSpot(1, 1),
              const FlSpot(2, 10),
              const FlSpot(3, 20),
              const FlSpot(4, 30),
              const FlSpot(5, 20),
              const FlSpot(6, 50),
              const FlSpot(7, 80),
              const FlSpot(8, 70),
              const FlSpot(9, 80),
              const FlSpot(10, 90),
              const FlSpot(11, 40),
              const FlSpot(12, 110),
              const FlSpot(13, 110),
              const FlSpot(14, 110),
              const FlSpot(15, 110),
              const FlSpot(16, 110),
              const FlSpot(17, 110),
              const FlSpot(18, 110),
              const FlSpot(19, 110),
              const FlSpot(20, 110),
              const FlSpot(21, 110),
              const FlSpot(22, 110),
              const FlSpot(23, 110),
              const FlSpot(24, 110),
              const FlSpot(25, 110),
              const FlSpot(26, 110),
              const FlSpot(27, 110),
              const FlSpot(28, 110),
              const FlSpot(29, 110),
              const FlSpot(30, 110),
              const FlSpot(31, 110),
            ],
            isCurved: true,
            color: Colors.red,
            barWidth: 2,
            belowBarData: BarAreaData(show: false),
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
