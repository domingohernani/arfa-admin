import 'package:admin/models/furnituresData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Stock {
  final String id;
  final String variant;
  final int previousQuantity;
  final int addedQuantity;
  final int latestQuantity;
  final Timestamp updatedAt;

  Stock({
    required this.id,
    required this.variant,
    required this.previousQuantity,
    required this.addedQuantity,
    required this.latestQuantity,
    required this.updatedAt,
  });
}
