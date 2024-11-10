// import 'package:admin/services/firestoreService.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class BarGraph extends StatelessWidget {
//   FirestoreService _fs = FirestoreService();

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: _fs.getOrdersData(),
//         builder: (context, snapshot) {
//           return BarChart(
//             BarChartData(
//               gridData: FlGridData(show: false),
//               titlesData: FlTitlesData(
//                 leftTitles: AxisTitles(
//                   axisNameWidget: Text("Sales"),
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     reservedSize: 50,
//                     getTitlesWidget: (value, meta) {
//                       return SideTitleWidget(
//                         axisSide: meta.axisSide,
//                         child: Text(
//                           value.toString(),
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.black,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 30,
//                       getTitlesWidget: (value, meta) {
//                         final months = [
//                           'Mon',
//                           'Tue',
//                           'Wed',
//                           'Thu',
//                           'Fri',
//                           'Sat',
//                           'Sun',
//                         ];
//                         final index = value.toInt();
//                         return SideTitleWidget(
//                           axisSide: meta.axisSide,
//                           child: Text(
//                             months[index % months.length],
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.black,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     axisNameWidget: Text("Weeks")),
//                 topTitles: AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//                 rightTitles: AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//               ),
//               borderData: FlBorderData(
//                 show: true,
//                 border: Border.all(color: const Color(0xff37434d)),
//               ),
//               barGroups: [
//                 BarChartGroupData(
//                   x: 0,
//                   barRods: [
//                     BarChartRodData(
//                       toY: 80,
//                       color: Colors.green,
//                       width: 15,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ],
//                 ),
//                 BarChartGroupData(
//                   x: 1,
//                   barRods: [
//                     BarChartRodData(
//                       toY: 20,
//                       color: Colors.red,
//                       width: 15,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ],
//                 ),
//                 BarChartGroupData(
//                   x: 2,
//                   barRods: [
//                     BarChartRodData(
//                       toY: 50,
//                       color: Colors.green,
//                       width: 15,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ],
//                 ),
//                 BarChartGroupData(
//                   x: 3,
//                   barRods: [
//                     BarChartRodData(
//                       toY: 10,
//                       color: Colors.green,
//                       width: 15,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ],
//                 ),
//                 BarChartGroupData(
//                   x: 4,
//                   barRods: [
//                     BarChartRodData(
//                       toY: 6,
//                       color: Colors.green,
//                       width: 15,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ],
//                 ),
//                 BarChartGroupData(
//                   x: 5,
//                   barRods: [
//                     BarChartRodData(
//                       toY: 6,
//                       color: Colors.green,
//                       width: 15,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         });
//   }
// }

import 'package:admin/models/ordersData.dart';
import 'package:admin/services/firestoreService.dart';
import 'package:admin/utilities/dateconvertion.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarGraph extends StatelessWidget {
  final FirestoreService _fs = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fs.getOrdersData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No data found.'));
        }

        final salesData = snapshot.data;
        final weeklySales = calculateWeeklySales(salesData!);

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
                    String text;
                    if (value >= 1000) {
                      text = '${(value / 1000).toStringAsFixed(1)}k';
                    } else {
                      text = value.toInt().toString();
                    }
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        text,
                        style: TextStyle(fontSize: 12, color: Colors.black),
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
                    final weeks = [
                      'Week 1',
                      'Week 2',
                      'Week 3',
                      'Week 4',
                      'Week 5'
                    ];
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        weeks[value.toInt() % weeks.length],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
                axisNameWidget: Text("Weeks"),
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
              border: Border.all(color: const Color(0xff37434d)),
            ),
            barGroups: List.generate(weeklySales.length, (index) {
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: weeklySales[index].toDouble(),
                    color: Colors.green,
                    width: 20,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  List<int> calculateWeeklySales(List<OrderItem> salesData) {
    List<int> weeklySales = List.filled(5, 0);
    DateTime now = DateTime.now();
    int currentMonth = now.month - 1;
    int currentYear = now.year;

    for (var sale in salesData) {
      DateTime saleDate = sale.createdat.toDate();
      int amount = sale.ordertotal;

      if (saleDate.month == currentMonth && saleDate.year == currentYear) {
        int weekIndex = ((saleDate.day - 1) ~/ 7).clamp(0, 4);
        weeklySales[weekIndex] += amount;
      }
    }

    return weeklySales;
  }
}
