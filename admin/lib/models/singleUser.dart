import 'package:admin/models/furnituresData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SingleUser {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String phone;
  final Map<String, String> address;
  final Timestamp datejoined;
  final String profileUrl;
  final List<Furniture> wishlists;
  final List<Furniture> cartitems;

  SingleUser({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.address,
    required this.datejoined,
    required this.profileUrl,
    required this.wishlists,
    required this.cartitems,
  });
}
