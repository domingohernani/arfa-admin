import 'dart:async';

import 'package:admin/models/monthlyData.dart';
import 'package:admin/services/firestoreService.dart';
import 'package:admin/themes/theme.dart';
import 'package:admin/utilities/dateconvertion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineGraphUsers extends StatefulWidget {
  LineGraphUsers({super.key});

  @override
  State<LineGraphUsers> createState() => _LineGraphUsersState();
}

class _LineGraphUsersState extends State<LineGraphUsers> {
  FirestoreService _fs = FirestoreService();

  String currentMonth = monthToText(DateTime.now().month);
  int previousYear = DateTime.now().year - 1;
  int currentYear = DateTime.now().year;

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
  Widget build(BuildContext context) {
    return FutureBuilder<List<MonthlyReport>>(
        future: _fs.getListOfReport(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found.'));
          }
          List<MonthlyReport> reports = snapshot.data!;

          for (var report in reports) {
            if (report.year == currentYear) {
              if (monthlyData.containsKey(report.month)) {
                monthlyData[report.month] =
                    report.newusers.toDouble(); // Update the month's orders
              }
            }
          }

          for (var report in reports) {
            if (report.year == previousYear) {
              if (prevMonthlyData.containsKey(report.month)) {
                prevMonthlyData[report.month] =
                    report.newusers.toDouble(); // Update the month's orders
              }
            }
          }

          print("Orders: ${monthlyData['January'].runtimeType}");

          return LineChart(
            LineChartData(
              gridData: const FlGridData(show: true),
              backgroundColor: Colors.white,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 50),
                  axisNameWidget: const Text("Orders"),
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
                  axisNameWidget: Text("Month of ${currentMonth}"),
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
                  color: secondary,
                  barWidth: 3,
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
                  color: Colors.red,
                  barWidth: 3,
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          );
        });
  }
}
