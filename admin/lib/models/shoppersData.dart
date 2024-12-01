import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class Shopper {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String phone;
  final String role;
  final String profileurl;
  final Timestamp datejoined;
  final Map<String, String> location;

  Shopper(
      {required this.id,
      required this.firstname,
      required this.lastname,
      required this.email,
      required this.phone,
      required this.role,
      required this.location,
      required this.profileurl,
      required this.datejoined});
}
