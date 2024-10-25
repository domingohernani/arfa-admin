import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String shopid;
  final String shopperid;
  final String orderstatus;
  final int ordertotal;
  final Timestamp createdat;
  final List<dynamic> orderitems;

  OrderItem({
    required this.shopid,
    required this.shopperid,
    required this.orderstatus,
    required this.ordertotal,
    required this.createdat,
    required this.orderitems,
  });

  factory OrderItem.fromFirestore(Map<String, dynamic> data) {
    return OrderItem(
      shopid: data['shopid'] ?? '',
      shopperid: data['shopperid'] ?? '',
      orderstatus: data['orderstatus'] ?? '',
      ordertotal: data['ordertotal'] ?? 0,
      createdat: data['createdat'],
      orderitems: data['orderItems'] ?? [],
    );
  }
}
