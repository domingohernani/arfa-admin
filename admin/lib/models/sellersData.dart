import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class Seller {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String phone;
  final String role;
  final String shopname;
  final String shoppermit;
  final String shopvalidid;
  final Map<String, String> address;
  // final List<Map<String, dynamic>> cart;
  // final String wishlist;

  Seller({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.role,
    required this.address,
    required this.shopname,
    required this.shoppermit,
    required this.shopvalidid,
    // required this.cart,
    // required this.wishlist,
  });

  factory Seller.fromFirestore(Map<String, dynamic> data) {
    return Seller(
      id: data["id"] ?? "",
      firstname: data["firstname"] ?? "",
      lastname: data["lastname"] ?? "",
      email: data["email"] ?? "",
      phone: data["phoneNumber"] ?? "",
      role: data["role"] ?? "",
      address: {
        "street": data["street"] ?? "",
        "barangay": data["barangay"] ?? "",
        "city": data["city"] ?? "",
        "province": data["province"] ?? "",
        "region": data["region"] ?? "",
      },
      shopname: data["name"] ?? "",
      shopvalidid: data["validId"],
      shoppermit: data["businessPermit"],

      // cart: data["cart"],
      // wishlist: data["wishlist"],
    );
  }
}

// class Customer {
//   String? id;
//   String? firstname;
//   String? lastname;
//   String? email;
//   String? phone;
//   String? role;
//   Map<String, String>? location = {};
//   List<Map<String, String>>? cart = [];
//   List<String>? wishlist = [];

//   Customer({
//     this.id,
//     this.firstname,
//     this.lastname,
//     this.email,
//     this.phone,
//     this.role,
//     this.location,
//     this.cart,
//     this.wishlist,
//   });

//   factory Customer.fromFirestore(Map<String, dynamic> snapshot) {
//     final data = snapshot;

//     return Customer(
//       id: data["id"] ?? '',
//       firstname: data["firstame"] ?? '',
//       lastname: data["lastname"] ?? '',
//       email: data["email"] ?? '',
//       phone: data["phoneNumber"] ?? '',
//       role: data["role"] ?? '',
//       location: {
//         "street": data["location"]["street"] ?? '',
//         "barangay": data["location"]["barangay"] ?? '',
//         "city": data["location"]["city"] ?? '',
//         "province": data["location"]["province"] ?? '',
//         "region": data["location"]["region"] ?? '',
//       },
//       cart: [
//         {
//           "furnitureId": data["cart"]["furnitureId"] ?? '',
//           "sellerId": data["cart"]["sellerId"] ?? '',
//           "variant": data["cart"]["variant"] ?? '',
//         }
//       ],
//       wishlist: data["wishlist"] ?? '',
//     );
//   }
// }
