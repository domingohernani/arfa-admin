import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String shopperid;
  final String description;
  final int rating;
  final String title;
  final DateTime date;

  Review({
    required this.shopperid,
    required this.description,
    required this.rating,
    required this.title,
    required this.date,
  });
}
