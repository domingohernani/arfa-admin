import 'dart:io';

import 'package:admin/components/bargraph.dart';
import 'package:admin/components/linegraphOrders.dart';
import 'package:admin/components/linegraphUsers.dart';
import 'package:admin/models/shopsData.dart';
import 'package:admin/screens/customers/viewStore.dart';
import 'package:admin/services/firestoreService.dart';
import 'package:admin/themes/theme.dart';
import 'package:admin/utilities/exportCSV.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  String? selectedValue;
  List<String> items = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  FirestoreService _fs = FirestoreService();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width =
        MediaQuery.of(context).size.width - sidebarSize - paddingHorizontal;
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.symmetric(
        vertical: paddingView_vertical,
        horizontal: paddingView_horizontal,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Reports",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                OutlinedButton(
                  onPressed: () => exportReportCSV(context),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.download_outlined,
                        size: 20,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Export",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 10,
                left: 20,
                bottom: 10,
                right: 25,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "User Growth",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      DropdownButton<String>(
                        value: selectedValue,
                        hint: Text('Last 12 Months'),
                        icon: Icon(Icons.arrow_drop_down), // Dropdown icon
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 13,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue;
                          });
                        },
                        items:
                            items.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Returning Customers",
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "New Customers",
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 350,
                    width: width,
                    child: LineGraphUsers(),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: _fs.getMonthlyReport(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('No sellers found.'));
                }

                var reports = snapshot.data!;

                return Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _DataCard(
                        title: "₱ ${reports.monthlyrevenue.toStringAsFixed(2)}",
                        subTitle: "Monthly Revenue",
                        percentage: "98.00",
                        iconData: Icons.arrow_drop_up_outlined,
                        cardIcon: Icons.attach_money_outlined,
                      ),
                      _DataCard(
                        title: "${reports.monthlyorders}",
                        subTitle: "Orders",
                        percentage: "98.00",
                        iconData: Icons.arrow_drop_up_outlined,
                        cardIcon: Icons.shopping_bag_outlined,
                      ),
                      _DataCard(
                        title: "${reports.newusers}",
                        subTitle: "New Users",
                        percentage: "98.00",
                        iconData: Icons.arrow_drop_up_outlined,
                        cardIcon: Icons.person_add_alt_1_outlined,
                      ),
                      _DataCard(
                        title: "${reports.currentusers}",
                        subTitle: "Existing Users",
                        percentage: "98.00",
                        iconData: Icons.arrow_drop_up_outlined,
                        cardIcon: Icons.groups_2_outlined,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: width * 0.35,
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 20,
                    bottom: 10,
                    right: 25,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Sales Goal",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 300,
                        width: width * 0.35,
                        child: BarGraph(),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: width * 0.63,
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 20,
                    bottom: 10,
                    right: 25,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Average Order Value",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 300,
                        width: width * 0.63,
                        child: LineGraph(
                          compareFrom: 2022,
                          compareTo: 2023,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder<List<Shop>>(
              future: _fs.getShopData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No sellers found.'));
                }

                List<Shop> shops = snapshot.data!;

                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: paddingView_vertical,
                    horizontal: paddingView_horizontal,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Top Sellers",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Table(
                        border: TableBorder.symmetric(
                            inside: BorderSide(color: Colors.grey)),
                        columnWidths: {
                          0: FlexColumnWidth(),
                          1: FlexColumnWidth(),
                          2: FlexColumnWidth(),
                          3: FixedColumnWidth(100.0),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                            ),
                            children: [
                              Center(
                                  child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text("Shop Name",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              )),
                              Center(
                                  child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Revenue",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              )),
                              // Center(
                              //     child: Padding(
                              //   padding: EdgeInsets.all(8.0),
                              //   child: Text("Total Products",
                              //       style: TextStyle(fontWeight: FontWeight.bold)),
                              // )),
                              Center(
                                  child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Products Sold",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              )),
                              Center(
                                  child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Action",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              )),
                            ],
                          ),
                          ...shops.map(
                            (shop) {
                              return TableRow(
                                children: [
                                  TableCell(
                                      child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    child: Text("${shop.shopname}"),
                                  )),
                                  TableCell(
                                      child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    child: Text(
                                        "${shop.revenue}"), // Replace with actual revenue data if available
                                  )),
                                  // TableCell(
                                  //     child: Padding(
                                  //   padding: EdgeInsets.all(8.0),
                                  //   child: Text(
                                  //       "${shop.revenue}"), // Replace with actual revenue data if available
                                  // )),
                                  TableCell(
                                      child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    child: Text(
                                        "${shop.orders}"), // Replace with actual products sold data if available
                                  )),
                                  TableCell(
                                    child: Container(
                                      width: 50,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 10),
                                      child: IconButton(
                                        onPressed: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return ViewStoreProile(
                                                id: shop.shopid,
                                              );
                                            },
                                          );
                                        },
                                        icon: Icon(
                                            Icons.arrow_right_alt_outlined),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ).toList(),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class _DataCard extends StatelessWidget {
  const _DataCard(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.percentage,
      required this.iconData,
      required this.cardIcon});

  final String title;
  final String subTitle;
  final String percentage;
  final IconData iconData;
  final IconData cardIcon;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width =
        MediaQuery.of(context).size.width - sidebarSize - paddingHorizontal;
    return Container(
      height: 90,
      width: width * 0.24,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
              Text(
                subTitle,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
              Row(
                children: [
                  Text(
                    "+ $percentage",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.green,
                    ),
                  ),
                  Icon(
                    iconData,
                    color: Colors.green,
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            width: 30,
          ),
          Icon(
            cardIcon,
            color: primaryBg,
            size: 40,
          ),
        ],
      ),
    );
  }
}
