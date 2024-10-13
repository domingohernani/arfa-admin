import 'package:admin/models/adminData.dart';
import 'package:admin/models/sellersData.dart';
import 'package:admin/models/shoppersData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final _firestore_db = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;

  // Add a callback to handle the retrieved admin data
  Future<Admin?> getAdminData(String adminId) async {
    try {
      var data = await _firestore_db.collection("admins").doc(adminId).get();

      if (data.exists) {
        // print("Document exists: ${data.data()}");
        return Admin.fromFirestore(data);
      } else {
        print("Document doesn't exists.");
        return null;
      }
    } catch (error) {
      print("Error: $error");
      return null;
    }
  }

  Future<List<Seller>> getSellersData() async {
    final _firestore_db = FirebaseFirestore.instance;
    List<Seller> sellers = [];
    Map<String, Map<String, dynamic>> shopsInfo = {};

    try {
      QuerySnapshot snapshotUsers =
          await _firestore_db.collection('users').get();
      QuerySnapshot snapshotShops =
          await _firestore_db.collection('shops').get();

      for (var shopDoc in snapshotShops.docs) {
        Map<String, dynamic> data = shopDoc.data() as Map<String, dynamic>;

        String sellerId = data['userId'] ?? "";
        shopsInfo[sellerId] = {
          'name': data['name'] ?? "",
          'validId': data['validId'] ?? "",
          'businessPermit': data['businessPermit'] ?? "",
        };
      }

      for (var userdoc in snapshotUsers.docs) {
        Map<String, dynamic> data = userdoc.data() as Map<String, dynamic>;
        Map<String, dynamic>? shopData = shopsInfo[data['id']];

        final user = Seller(
          id: data['id'] ?? "",
          firstname: data['firstname'] ?? "",
          lastname: data['lastname'] ?? "",
          email: data['email'] ?? "",
          phone: data['phone'] ?? "",
          role: data['role'] ?? "",
          address: {
            "street": data["street"]?.toString() ?? '',
            "barangay": data["barangay"]?.toString() ?? '',
            "city": data["city"]?.toString() ?? '',
            "province": data["province"]?.toString() ?? '',
            "region": data["region"]?.toString() ?? '',
          },
          shopname: shopData?['name'] ?? "",
          shopvalidid: shopData?['validId'] ?? "",
          shoppermit: shopData?['businessPermit'] ?? "",
          // Optionally handle these fields if necessary
          // location: data['location']?.toString() ?? "",
          // cart: data['cart']?.toString() ?? "",
          // wishlist: data['wishlist']?.toString() ?? "",
        );

        if (user.role.toLowerCase() == 'seller') {
          sellers.add(user);
        }
      }
    } catch (error) {
      print(error);
    }

    return sellers;
  }

  Future<List<Shopper>> getShoppersData() async {
    final _firestore_db = FirebaseFirestore.instance;
    List<Shopper> shoppers = [];

    try {
      QuerySnapshot snapshotUsers =
          await _firestore_db.collection('users').get();

      for (var userdoc in snapshotUsers.docs) {
        Map<String, dynamic> data = userdoc.data() as Map<String, dynamic>;

        final user = Shopper(
          id: data['id'] ?? "",
          firstname: data['firstName'] ?? "",
          lastname: data['lastName'] ?? "",
          email: data['email'] ?? "",
          phone: data['phoneNumber'] ?? "No Phone Number",

          role: data['role'] ?? "",
          location: {
            "street": data["street"]?.toString() ?? '',
            "barangay": data["barangay"]?.toString() ?? '',
            "city": data["city"]?.toString() ?? '',
            "province": data["province"]?.toString() ?? '',
            "region": data["region"]?.toString() ?? '',
          },
          // Optionally handle these fields if necessary
          // location: data['location']?.toString() ?? "",
          // cart: data['cart']?.toString() ?? "",
          // wishlist: data['wishlist']?.toString() ?? "",
        );

        if (user.role.toLowerCase() == 'shopper') {
          shoppers.add(user);
        }
      }
    } catch (error) {
      print(error);
    }

    return shoppers;
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
