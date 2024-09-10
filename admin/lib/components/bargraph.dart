import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            axisNameWidget: Text("Sales"),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  final months = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun',
                  ];
                  final index = value.toInt();
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      months[index % months.length],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ),
              axisNameWidget: Text("Weeks")),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d)),
        ),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: 80,
                color: Colors.green,
                width: 15,
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: 20,
                color: Colors.red,
                width: 15,
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                toY: 50,
                color: Colors.green,
                width: 15,
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(
                toY: 10,
                color: Colors.green,
                width: 15,
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          ),
          BarChartGroupData(
            x: 4,
            barRods: [
              BarChartRodData(
                toY: 6,
                color: Colors.green,
                width: 15,
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          ),
          BarChartGroupData(
            x: 5,
            barRods: [
              BarChartRodData(
                toY: 6,
                color: Colors.green,
                width: 15,
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
