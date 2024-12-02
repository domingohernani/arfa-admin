import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopsScreen extends StatefulWidget {
  @override
  _ShopsScreenState createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {
  bool showOnlyInvalid = false;

  void markAsValid(String shopId) async {
    try {
      await FirebaseFirestore.instance
          .collection('shops')
          .doc(shopId)
          .update({'isDocumentsValid': true});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shop marked as valid!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error marking shop as valid: $e')),
      );
    }
  }

  Future<void> openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void showConfirmationDialog(String shopId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Action'),
          content:
              const Text('Are you sure you want to mark this shop as valid?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                markAsValid(shopId);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shops',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          Switch(
            value: showOnlyInvalid,
            onChanged: (value) {
              setState(() {
                showOnlyInvalid = value;
              });
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: SingleChildScrollView(
          // scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width, // Full screen width
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('shops').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final shops = snapshot.data!.docs
                    .where((doc) => showOnlyInvalid
                        ? doc['isDocumentsValid'] == false
                        : true)
                    .toList();

                if (shops.isEmpty) {
                  return const Center(child: Text('No shops to display'));
                }

                return DataTable(
                  columnSpacing: 24.0,
                  columns: const [
                    DataColumn(label: Text('Shop Name')),
                    DataColumn(label: Text('Business Permit')),
                    DataColumn(label: Text('Valid ID')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: shops.map((shop) {
                    final isValid = shop['isDocumentsValid'] as bool;
                    final businessPermit = shop['businessPermit'] ?? '';
                    final validId = shop['validId'] ?? '';

                    return DataRow(
                      cells: [
                        DataCell(Text(shop['name'] ?? 'Unnamed Shop')),
                        DataCell(
                          businessPermit.isNotEmpty
                              ? InkWell(
                                  onTap: () => openUrl(businessPermit),
                                  child: const Text(
                                    'View Document',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                )
                              : const Text('Not Available'),
                        ),
                        DataCell(
                          validId.isNotEmpty
                              ? InkWell(
                                  onTap: () => openUrl(validId),
                                  child: const Text(
                                    'View Document',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                )
                              : const Text('Not Available'),
                        ),
                        DataCell(
                          isValid
                              ? const Icon(Icons.check, color: Colors.green)
                              : const Icon(Icons.close, color: Colors.red),
                        ),
                        DataCell(
                          isValid
                              ? const Text('No Action Needed')
                              : ElevatedButton(
                                  onPressed: () =>
                                      showConfirmationDialog(shop.id),
                                  child: const Text('Mark as Valid'),
                                ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
