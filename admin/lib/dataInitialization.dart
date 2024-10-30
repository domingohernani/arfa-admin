// import 'dart:async';

// import 'package:admin/dataInitialization.dart';
// import 'package:admin/models/adminData.dart';
// import 'package:admin/models/furnituresData.dart';
// import 'package:admin/models/monthlyData.dart';
// import 'package:admin/models/ordersData.dart';
// import 'package:admin/models/sellersData.dart';
// import 'package:admin/models/shoppersData.dart';
// import 'package:admin/utilities/dateconvertion.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:intl/intl.dart';

// class FirestoreService {
//   final _firestore_db = FirebaseFirestore.instance;
//   final _firebaseAuth = FirebaseAuth.instance;

//   int currentMonth = DateTime.now().month;

//   int month = DateTime.now().month;
//   int year = DateTime.now().year;
//   int newusers = 0;
//   int existingusers = 0;
//   double revenue = 0;
//   int monthlyorders = 0;

//   // Add a callback to handle the retrieved admin data
//   Future<Admin?> getAdminData(String adminId) async {
//     try {
//       var data = await _firestore_db.collection("admins").doc(adminId).get();

//       if (data.exists) {
//         // print("Document exists: ${data.data()}");
//         return Admin.fromFirestore(data);
//       } else {
//         print("Document doesn't exists.");
//         return null;
//       }
//     } catch (error) {
//       print("Error: $error");
//       return null;
//     }
//   }

//   Future<List<Seller>> getSellersData() async {
//     final _firestore_db = FirebaseFirestore.instance;
//     List<Seller> sellers = [];
//     Map<String, Map<String, dynamic>> shopsInfo = {};

//     try {
//       QuerySnapshot snapshotUsers =
//           await _firestore_db.collection('users').get();
//       QuerySnapshot snapshotShops =
//           await _firestore_db.collection('shops').get();

//       for (var shopDoc in snapshotShops.docs) {
//         Map<String, dynamic> data = shopDoc.data() as Map<String, dynamic>;

//         String sellerId = data['userId'] ?? "";
//         shopsInfo[sellerId] = {
//           'name': data['name'] ?? "",
//           'validId': data['validId'] ?? "",
//           'businessPermit': data['businessPermit'] ?? "",
//         };
//       }

//       for (var userdoc in snapshotUsers.docs) {
//         Map<String, dynamic> data = userdoc.data() as Map<String, dynamic>;
//         Map<String, dynamic>? shopData = shopsInfo[data['id']];

//         final user = Seller(
//           id: data['id'] ?? "",
//           firstname: data['firstName'] ?? "",
//           lastname: data['lastName'] ?? "",
//           email: data['email'] ?? "",
//           phone: data['phone'] ?? "",
//           role: data['role'] ?? "",
//           address: {
//             "street": data["street"]?.toString() ?? '',
//             "barangay": data["barangay"]?.toString() ?? '',
//             "city": data["city"]?.toString() ?? '',
//             "province": data["province"]?.toString() ?? '',
//             "region": data["region"]?.toString() ?? '',
//           },
//           shopname: shopData?['name'] ?? "",
//           shopvalidid: shopData?['validId'] ?? "",
//           shoppermit: shopData?['businessPermit'] ?? "",
//           // Optionally handle these fields if necessary
//           // location: data['location']?.toString() ?? "",
//           // cart: data['cart']?.toString() ?? "",
//           // wishlist: data['wishlist']?.toString() ?? "",
//         );

//         if (user.role.toLowerCase() == 'seller') {
//           sellers.add(user);
//         }
//       }
//     } catch (error) {
//       print(error);
//     }

//     return sellers;
//   }

//   Future<List<Shopper>> getShoppersData() async {
//     final _firestore_db = FirebaseFirestore.instance;
//     List<Shopper> shoppers = [];

//     try {
//       QuerySnapshot snapshotUsers =
//           await _firestore_db.collection('users').get();

//       for (var userdoc in snapshotUsers.docs) {
//         Map<String, dynamic> data = userdoc.data() as Map<String, dynamic>;

//         String datejoined = toMonth(data["dateJoined"]);

//         if (int.parse(datejoined) == month) {
//           newusers++;
//         }
//         existingusers++;

//         // print("${datejoined} : ${month} : ${newusers} : ${data['email']}");

//         final user = Shopper(
//           id: data['id'] ?? "",
//           firstname: data['firstName'] ?? "",
//           lastname: data['lastName'] ?? "",
//           email: data['email'] ?? "",
//           phone: data['phoneNumber'] ?? "No Phone Number",
//           role: data['role'] ?? "",
//           location: {
//             "street": data["street"]?.toString() ?? '',
//             "barangay": data["barangay"]?.toString() ?? '',
//             "city": data["city"]?.toString() ?? '',
//             "province": data["province"]?.toString() ?? '',
//             "region": data["region"]?.toString() ?? '',
//           },
//           datejoined: data["dateJoined"],
//         );

//         if (user.role.toLowerCase() == 'shopper') {
//           shoppers.add(user);
//         }
//       }
//     } catch (error) {
//       print(error);
//     }

//     return shoppers;
//   }

//   Future<List<Furniture>> getFurnituresData() async {
//     List<Furniture> furnitures = [];
//     // Map<String, Map<String, dynamic>> shopsInfo = {};

//     try {
//       QuerySnapshot snapshotFurnitures =
//           await _firestore_db.collection('furnitures').get();

//       // for (var shopDoc in snapshotShops.docs) {
//       //   Map<String, dynamic> data = shopDoc.data() as Map<String, dynamic>;

//       //   String sellerId = data['userId'] ?? "";
//       //   shopsInfo[sellerId] = {
//       //     'name': data['name'] ?? "",
//       //     'validId': data['validId'] ?? "",
//       //     'businessPermit': data['businessPermit'] ?? "",
//       //   };
//       // }

//       for (var furnituredoc in snapshotFurnitures.docs) {
//         Map<String, dynamic> data = furnituredoc.data() as Map<String, dynamic>;

//         furnitures.add(Furniture(
//           sellerid: data["ownerId"] ?? "",
//           name: data["name"] ?? "",
//           description: data["description"] ?? "",
//           price: data["price"] ?? 0,
//           stock: data["stock"] ?? 0,
//           category: data["category"] ?? "",
//           createdat: data["createdAt"],
//           depth: data["depth"] ?? 0,
//           width: data["width"] ?? 0,
//           discountedprice: data["discountedPrice"] ?? 0,
//           height: data["height"] ?? 0,
//           imageurl: data["imagesUrl"] ?? "",
//           imagepreviewfilename: data["imgPreviewFilename"] ?? "",
//           issale: data["isSale"],
//           modelurl: data["modelUrl"] ?? "",
//         ));
//       }
//     } catch (error) {
//       print(error);
//     }
//     return furnitures;
//   }

//   Future<List<OrderItem>> getOrdersData() async {
//     List<OrderItem> orders = [];
//     int totalprice = 0;

//     try {
//       QuerySnapshot snapshotOrders =
//           await _firestore_db.collection("orders").get();

//       for (var orderdoc in snapshotOrders.docs) {
//         Map<String, dynamic> data = orderdoc.data() as Map<String, dynamic>;
//         List<dynamic> orderItems = data["orderItems"];
//         int pricesubtotal = 0;
//         int quantitysubtotal = 0;

//         String ordersinmonth = toMonth(data['createdAt']);

//         if (int.parse(ordersinmonth) == month) {
//           for (var items in orderItems) {
//             int totalItemPrice = items["totalItemPrice"];
//             int quantity = items["quantity"];
//             pricesubtotal += totalItemPrice;
//             quantitysubtotal += quantity;
//           }
//         }

//         totalprice += pricesubtotal;
//         monthlyorders += quantitysubtotal;

//         orders.add(
//           OrderItem(
//               shopid: data["shopId"],
//               shopperid: data["shopperId"],
//               orderstatus: data["orderStatus"],
//               ordertotal: data["orderTotal"],
//               createdat: data["createdAt"] ?? '',
//               orderitems: data["orderItems"]),
//         );
//       }
//       revenue = (totalprice * 5) / 100;
//     } catch (error) {
//       print(error);
//     }

//     // MonthlyReport report = MonthlyReport(
//     //   id: "",
//     //   newusers: newusers,
//     //   currentusers: existingusers,
//     //   monthlyrevenue: revenue,
//     //   monthlyorders: monthlyorders,
//     //   month: month,
//     //   year: year,
//     // );

//     // print("New users: ${newusers}");
//     // print("Existing users: ${existingusers}");
//     // print("Revenue: ${revenue}");
//     // print("Orders: ${monthlyorders}");

//     return orders;
//   }

//   Future<void> getMonthlyReport() async {
//     try {
//       QuerySnapshot snapshotUsers =
//           await _firestore_db.collection('users').get();
//       QuerySnapshot snapshotShops =
//           await _firestore_db.collection('shops').get();
//       QuerySnapshot snapshotOrders =
//           await _firestore_db.collection("orders").get();

//       for (var users in snapshotUsers.docs) {}
//       for (var shops in snapshotShops.docs) {}
//       for (var orders in snapshotUsers.docs) {}
//       for (var users in snapshotUsers.docs) {}

//       // await _firestore_db.collection("reports").add({
//       //   "id": docRef.id,
//       //   "newUsers": newusers.toString(),
//       //   "currentUsers": existingusers.toString(),
//       //   "monthlyRevenue": revenue.toString(),
//       //   "monthlyOrders": monthlyorders.toString(),
//       //   "month": monthToText(month).toString(),
//       //   "year": year.toString(),
//       // });
//     } catch (error) {
//       print(error);
//     }
//   }

//   void signOut() async {
//     await FirebaseAuth.instance.signOut();
//   }
// }
