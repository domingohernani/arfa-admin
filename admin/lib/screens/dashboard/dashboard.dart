import 'package:admin/components/bargraph.dart';
import 'package:admin/components/linegraphOrders.dart';
import 'package:admin/dataInitialization.dart';
import 'package:admin/models/furnituresData.dart';
import 'package:admin/models/monthlyData.dart';
import 'package:admin/models/ordersData.dart';
import 'package:admin/models/sellersData.dart';
import 'package:admin/models/shoppersData.dart';
import 'package:admin/models/shopsData.dart';
import 'package:admin/models/topProductsData.dart';
import 'package:admin/screens/customers/viewStore.dart';
import 'package:admin/services/firestoreService.dart';
import 'package:admin/themes/theme.dart';
import 'package:admin/utilities/exportCSV.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  FirestoreService _fs = FirestoreService();
  List<Seller> _sellers = [];
  List<Furniture> _furnitures = [];

  int? compareFromValue;
  int? compareToValue;
  List<int> compareFrom = [];
  List<int> compareTo = [];

  MonthlyReport? _report;

  Map<String, double> _deviceData = {
    "Desktop": 0,
    "Mobile": 0,
    "Tablet": 0,
  };

  @override
  void initState() {
    super.initState();
    _fetchDeviceData();
    _generateYearLists();
  }

  void _generateYearLists() {
    // Replace these values with actual data fetching logic if needed
    int startYear = 2010;
    int endYear = DateTime.now().year;

    setState(() {
      compareFrom = List.generate(
        endYear - startYear + 1,
        (index) => (startYear + index),
      );
      compareTo = List<int>.from(compareFrom); // Clone for separate use
    });

    // Set default values for dropdowns
    if (compareFrom.isNotEmpty) {
      compareFromValue = compareFrom.first; // Default to the first value
      compareToValue = compareTo.last; // Default to the last value
    }
  }

  void _fetchDeviceData() async {
    try {
      List<OrderItem> orders = await _fs.getOrdersData();
      Map<String, int> deviceCounts = {
        "Desktop": 0,
        "Mobile": 0,
        "Tablet": 0,
      };

      for (var order in orders) {
        if (order.devicetype != null && order.devicetype.isNotEmpty) {
          deviceCounts[order.devicetype] =
              (deviceCounts[order.devicetype] ?? 0) + 1;
        }
      }

      setState(() {
        _deviceData = {
          "Desktop": deviceCounts["Desktop"]!.toDouble(),
          "Mobile": deviceCounts["Mobile"]!.toDouble(),
          "Tablet": deviceCounts["Tablet"]!.toDouble(),
        };
      });
    } catch (e) {
      print("Error fetching device data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width =
        MediaQuery.of(context).size.width - sidebarSize - paddingHorizontal;
    return Container(
      height: height,
      width: double.infinity,
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
                  "Dashboard",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // OutlinedButton(
                //   onPressed: () {},
                //   child: const Row(
                //     children: [
                //       Icon(
                //         Icons.settings,
                //         size: 20,
                //         color: Colors.black,
                //       ),
                //       SizedBox(
                //         width: 5,
                //       ),
                //       Text(
                //         "Manage",
                //         style: TextStyle(
                //           color: Colors.black,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            FutureBuilder(
              future: _fs.getMonthlyReport(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: const CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No sellers found.'));
                }

                var reports = snapshot.data!;

                return Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Container(
                                  width: 900,
                                  height: double.infinity,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Monthly Revenue",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: primary,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        FutureBuilder<List<Shop>>(
                                          future:
                                              _fs.getShopDataForCurrentMonth(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else if (snapshot.hasError) {
                                              return Center(
                                                child: Text(
                                                    'Error: ${snapshot.error}'),
                                              );
                                            } else if (!snapshot.hasData ||
                                                snapshot.data!.isEmpty) {
                                              return const Center(
                                                child:
                                                    Text('No sellers found.'),
                                              );
                                            }

                                            // Extract data from the snapshot
                                            List<Shop> shops = snapshot.data!;

                                            return Container(
                                              // decoration: BoxDecoration(
                                              //   color: Colors.white,
                                              //   borderRadius:
                                              //       BorderRadius.circular(10),
                                              //   boxShadow: [
                                              //     BoxShadow(
                                              //       color: Colors.black
                                              //           .withOpacity(0.2),
                                              //       spreadRadius: 1,
                                              //       blurRadius: 5,
                                              //       offset: const Offset(2, 4),
                                              //     ),
                                              //   ],
                                              // ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 10),
                                                  Table(
                                                    border: const TableBorder
                                                        .symmetric(
                                                      inside: BorderSide(
                                                          color: Colors.grey),
                                                    ),
                                                    columnWidths: const {
                                                      0: FlexColumnWidth(),
                                                      1: FlexColumnWidth(),
                                                      2: FlexColumnWidth(),
                                                      3: FlexColumnWidth(),
                                                    },
                                                    defaultVerticalAlignment:
                                                        TableCellVerticalAlignment
                                                            .middle,
                                                    children: [
                                                      // Header Row
                                                      TableRow(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .grey.shade200,
                                                        ),
                                                        children: const [
                                                          Center(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          12.0),
                                                              child: Text(
                                                                "ID",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                          Center(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          12.0),
                                                              child: Text(
                                                                "Shop Name",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                          Center(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                "Revenue",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                          Center(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                "Products Sold",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      // Data Rows
                                                      ...shops.map(
                                                        (shop) {
                                                          return TableRow(
                                                            children: [
                                                              TableCell(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    vertical: 4,
                                                                    horizontal:
                                                                        10,
                                                                  ),
                                                                  child: Text(shop
                                                                      .shopid),
                                                                ),
                                                              ),
                                                              TableCell(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    vertical: 4,
                                                                    horizontal:
                                                                        10,
                                                                  ),
                                                                  child: Text(shop
                                                                      .shopname),
                                                                ),
                                                              ),
                                                              TableCell(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    vertical: 4,
                                                                    horizontal:
                                                                        10,
                                                                  ),
                                                                  child: Text(
                                                                    shop.revenue
                                                                        .toStringAsFixed(
                                                                            2),
                                                                  ), // Displays revenue as a formatted string
                                                                ),
                                                              ),
                                                              TableCell(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    vertical: 4,
                                                                    horizontal:
                                                                        10,
                                                                  ),
                                                                  child: Text(shop
                                                                      .orders
                                                                      .toString()),
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: _DataCard(
                          title:
                              "₱ ${reports.monthlyrevenue.toStringAsFixed(2)}",
                          subTitle: "Monthly Revenue",
                          percentage: "85.00",
                          iconData: Icons.arrow_drop_up_outlined,
                          cardIcon: Icons.attach_money_outlined,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Container(
                                  width: 900,
                                  height: double.infinity,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Monthly Orders",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: primary,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        FutureBuilder<List<OrderItem>>(
                                          future: _fs.getOrdersData(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              return Center(
                                                  child: Text(
                                                      'Error: ${snapshot.error}'));
                                            } else if (!snapshot.hasData ||
                                                snapshot.data!.isEmpty) {
                                              return const Center(
                                                  child:
                                                      Text('No orders found.'));
                                            }

                                            List<OrderItem> orders =
                                                snapshot.data!;

                                            return SingleChildScrollView(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Table(
                                                  border: const TableBorder
                                                      .symmetric(
                                                    inside: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  columnWidths: const {
                                                    0: FlexColumnWidth(),
                                                    1: FlexColumnWidth(),
                                                    2: FlexColumnWidth(),
                                                    3: FlexColumnWidth(),
                                                    4: FlexColumnWidth(),
                                                    5: FlexColumnWidth(),
                                                  },
                                                  defaultVerticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .middle,
                                                  children: [
                                                    // Header Row
                                                    TableRow(
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade200,
                                                      ),
                                                      children: const [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12.0),
                                                          child: Center(
                                                              child: Text(
                                                                  "Shop ID",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12.0),
                                                          child: Center(
                                                              child: Text(
                                                                  "Shopper ID",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12.0),
                                                          child: Center(
                                                              child: Text(
                                                                  "Order Status",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12.0),
                                                          child: Center(
                                                              child: Text(
                                                                  "Order Total",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12.0),
                                                          child: Center(
                                                              child: Text(
                                                                  "Device Type",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12.0),
                                                          child: Center(
                                                              child: Text(
                                                                  "Created At",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))),
                                                        ),
                                                      ],
                                                    ),
                                                    // Data Rows
                                                    ...orders.map((order) {
                                                      return TableRow(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Center(
                                                                child: Text(order
                                                                    .shopid)),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Center(
                                                                child: Text(order
                                                                    .shopperid)),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Center(
                                                                child: Text(order
                                                                    .orderstatus)),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Center(
                                                                child: Text(order
                                                                    .ordertotal
                                                                    .toString())),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Center(
                                                                child: Text(order
                                                                    .devicetype)),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Center(
                                                                child: Text(order
                                                                    .createdat
                                                                    .toDate()
                                                                    .toString())),
                                                          ),
                                                        ],
                                                      );
                                                    }).toList(),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: _DataCard(
                          title: "${reports.monthlyorders}",
                          subTitle: "Orders",
                          percentage: "96.00",
                          iconData: Icons.arrow_drop_up_outlined,
                          cardIcon: Icons.shopping_bag_outlined,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Container(
                                  width:
                                      900, // Using double.infinity for better responsiveness
                                  height: double.infinity,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "New Users",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: primary,
                                            ),
                                          ),
                                        ),
                                        FutureBuilder<List<Shopper>>(
                                          future:
                                              _fs.getUsersDataForCurrentMonth(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              return Center(
                                                  child: Text(
                                                      'Error: ${snapshot.error}'));
                                            } else if (!snapshot.hasData ||
                                                snapshot.data!.isEmpty) {
                                              return const Center(
                                                  child: Text(
                                                      'No data available'));
                                            }

                                            List<Shopper> shoppers =
                                                snapshot.data!;

                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Table(
                                                border:
                                                    const TableBorder.symmetric(
                                                  inside: BorderSide(
                                                      color: Colors.grey),
                                                ),
                                                columnWidths: const {
                                                  0: FlexColumnWidth(2),
                                                  1: FlexColumnWidth(2),
                                                  2: FlexColumnWidth(2),
                                                  3: FlexColumnWidth(2),
                                                },
                                                children: [
                                                  // Header Row
                                                  TableRow(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade200,
                                                    ),
                                                    children: const [
                                                      TableCell(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Center(
                                                            child: Text(
                                                              'First Name',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Center(
                                                            child: Text(
                                                              'Last Name',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Center(
                                                            child: Text(
                                                              'Role',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Center(
                                                            child: Text(
                                                              'Date Joined',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  // Data Rows
                                                  ...shoppers.map((shopper) {
                                                    return TableRow(
                                                      children: [
                                                        TableCell(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(shopper
                                                                .firstname),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(shopper
                                                                .lastname),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                                shopper.role),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(shopper
                                                                .datejoined
                                                                .toDate()
                                                                .toString()),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }).toList(),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: _DataCard(
                          title: "${reports.newusers}",
                          subTitle: "New Users",
                          percentage: "98.00",
                          iconData: Icons.arrow_drop_up_outlined,
                          cardIcon: Icons.person_add_alt_1_outlined,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: _DataCard(
                          title: "${reports.currentusers}",
                          subTitle: "Existing Users",
                          percentage: "87.00",
                          iconData: Icons.arrow_drop_up_outlined,
                          cardIcon: Icons.groups_2_outlined,
                        ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Orders Every Month",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 230,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DropdownButton<int>(
                                  value: compareFromValue,
                                  hint: const Text('Default'),
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(fontSize: 13),
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      compareFromValue = newValue;
                                    });
                                  },
                                  items: compareFrom
                                      .map<DropdownMenuItem<int>>((int value) {
                                    return DropdownMenuItem<int>(
                                      value: value,
                                      child: Text('${value.toString()}'),
                                    );
                                  }).toList(),
                                ),
                                const Text("compare"),
                                DropdownButton<int>(
                                  value: compareToValue,
                                  hint: const Text('Default'),
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(fontSize: 13),
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      compareToValue = newValue;
                                    });
                                  },
                                  items: compareTo
                                      .map<DropdownMenuItem<int>>((int value) {
                                    return DropdownMenuItem<int>(
                                      value: value,
                                      child: Text("${value}"),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                          "This metric shows how many orders are placed each day over a month, helping you see trends in customer demand."),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 300,
                        width: width * 0.63,
                        child: LineGraph(
                          compareFrom: compareFromValue!,
                          compareTo: compareToValue!,
                        ),
                      ),
                    ],
                  ),
                ),
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
                        "Weekly Sales",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                          "This weekly metric shows daily sales trends, helping you identify the busiest days."),
                      const SizedBox(
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
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<List<Shop>>(
              future: _fs.getShopData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No sellers found.'));
                }

                List<Shop> shops = snapshot.data!;

                return Container(
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
                      const Text(
                        "Top Sellers",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Table(
                        border: const TableBorder.symmetric(
                            inside: BorderSide(color: Colors.grey)),
                        columnWidths: {
                          0: const FlexColumnWidth(),
                          1: const FlexColumnWidth(),
                          2: const FixedColumnWidth(200.0),
                          3: const FixedColumnWidth(150.0),
                          4: const FixedColumnWidth(100.0),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                            ),
                            children: [
                              const Center(
                                  child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text("ID",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              )),
                              const Center(
                                  child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text("Shop Name",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              )),
                              const Center(
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
                              const Center(
                                  child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Products Sold",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              )),
                              const Center(
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    child: Text("${shop.shopid}"),
                                  )),
                                  TableCell(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    child: Text("${shop.shopname}"),
                                  )),
                                  TableCell(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    child: Text(
                                        "${shop.orders}"), // Replace with actual products sold data if available
                                  )),
                                  TableCell(
                                    child: Container(
                                      width: 50,
                                      padding: const EdgeInsets.symmetric(
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
                                        icon: const Icon(
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
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<List<TopProduct>>(
              future: _fs.getTopProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }

                List<TopProduct> furniture = snapshot.data!;

                return Container(
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
                      const Text(
                        "Top Products",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Table(
                        border: const TableBorder.symmetric(
                            inside: BorderSide(color: Colors.grey)),
                        columnWidths: {
                          0: const FlexColumnWidth(),
                          1: const FixedColumnWidth(250),
                          2: const FixedColumnWidth(150),
                          3: const FixedColumnWidth(150),
                          4: const FixedColumnWidth(100.0),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                            ),
                            children: [
                              const Center(
                                  child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text("Name",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              )),
                              const Center(
                                  child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Category",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              )),
                              // Center(
                              //     child: Padding(
                              //   padding: EdgeInsets.all(8.0),
                              //   child: Text("Total Products",
                              //       style: TextStyle(fontWeight: FontWeight.bold)),
                              // )),
                              const Center(
                                  child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Solds",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              )),
                              const Center(
                                  child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Price",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              )),
                              const Center(
                                  child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Action",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              )),
                            ],
                          ),
                          ...furniture.map(
                            (product) {
                              return TableRow(
                                children: [
                                  TableCell(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    child: Text("${product.name}"),
                                  )),
                                  TableCell(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    child: Text(
                                        "${product.category}"), // Replace with actual revenue data if available
                                  )),
                                  // TableCell(
                                  //     child: Padding(
                                  //   padding: EdgeInsets.all(8.0),
                                  //   child: Text(
                                  //       "${shop.revenue}"), // Replace with actual revenue data if available
                                  // )),
                                  TableCell(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    child: Text(
                                        "${product.solds}"), // Replace with actual products sold data if available
                                  )),
                                  TableCell(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    child: Text(
                                        "${product.price}"), // Replace with actual products sold data if available
                                  )),
                                  TableCell(
                                    child: Container(
                                      width: 50,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 10),
                                      child: IconButton(
                                        onPressed: () async {
                                          // await showDialog(
                                          //   context: context,
                                          //   builder: (context) {
                                          //     return ViewStoreProile(
                                          //       id: shop.shopid,
                                          //     );
                                          //   },
                                          // );
                                        },
                                        icon: const Icon(
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
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: width * 0.80,
                  padding: const EdgeInsets.all(20),
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
                        "Device Usage Distribution",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                          "This chart shows the distribution of devices used for placing orders."),
                      const SizedBox(height: 20),
                      Container(
                        height: 300,
                        width: 400,
                        child: PieChart(
                          PieChartData(
                            sections: _generatePieSections(_deviceData),
                            startDegreeOffset: 0,
                            centerSpaceRadius: 0,
                            sectionsSpace: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // FutureBuilder(
            //   future: _fs.getSellersData(),
            //   initialData: 5,
            //   builder: (context, snapshot) {
            //     return Container(
            //       width: width,
            //       padding: const EdgeInsets.only(
            //         top: 10,
            //         left: 20,
            //         bottom: 10,
            //         right: 25,
            //       ),
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(10),
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.black.withOpacity(0.2),
            //             spreadRadius: 1,
            //             blurRadius: 5,
            //             offset: const Offset(2, 4),
            //           ),
            //         ],
            //       ),
            //       child: Table(
            //         children: [
            //           TableRow(
            //             children: [
            //               Center(
            //                 child: Text("Name"),
            //               ),
            //               Center(
            //                 child: Text("Revenue"),
            //               ),
            //               Center(
            //                 child: Text("Product Sold"),
            //               )
            //             ],
            //           ),
            //           ..._sellers.map(
            //             (seller) {
            //               return TableRow(children: [
            //                 TableCell(child: Text("asdf")),
            //               ]);
            //             },
            //           ).toList()
            //         ],
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

List<PieChartSectionData> _generatePieSections(Map<String, double> data) {
  return data.entries
      .map((entry) => PieChartSectionData(
            value: entry.value,
            title: "${entry.key}: ${entry.value.toInt()}",
            color: _getDeviceColor(entry.key),
            radius: 150,
            titleStyle:
                const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ))
      .toList();
}

Color _getDeviceColor(String device) {
  switch (device) {
    case "Desktop":
      return Colors.blue;
    case "Mobile":
      return Colors.green;
    case "Tablet":
      return Colors.orange;
    default:
      return Colors.grey;
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
                  offset: const Offset(2, 4))
            ]),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 17)),
                Text(subTitle, style: const TextStyle(fontSize: 13)),
                Row(children: [
                  Text("+ $percentage",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.green)),
                  Icon(iconData, color: Colors.green)
                ])
              ]),
          const SizedBox(width: 30),
          Icon(cardIcon, color: primaryBg, size: 40)
        ]));
  }
}
