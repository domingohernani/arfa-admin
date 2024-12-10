import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommissionRateScreen extends StatefulWidget {
  const CommissionRateScreen({super.key});

  @override
  State<CommissionRateScreen> createState() => _CommissionRateScreenState();
}

class _CommissionRateScreenState extends State<CommissionRateScreen> {
  List<Map<String, dynamic>> commissionData = [];
  final int minRowCount = 5;
  String? updatedBy;

  @override
  void initState() {
    super.initState();
    fetchUpdatedBy();
    fetchCommissionData();
  }

  Future<void> fetchUpdatedBy() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final adminDoc = await FirebaseFirestore.instance
            .collection('admins')
            .doc(user.uid)
            .get();

        setState(() {
          updatedBy = adminDoc.data()?['name'] ?? 'Admin';
        });
      } catch (e) {
        print("Error fetching admin data: $e");
      }
    } else {
      print("No user is logged in.");
    }
  }

  Future<void> fetchCommissionData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('commission-rate')
          .orderBy('updatedAt', descending: true)
          .limit(5)
          .get();

      final data = querySnapshot.docs.map((doc) {
        final commission = doc.data();
        return {
          'updatedAt': (commission['updatedAt'] as Timestamp).toDate(),
          'value': commission['value'],
          'updatedBy': commission['updatedBy'] ?? 'Unknown',
        };
      }).toList();

      setState(() {
        commissionData = data;
      });
    } catch (e) {
      print("Error fetching commission data: $e");
    }
  }

  void showUpdateModal() {
    final TextEditingController commissionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Update Commission Rate",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enter the new commission rate as a decimal (e.g., 0.12 for 12%).",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commissionController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: "Commission Rate (Decimal)",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final double? commissionValue =
                    double.tryParse(commissionController.text.trim());
                if (commissionValue != null &&
                    commissionValue >= 0 &&
                    commissionValue <= 1) {
                  if (updatedBy == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            "Error: Please try logging out and logging in again."),
                      ),
                    );
                    return;
                  }

                  try {
                    await FirebaseFirestore.instance
                        .collection('commission-rate')
                        .add({
                      'value': commissionValue,
                      'updatedAt': FieldValue.serverTimestamp(),
                      'updatedBy': updatedBy,
                    });

                    await fetchCommissionData();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Commission rate updated successfully!"),
                      ),
                    );
                  } catch (e) {
                    print("Error adding document: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Failed to update commission rate."),
                      ),
                    );
                  }
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Please enter a valid decimal value between 0 and 1.",
                      ),
                    ),
                  );
                }
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filledData = [...commissionData];
    while (filledData.length < minRowCount) {
      filledData.add({'updatedAt': null, 'value': null, 'updatedBy': null});
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Commission Rate Records',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.update),
            onPressed: showUpdateModal,
          ),
        ],
      ),
      body: commissionData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: Table(
                  border: TableBorder.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(2), // Adjust proportionally
                    1: FlexColumnWidth(1), // Adjust proportionally
                    2: FlexColumnWidth(2), // Adjust proportionally
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      children: const [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Date Updated",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Commission Rate",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Updated By",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...filledData.map((commission) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18),
                            child: Text(
                              commission['updatedAt'] != null
                                  ? commission['updatedAt'].toString()
                                  : "-",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18),
                            child: Text(
                              commission['value'] != null
                                  ? (commission['value'] * 100)
                                          .toStringAsFixed(2) +
                                      "%"
                                  : "-",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18),
                            child: Text(
                              commission['updatedBy'] ?? "-",
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
    );
  }
}
