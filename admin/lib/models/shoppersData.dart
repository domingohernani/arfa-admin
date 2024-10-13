import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class Shopper {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String phone;
  final String role;
  final Map<String, String> location;
  // final List<Map<String, dynamic>> cart;
  // final String wishlist;

  Shopper({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.role,
    required this.location,
    // required this.cart,
    // required this.wishlist,
  });

  factory Shopper.fromFirestore(Map<String, dynamic> data) {
    return Shopper(
      id: data["id"] ?? "",
      firstname: data["firstName"] ?? "",
      lastname: data["lastName"] ?? "",
      email: data["email"] ?? "",
      phone: data["phoneNumber"] ?? "",
      role: data["role"] ?? "",
      location: {
        "street": data["street"] ?? "",
        "barangay": data["barangay"] ?? "",
        "city": data["city"] ?? "",
        "province": data["province"] ?? "",
        "region": data["region"] ?? "",
      },
      // cart: data["cart"],
      // wishlist: data["wishlist"],
    );
  }
}
