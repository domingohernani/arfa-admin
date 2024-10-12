import 'package:admin/models/adminData.dart';
import 'package:admin/models/customerData.dart';
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
        print("Document exists: ${data.data()}");
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

  // Future<Customer?> getUserData(String userId) async {
  //   try {
  //     var data = await _firestore_db.collection("users").doc(userId).get();

  //     if (data.exists) {
  //       print("www: ${data.data()}");
  //       return Customer.fromFirestore(data.data()!);
  //     } else {
  //       print("Document doesn't exists.");
  //       return null;
  //     }
  //   } catch (error) {
  //     print("Error: $error");
  //     return null;
  //   }
  // }

  Future<void> getUserData() async {
    final _firestore_db = FirebaseFirestore.instance;

    try {
      // Access the collection (replace 'users' with your collection name)
      QuerySnapshot snapshot = await _firestore_db.collection('users').get();

      // Loop through each document in the collection
      for (var doc in snapshot.docs) {
        print("Document ID: ${doc.id}");

        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        Customer customer = Customer.fromFirestore(data);
        // // Print each key-value pair from the document
        // data.forEach((key, value) {
        //   print("$key: $value");
        // });

        // print("\n---------------------------\n"); // Separator between documents
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
