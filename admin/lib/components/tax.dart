import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaxScreen extends StatefulWidget {
  const TaxScreen({super.key});

  @override
  State<TaxScreen> createState() => _TaxScreenState();
}

class _TaxScreenState extends State<TaxScreen> {
  List<Map<String, dynamic>> taxData = [];
  final int minRowCount = 5;
  String? updatedBy;

  @override
  void initState() {
    super.initState();
    fetchUpdatedBy();
    fetchTaxData();
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

  Future<void> fetchTaxData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('tax')
          .orderBy('updatedAt', descending: true)
          .limit(5)
          .get();

      final data = querySnapshot.docs.map((doc) {
        final tax = doc.data();
        return {
          'updatedAt': (tax['updatedAt'] as Timestamp).toDate(),
          'value': tax['value'],
          'updatedBy': tax['updatedBy'] ?? 'Unknown',
        };
      }).toList();

      setState(() {
        taxData = data;
      });
    } catch (e) {
      print("Error fetching tax data: $e");
    }
  }

  void showUpdateModal() {
    final TextEditingController taxController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Update Tax Value",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enter the new tax value as a decimal (e.g., 0.12 for 12%).",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: taxController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: "Tax Value (Decimal)",
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
                final double? taxValue =
                    double.tryParse(taxController.text.trim());
                if (taxValue != null && taxValue >= 0 && taxValue <= 1) {
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
                    await FirebaseFirestore.instance.collection('tax').add({
                      'value': taxValue,
                      'updatedAt': FieldValue.serverTimestamp(),
                      'updatedBy': updatedBy,
                    });

                    await fetchTaxData();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Tax value updated successfully!"),
                      ),
                    );
                  } catch (e) {
                    print("Error adding document: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Failed to update tax value."),
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
    List<Map<String, dynamic>> filledData = [...taxData];
    while (filledData.length < minRowCount) {
      filledData.add({'updatedAt': null, 'value': null, 'updatedBy': null});
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tax Records',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.update),
            onPressed: showUpdateModal,
          ),
        ],
      ),
      body: taxData.isEmpty
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
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            textAlign: TextAlign.center,
                            "Date Updated",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            textAlign: TextAlign.center,
                            "Tax Value",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            textAlign: TextAlign.center,
                            "Updated By",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    ...filledData.map((tax) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text(
                              tax['updatedAt'] != null
                                  ? tax['updatedAt'].toString()
                                  : "-",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text(
                              tax['value'] != null
                                  ? (tax['value'] * 100).toStringAsFixed(2) +
                                      "%"
                                  : "-",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text(
                              tax['updatedBy'] ?? "-",
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
