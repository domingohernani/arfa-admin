import 'dart:async';

import 'package:admin/models/monthlyData.dart';
import 'package:admin/services/firestoreService.dart';
import 'package:admin/themes/theme.dart';
import 'package:admin/utilities/dateconvertion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineGraph extends StatefulWidget {
  final int compareFrom; // The year for the green line
  final int compareTo; // The year for the blue line

  // Constructor to initialize compareFrom and compareTo
  const LineGraph(
      {Key? key, required this.compareFrom, required this.compareTo})
      : super(key: key);

  @override
  State<LineGraph> createState() => _LineGraphState();
}

class _LineGraphState extends State<LineGraph> {
  FirestoreService _fs = FirestoreService();

  String currentMonth = monthToText(DateTime.now().month);

  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  Map<String, double> monthlyData = {
    "January": 0,
    "February": 0,
    "March": 0,
    "April": 0,
    "May": 0,
    "June": 0,
    "July": 0,
    "August": 0,
    "September": 0,
    "October": 0,
    "November": 0,
    "December": 0,
  };

  Map<String, double> prevMonthlyData = {
    "January": 0,
    "February": 0,
    "March": 0,
    "April": 0,
    "May": 0,
    "June": 0,
    "July": 0,
    "August": 0,
    "September": 0,
    "October": 0,
    "November": 0,
    "December": 0,
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    monthlyData;
    prevMonthlyData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MonthlyReport>>(
        future: _fs.getListOfReport(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No sellers found.'));
          }
          List<MonthlyReport> reports = snapshot.data!;

          print("hey: ${widget.compareFrom}");
          print("hey: ${widget.compareFrom}");

          // Populate the current year's data
          for (var report in reports) {
            if (report.year == widget.compareFrom) {
              if (monthlyData.containsKey(report.month)) {
                monthlyData[report.month] = report.monthlyorders
                    .toDouble(); // Update the month's orders
              }
            }
          }

          // Populate the previous year's data
          for (var report in reports) {
            if (report.year == widget.compareTo) {
              if (prevMonthlyData.containsKey(report.month)) {
                prevMonthlyData[report.month] = report.monthlyorders
                    .toDouble(); // Update the month's orders
              }
            }
          }

          return LineChart(
            LineChartData(
              gridData: const FlGridData(show: true),
              backgroundColor: Colors.white,
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 50),
                  axisNameWidget: Text("Orders"),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 25,
                    interval:
                        1, // Ensures labels only appear at each integer x value (1, 2, 3,...)
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt() - 1;
                      if (index >= 0 && index < months.length) {
                        return Text(
                          months[index],
                          style: const TextStyle(
                              color: Colors.black, fontSize: 10),
                        );
                      }
                      return const Text('');
                    },
                  ),
                  axisNameSize: 30,
                  axisNameWidget: Text("Month of $currentMonth"),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
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
                    FlSpot(1, monthlyData['January']!),
                    FlSpot(2, monthlyData['February']!),
                    FlSpot(3, monthlyData['March']!),
                    FlSpot(4, monthlyData['April']!),
                    FlSpot(5, monthlyData['May']!),
                    FlSpot(6, monthlyData['June']!),
                    FlSpot(7, monthlyData['July']!),
                    FlSpot(8, monthlyData['August']!),
                    FlSpot(9, monthlyData['September']!),
                    FlSpot(10, monthlyData['October']!),
                    FlSpot(11, monthlyData['November']!),
                    FlSpot(12, monthlyData['December']!),
                  ],
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(show: false),
                ),
                LineChartBarData(
                  spots: [
                    FlSpot(1, prevMonthlyData['January']!),
                    FlSpot(2, prevMonthlyData['February']!),
                    FlSpot(3, prevMonthlyData['March']!),
                    FlSpot(4, prevMonthlyData['April']!),
                    FlSpot(5, prevMonthlyData['May']!),
                    FlSpot(6, prevMonthlyData['June']!),
                    FlSpot(7, prevMonthlyData['July']!),
                    FlSpot(8, prevMonthlyData['August']!),
                    FlSpot(9, prevMonthlyData['September']!),
                    FlSpot(10, prevMonthlyData['October']!),
                    FlSpot(11, prevMonthlyData['November']!),
                    FlSpot(12, prevMonthlyData['December']!),
                  ],
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          );
        });
  }
}
