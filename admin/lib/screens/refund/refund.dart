import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Refund extends StatefulWidget {
  @override
  _RefundState createState() => _RefundState();
}

class _RefundState extends State<Refund> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> cancellations = [];
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    fetchCancellationsAndOrders();
  }

  Future<void> fetchCancellationsAndOrders() async {
    try {
      // Fetch cancellations where status is not "refunded"
      QuerySnapshot cancellationsSnapshot = await _firestore
          .collection('cancellations')
          .where('status', isNotEqualTo: 'refunded')
          .get();
      List<Map<String, dynamic>> fetchedCancellations =
          cancellationsSnapshot.docs
              .map((doc) => {
                    'id': doc.id,
                    ...doc.data() as Map<String, dynamic>,
                  })
              .toList();

      // Fetch all orders
      QuerySnapshot ordersSnapshot =
          await _firestore.collection('orders').get();
      List<Map<String, dynamic>> fetchedOrders = ordersSnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();

      setState(() {
        cancellations = fetchedCancellations;
        orders = fetchedOrders;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> markAsRefunded(String documentId) async {
    try {
      await _firestore
          .collection('cancellations')
          .doc(documentId)
          .update({'status': 'refunded'});
      fetchCancellationsAndOrders();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Marked as refunded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating status: $e')),
      );
    }
  }

  Future<void> showConfirmationDialog(String documentId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Refund'),
          content:
              const Text('Are you sure you want to mark this as refunded?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await markAsRefunded(documentId);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'N/A';
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  Future<void> openLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: const Text(
            'Refund Table',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: cancellations.isEmpty && orders.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.grey[50],
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(7, 209, 209, 209)
                          .withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: constraints.maxWidth, // Full width of container
                        child: DataTable(
                          columnSpacing: 16.0, // Adjust column spacing
                          columns: [
                            const DataColumn(label: Text('Order ID')),
                            const DataColumn(label: Text('Reason')),
                            const DataColumn(label: Text('Date')),
                            const DataColumn(label: Text('Link')),
                            const DataColumn(label: Text('Action')),
                          ],
                          rows: cancellations.map((cancellation) {
                            String refNumber = orders.firstWhere(
                                    (order) =>
                                        order['id'] == cancellation['orderId'],
                                    orElse: () =>
                                        {'refNumber': 'N/A'})['refNumber'] ??
                                'N/A';

                            String url =
                                'https://dashboard.paymongo.com/links/$refNumber';

                            return DataRow(cells: [
                              DataCell(Text(cancellation['orderId'] ?? 'N/A')),
                              DataCell(Text(
                                  (cancellation['reason'] ?? []).join(', '))),
                              DataCell(Text(formatDate(cancellation['date']))),
                              DataCell(
                                InkWell(
                                  onTap: () => openLink(url),
                                  child: const Text(
                                    'Open Link',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () => showConfirmationDialog(
                                      cancellation['id']),
                                  child: const Text('Mark as Refunded'),
                                ),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
