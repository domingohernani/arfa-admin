import 'dart:async';

import 'package:admin/dataInitialization.dart';
import 'package:admin/models/adminData.dart';
import 'package:admin/models/furnituresData.dart';
import 'package:admin/models/monthlyData.dart';
import 'package:admin/models/ordersData.dart';
import 'package:admin/models/productData.dart';
import 'package:admin/models/reviewsData.dart';
import 'package:admin/models/sellersData.dart';
import 'package:admin/models/shoppersData.dart';
import 'package:admin/models/shopsData.dart';
import 'package:admin/models/singleShopData.dart';
import 'package:admin/models/singleUser.dart';
import 'package:admin/models/topProductsData.dart';
import 'package:admin/utilities/dateconvertion.dart';
import 'package:admin/utilities/logoUrl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

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

  Future<List<Shopper>> getUsersDataForCurrentMonth() async {
    final _firestore_db = FirebaseFirestore.instance;
    List<Shopper> shoppers = [];

    try {
      // Get the first and last date of the current month
      DateTime now = DateTime.now();
      DateTime startOfMonth = DateTime(now.year, now.month, 1);
      DateTime endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      QuerySnapshot snapshotUsers = await _firestore_db
          .collection('users')
          .where('dateJoined',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('dateJoined',
              isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
          .get();

      for (var userdoc in snapshotUsers.docs) {
        Map<String, dynamic> data = userdoc.data() as Map<String, dynamic>;

        final shopper = Shopper(
          id: data['id'] ?? "",
          firstname: data['firstName'] ?? "",
          lastname: data['lastName'] ?? "",
          email: data['email'] ?? "",
          phone: data['phone'] ?? "",
          role: data['role'] ?? "",
          location: {
            "street": data["street"]?.toString() ?? '',
            "barangay": data["barangay"]?.toString() ?? '',
            "city": data["city"]?.toString() ?? '',
            "province": data["province"]?.toString() ?? '',
            "region": data["region"]?.toString() ?? '',
          },
          profileurl: data['profileUrl'] ?? '',
          datejoined: data['dateJoined'],
        );

        shoppers.add(shopper);
      }
    } catch (error) {
      print(error);
    }

    return shoppers;
  }

  Future<List<Seller>> getSellersData() async {
    final _firestore_db = FirebaseFirestore.instance;
    List<Seller> sellers = [];
    Map<String, Map<String, dynamic>> shopsInfo = {};
    Map<String, Map<String, dynamic>> shopOrder = {};
    List shopId = [];
    int prodSold = 0;

    try {
      QuerySnapshot snapshotUsers =
          await _firestore_db.collection('users').get();
      QuerySnapshot snapshotShops =
          await _firestore_db.collection('shops').get();

      for (var shopDoc in snapshotShops.docs) {
        Map<String, dynamic> data = shopDoc.data() as Map<String, dynamic>;

        String sellerId = data['userId'] ?? "";
        shopId.add(data['userId']);

        // print("Name: ${data['name']} , logo:${getLogoUrl(data['logo'])}");

        shopsInfo[sellerId] = {
          'name': data['name'] ?? "",
          'validId': data['validId'] ?? "",
          'businessPermit': data['businessPermit'] ?? "",
          'logo': getLogoUrl(data['logo']) ?? "",
        };
      }

      for (var userdoc in snapshotUsers.docs) {
        Map<String, dynamic> data = userdoc.data() as Map<String, dynamic>;
        Map<String, dynamic>? shopData = shopsInfo[data['id']];

        QuerySnapshot snapshotOrders = await _firestore_db
            .collection("orders")
            .where('shopId', isEqualTo: data['id'])
            .get();

        for (var orders in snapshotOrders.docs) {
          Map<String, dynamic> data = orders.data() as Map<String, dynamic>;

          List<dynamic> orderItems = data["orderItems"];

          int quantitysubtotal = 0;

          for (var items in orderItems) {
            int quantity = items["quantity"];

            quantitysubtotal += quantity;
          }

          prodSold += quantitysubtotal;
        }

        final user = Seller(
          id: data['id'] ?? "",
          firstname: data['firstName'] ?? "",
          lastname: data['lastName'] ?? "",
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
          logo: shopData?['logo'] ?? "",
          productSold: prodSold ?? 0,
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

        // String datejoined = toMonth(data["dateJoined"]);

        // if (int.parse(datejoined) == month) {
        //   newusers++;
        // }
        // existingusers++;

        // print("${datejoined} : ${month} : ${newusers} : ${data['email']}");

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
          profileurl: data["profileUrl"] ?? "",
          datejoined: data["dateJoined"],
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

  Future<List<Furniture>> getFurnituresData() async {
    List<Furniture> furnitures = [];

    try {
      QuerySnapshot snapshotFurnitures =
          await _firestore_db.collection('furnitures').get();

      for (var furnituredoc in snapshotFurnitures.docs) {
        Map<String, dynamic> data = furnituredoc.data() as Map<String, dynamic>;
        List<Review> review = [];
        List<Stock> stockwithvariant = [];

        QuerySnapshot snapshotReviews = await _firestore_db
            .collection("furnitures")
            .doc(data['id'])
            .collection("reviews")
            .get();

        for (var reviewdoc in snapshotReviews.docs) {
          Map<String, dynamic> data =
              furnituredoc.data() as Map<String, dynamic>;

          review.add(
            Review(
              shopperid: "shopperid",
              description: "description",
              rating: 0,
              title: "title",
              date: DateTime.now(),
            ),
          );
        }

        furnitures.add(Furniture(
          productid: data['id'] ?? "",
          sellerid: data["ownerId"] ?? "",
          name: data["name"] ?? "",
          description: data["description"] ?? "",
          price: data["price"] ?? 0,
          stock: data["stock"] ?? 0,
          category: data["category"] ?? "",
          createdat: data["createdAt"],
          depth: data["depth"] ?? 0,
          width: data["width"] ?? 0,
          discountedprice: data["discountedPrice"] ?? 0,
          height: data["height"] ?? 0,
          imageurl: data["imagesUrl"] ?? "",
          imagepreviewfilename: data["imgPreviewFilename"] ?? "",
          issale: data["isSale"],
          modelurl: data["modelUrl"] ?? "",
          review: review ?? [],
          stockwithvariant: stockwithvariant ?? [],
        ));
      }
    } catch (error) {
      print(error);
    }
    return furnitures;
  }

  Future<Furniture?> getSingleFurnituresData(String prodid) async {
    Furniture? furniture;
    List<Review> review = [];
    List<Stock> stockwithvariant = [];

    try {
      QuerySnapshot snapshotFurnitures = await _firestore_db
          .collection('furnitures')
          .where("id", isEqualTo: prodid)
          .get();

      for (var furnituredoc in snapshotFurnitures.docs) {
        Map<String, dynamic> data = furnituredoc.data() as Map<String, dynamic>;

        QuerySnapshot snapshotReviews = await _firestore_db
            .collection("furnitures")
            .doc(data['id'])
            .collection("reviews")
            .get();

        for (var reviewdoc in snapshotReviews.docs) {
          Map<String, dynamic> reviewdata =
              reviewdoc.data() as Map<String, dynamic>;

          String userref = reviewdata['user'].toString();
          String tempid = userref.split('/')[1];
          String id = tempid.substring(0, tempid.length - 1);

          review.add(
            Review(
              shopperid: id ?? "",
              description: reviewdata['description'],
              rating: 0,
              title: reviewdata['title'],
              date: reviewdata['date'].toDate(),
            ),
          );
        }

        QuerySnapshot snapshotStocks = await _firestore_db
            .collection("furnitures")
            .doc(data['id'])
            .collection("stocks")
            .orderBy("updatedAt", descending: true) // Sort by last updated
            .limit(1) // Get only the most recent document
            .get();

        for (var stocksdoc in snapshotStocks.docs) {
          Map<String, dynamic> stocksdata =
              stocksdoc.data() as Map<String, dynamic>;

          stockwithvariant.add(
            Stock(
                id: data['id'] ?? "",
                variant: stocksdata['variant'] ?? "",
                previousQuantity: stocksdata['oldQuantity'] ?? 0,
                addedQuantity: stocksdata['quantityAdded'] ?? 0,
                latestQuantity: stocksdata['newQuantity'] ?? 0,
                updatedAt: stocksdata['updatedAt'] ??
                    Timestamp.fromDate(DateTime(1970, 1, 1))),
          );
        }

        furniture = Furniture(
          productid: data['id'] ?? "",
          sellerid: data["ownerId"] ?? "",
          name: data["name"] ?? "",
          description: data["description"] ?? "",
          price: data["price"] ?? 0,
          stock: data["stock"] ?? 0,
          category: data["category"] ?? "",
          createdat: data["createdAt"],
          depth: data["depth"] ?? 0,
          width: data["width"] ?? 0,
          discountedprice: data["discountedPrice"] ?? 0,
          height: data["height"] ?? 0,
          imageurl: getProductImageUrl(
                  data['imagesUrl'], data['imgPreviewFilename']) ??
              "",
          imagepreviewfilename: data["imgPreviewFilename"] ?? "",
          issale: data["isSale"],
          modelurl: data["modelUrl"] ?? "",
          review: review ?? [],
          stockwithvariant: stockwithvariant ?? [],
        );
      }
    } catch (error) {
      print(error);
    }
    return furniture;
  }

  Future<List<Shop>> getShopData() async {
    List<Shop> shop = [];
    int count = 0;

    try {
      QuerySnapshot snapshotShops =
          await _firestore_db.collection("shops").get();
      QuerySnapshot snapshotOrders =
          await _firestore_db.collection("orders").get();

      for (var shopdoc in snapshotShops.docs) {
        Map<String, dynamic> shopdata = shopdoc.data() as Map<String, dynamic>;

        double revenue = 0;
        int totalproductsold = 0;

        String shopname = shopdata['name'];
        String shopid = shopdata['userId'];

        for (var orderdoc in snapshotOrders.docs) {
          Map<String, dynamic> orderdata =
              orderdoc.data() as Map<String, dynamic>;
          List<dynamic> orderItems = orderdata["orderItems"];

          int totalproductprice = 0;

          if (shopdata['userId'] == orderdata['shopId'] &&
              orderdata['orderStatus'] == "Delivered") {
            int priceSubtotal = 0;

            for (var item in orderItems) {
              int totalItemPrice = item['totalItemPrice'];
              int quantity = item['quantity'];
              totalproductsold += quantity;
              priceSubtotal += totalItemPrice;
            }
            totalproductprice += priceSubtotal;
          }
          revenue += totalproductprice * 0.05;
        }

        String revenueFormat = revenue.toStringAsFixed(2);
        revenue = double.parse(revenueFormat);

        shop.add(Shop(
            shopid: shopid,
            shopname: shopname,
            revenue: revenue,
            orders: totalproductsold));
      }

      // Sort the shops based on quantity sold (in descending order)
      shop.sort((a, b) => b.orders.compareTo(a.orders));
    } catch (error) {
      print(error);
    }

    return shop;
  }

  Future<List<Shop>> getShopDataForCurrentMonth() async {
    List<Shop> shop = [];
    int count = 0;

    try {
      // Get the current date and calculate the start and end of the current month
      DateTime now = DateTime.now();
      DateTime startOfMonth = DateTime(now.year, now.month, 1);
      DateTime startOfNextMonth = DateTime(now.year, now.month + 1, 1);

      // Firestore query to filter orders within the current month
      QuerySnapshot snapshotShops =
          await _firestore_db.collection("shops").get();
      QuerySnapshot snapshotOrders = await _firestore_db
          .collection("orders")
          .where("createdAt", isGreaterThanOrEqualTo: startOfMonth)
          .where("createdAt", isLessThan: startOfNextMonth)
          .get();

      for (var shopdoc in snapshotShops.docs) {
        Map<String, dynamic> shopdata = shopdoc.data() as Map<String, dynamic>;

        double revenue = 0;
        int totalproductsold = 0;

        String shopname = shopdata['name'];
        String shopid = shopdata['userId'];

        for (var orderdoc in snapshotOrders.docs) {
          Map<String, dynamic> orderdata =
              orderdoc.data() as Map<String, dynamic>;
          List<dynamic> orderItems = orderdata["orderItems"];

          int totalproductprice = 0;

          if (shopdata['userId'] == orderdata['shopId'] &&
              (orderdata['orderStatus'] == "Delivered" ||
                  orderdata["orderStatus"] == "Picked-up")) {
            int priceSubtotal = 0;

            for (var item in orderItems) {
              int totalItemPrice = item['totalItemPrice'];
              int quantity = item['quantity'];
              totalproductsold += quantity;
              priceSubtotal += totalItemPrice;
            }
            totalproductprice += priceSubtotal;
          }
          revenue += totalproductprice * 0.05;
        }

        String revenueFormat = revenue.toStringAsFixed(2);
        revenue = double.parse(revenueFormat);

        shop.add(Shop(
            shopid: shopid,
            shopname: shopname,
            revenue: revenue,
            orders: totalproductsold));
      }

      // Sort the shops based on quantity sold (in descending order)
      shop.sort((a, b) => b.orders.compareTo(a.orders));
    } catch (error) {
      print(error);
    }

    return shop;
  }

  Future<List<OrderItem>> getOrdersData() async {
    List<OrderItem> orders = [];
    try {
      // Get the current date and extract year and month
      DateTime now = DateTime.now();
      int currentYear = now.year;
      int currentMonth = now.month;

      QuerySnapshot snapshotOrders =
          await _firestore_db.collection("orders").get();

      for (var orderdoc in snapshotOrders.docs) {
        Map<String, dynamic> data = orderdoc.data() as Map<String, dynamic>;
        Timestamp createdAtTimestamp = data["createdAt"];
        DateTime createdAt = createdAtTimestamp.toDate();

        // Check if the order's createdAt year and month match the current year and month
        if (createdAt.year == currentYear && createdAt.month == currentMonth) {
          orders.add(
            OrderItem(
              shopid: data["shopId"] ?? '',
              shopperid: data["shopperId"] ?? '',
              orderstatus: data["orderStatus"] ?? '',
              ordertotal: data["orderTotal"] ?? 0,
              createdat: createdAtTimestamp,
              orderitems: data["orderItems"] ?? [],
              devicetype: data["deviceType"] ?? "",
            ),
          );
        }
      }
    } catch (error) {
      print("Error fetching order data: $error");
    }
    return orders;
  }

  Future<SingleShop?> getSingleStoreData(String shopid) async {
    // Default values
    String id = "";
    String firstname = "";
    String lastname = "";
    String email = "";
    String phone = "";
    String shopname = "";
    String shoppermit = "";
    String shopvalidid = "";
    String logo = "";
    Map<String, String> payout = {};
    Map<String, String> address = {};
    List<Furniture> furnitures = [];

    Timestamp datejoined = Timestamp.fromDate(DateTime(1970, 1, 1));

    String description = "";
    int price = 0;
    int stock = 0;
    String category = "";
    int depth = 0;
    int width = 0;
    int discountedprice = 0;
    int height = 0;
    String imageurl = "";
    String imagepreviewfilename = "";
    bool issale = false;
    String modelurl = "";

    String shopperid = "";
    String orderstatus = "";
    int ordertotal = 0;
    List<dynamic> orderitems = [];

    try {
      QuerySnapshot snapshotShop = await _firestore_db
          .collection('shops')
          .where('userId', isEqualTo: shopid)
          .get();
      for (var shopdoc in snapshotShop.docs) {
        Map<String, dynamic> data = shopdoc.data() as Map<String, dynamic>;
        id = data['userId'] ?? "";
        shopname = data['name'] ?? "";
        logo = getLogoUrl(data['logo']) ?? "";
        shopvalidid = data['validId'] ?? "";
        shoppermit = data['businessPermit'] ?? "";
        payout = {
          "gcashname": data['payout']['gcashName'] ?? "",
          "gcashnumber": data['payout']['gcashNumber'] ?? "",
          "method": data['payout']['method'] ?? "",
          "paypalname": data['payout']['paypalName'] ?? "",
          "paypalemail": data['payout']['paypalEmail'] ?? "",
        };
        address = {
          "street": data['address']["street"].toString() ?? '',
          "barangay": data['address']["barangay"] ?? '',
          "city": data['address']["city"] ?? '',
          "province": data['address']["province"] ?? '',
          "region": data['address']["region"] ?? '',
        };
        print("Payout: ${data['payout']['method']}");
      }

      // print("Data: ${shopname}");
      // print("Data: ${logo}");
      // print("Data: ${shopvalidid}");
      // print("Data: ${shoppermit}");
      // print("Data: ${address['city']}");

      QuerySnapshot snapshotSeller = await _firestore_db
          .collection('users')
          .where('id', isEqualTo: shopid)
          .get();
      for (var sellerdoc in snapshotSeller.docs) {
        Map<String, dynamic> data = sellerdoc.data() as Map<String, dynamic>;

        firstname = data['firstName'] ?? "";
        lastname = data['lastName'] ?? "";
        email = data['email'] ?? "";
        phone = data['phoneNumber'] ?? "";
      }
      // print("Data: ${firstname}");
      // print("Data: ${lastname}");
      // print("Data: ${email}");
      // print("Data: ${phone}");

      QuerySnapshot snapshotFurnitures = await _firestore_db
          .collection('furnitures')
          .where('ownerId', isEqualTo: shopid)
          .get();
      for (var furnituredoc in snapshotFurnitures.docs) {
        Map<String, dynamic> data = furnituredoc.data() as Map<String, dynamic>;

        List<Review> review = [];
        List<Stock> stockwithvariant = [];

        QuerySnapshot snapshotReviews = await _firestore_db
            .collection("furnitures")
            .doc(data['id'])
            .collection("reviews")
            .get();

        for (var reviewdoc in snapshotReviews.docs) {
          Map<String, dynamic> data =
              furnituredoc.data() as Map<String, dynamic>;

          review.add(
            Review(
              shopperid: "shopperid",
              description: "description",
              rating: 0,
              title: "title",
              date: DateTime.now(),
            ),
          );
        }

        furnitures.add(
          Furniture(
            productid: data['id'] ?? "",
            sellerid: data['ownerId'] ?? "",
            name: data['name'] ?? "",
            description: data['description'] ?? "",
            price: data['price'] ?? 0,
            stock: data['stocks'] ?? 0,
            category: data['category'] ?? "",
            createdat:
                data['createdAt'] ?? Timestamp.fromDate(DateTime(1970, 1, 1)),
            depth: data['depth'] ?? 0,
            width: data['width'] ?? 0,
            discountedprice: data['discountedprice'] ?? 0,
            height: data['height'] ?? 0,
            imageurl: getProductImageUrl(
                    data['imagesUrl'], data['imgPreviewFilename']) ??
                "",
            imagepreviewfilename: data['imgPreviewFilename'] ?? "",
            issale: data['isSale'] ?? false,
            modelurl: data['modelUrl'] ?? "",
            review: review,
            stockwithvariant: stockwithvariant,
          ),
        );
      }
      // print("Furni: ${furnitures.length}");
    } catch (error) {
      print("Error fetching data: $error");
      return null;
    }

    SingleShop sh = SingleShop(
      id: id,
      firstname: firstname,
      lastname: lastname,
      email: email,
      phone: phone,
      address: address,
      payout: payout,
      shopname: shopname,
      shoppermit: shoppermit,
      shopvalidid: shopvalidid,
      logo: logo,
      furniture: furnitures,

      description: description,
      price: price,
      stock: stock,
      category: category,
      createdatFurniture:
          Timestamp.fromDate(DateTime(1970, 1, 1)), // Default date
      depth: depth,
      width: width,
      discountedprice: discountedprice,
      height: height,
      imageurl: imageurl,
      imagepreviewfilename: imagepreviewfilename,
      issale: issale,
      modelurl: modelurl,
      shopperid: shopperid,
      orderstatus: orderstatus,
      ordertotal: ordertotal,
      createdatOrder: Timestamp.fromDate(DateTime(1970, 1, 1)), // Default date
      orderitems: orderitems,
    );

    return sh;
  }

  Future<SingleUser?> getSingleUserData(String userid) async {
    String id = "";
    String firstname = "";
    String lastname = "";
    String email = "";
    String phone = "";
    String profileurl = "";
    Map<String, String> address = {};
    Timestamp datejoined = Timestamp.fromDate(DateTime(1970, 1, 1));
    List<Furniture> wishlists = [];
    List<Furniture> cartitems = [];

    print("============");

    try {
      List<dynamic> wishlistsId = [];
      List<String> cartitemsId = [];

      QuerySnapshot snapshotSeller = await _firestore_db
          .collection('users')
          .where('id', isEqualTo: userid)
          .get();
      for (var sellerdoc in snapshotSeller.docs) {
        Map<String, dynamic> data = sellerdoc.data() as Map<String, dynamic>;

        id = data['id'] ?? "";
        firstname = data['firstName'] ?? "";
        lastname = data['lastName'] ?? "";
        email = data['email'] ?? "";
        phone = data['phoneNumber'] ?? "";
        profileurl = data['profileUrl'] ?? "";
        address = {
          "street": data['location']["street"] ?? '',
          "barangay": data['location']["barangay"] ?? '',
          "city": data['location']["city"] ?? '',
          "province": data['location']["province"] ?? '',
          "region": data['location']["region"] ?? '',
        };
        datejoined = data['dateJoined'] ?? datejoined;
        wishlistsId = data['wishlist'] ?? [];
        for (var items in data['cart']) {
          cartitemsId.add(items['furnitureId']);
        }
      }

      for (var id in wishlistsId) {
        QuerySnapshot snapshotFurnitureWL = await _firestore_db
            .collection('furnitures')
            .where('id', isEqualTo: id)
            .get();

        for (var furnituredoc in snapshotFurnitureWL.docs) {
          Map<String, dynamic> data =
              furnituredoc.data() as Map<String, dynamic>;

          List<Review> review = [];
          List<Stock> stockwithvariant = [];

          QuerySnapshot snapshotReviews = await _firestore_db
              .collection("furnitures")
              .doc(data['id'])
              .collection("reviews")
              .get();

          for (var reviewdoc in snapshotReviews.docs) {
            Map<String, dynamic> data =
                furnituredoc.data() as Map<String, dynamic>;

            review.add(
              Review(
                shopperid: "shopperid",
                description: "description",
                rating: 0,
                title: "title",
                date: DateTime.now(),
              ),
            );
          }

          wishlists.add(
            Furniture(
              productid: data['id'] ?? "",
              sellerid: data["ownerId"] ?? "",
              name: data["name"] ?? "",
              description: data["description"] ?? "",
              price: data["price"] ?? 0,
              stock: data["stock"] ?? 0,
              category: data["category"] ?? "",
              createdat: data["createdAt"],
              depth: data["depth"] ?? 0,
              width: data["width"] ?? 0,
              discountedprice: data["discountedPrice"] ?? 0,
              height: data["height"] ?? 0,
              imageurl: getProductImageUrl(
                      data["imagesUrl"], data["imgPreviewFilename"]) ??
                  "",
              imagepreviewfilename: data["imgPreviewFilename"] ?? "",
              issale: data["isSale"],
              modelurl: data["modelUrl"] ?? "",
              review: review,
              stockwithvariant: stockwithvariant,
            ),
          );
        }
      }

      for (var id in cartitemsId) {
        QuerySnapshot snapshotFurnitureWL = await _firestore_db
            .collection('furnitures')
            .where('id', isEqualTo: id)
            .get();

        for (var furnituredoc in snapshotFurnitureWL.docs) {
          Map<String, dynamic> data =
              furnituredoc.data() as Map<String, dynamic>;

          // print("Cartss: ${data}");
          List<Review> review = [];
          List<Stock> stockwithvariant = [];

          QuerySnapshot snapshotReviews = await _firestore_db
              .collection("furnitures")
              .doc(data['id'])
              .collection("reviews")
              .get();

          for (var reviewdoc in snapshotReviews.docs) {
            Map<String, dynamic> data =
                furnituredoc.data() as Map<String, dynamic>;

            review.add(
              Review(
                shopperid: "shopperid",
                description: "description",
                rating: 0,
                title: "title",
                date: DateTime.now(),
              ),
            );
          }

          cartitems.add(
            Furniture(
              productid: data['id'] ?? "",
              sellerid: data["ownerId"] ?? "",
              name: data["name"] ?? "",
              description: data["description"] ?? "",
              price: data["price"] ?? 0,
              stock: data["stock"] ?? 0,
              category: data["category"] ?? "",
              createdat: data["createdAt"],
              depth: data["depth"] ?? 0,
              width: data["width"] ?? 0,
              discountedprice: data["discountedPrice"] ?? 0,
              height: data["height"] ?? 0,
              imageurl: getProductImageUrl(
                      data["imagesUrl"], data["imgPreviewFilename"]) ??
                  "",
              imagepreviewfilename: data["imgPreviewFilename"] ?? "",
              issale: data["isSale"],
              modelurl: data["modelUrl"] ?? "",
              review: review,
              stockwithvariant: stockwithvariant,
            ),
          );
        }
      }

      // print("Data: ${id}");
      // print("Data: ${firstname}");
      // print("Data: ${lastname}");
      // print("Data: ${email}");
      // print("Data: ${phone}");
      // print("Data: ${datejoined}");

      // print("Data: ${address.toString()}");
    } catch (error) {
      print(error);
    }

    SingleUser userData = SingleUser(
      id: id,
      firstname: firstname,
      lastname: lastname,
      email: email,
      phone: phone,
      profileUrl: profileurl,
      address: address,
      datejoined: datejoined,
      wishlists: wishlists,
      cartitems: cartitems,
    );

    return userData;
  }

  Future<MonthlyReport> getMonthlyReport() async {
    int currentMonth = DateTime.now().month;
    int year = DateTime.now().year;

    int newUsers = 0;
    int existingUsers = 0;
    double revenue = 0;
    int monthlyOrders = 0;

    int totalPrice = 0;

    try {
      // Fetch data from Firestore
      QuerySnapshot snapshotUsers =
          await _firestore_db.collection('users').get();
      QuerySnapshot snapshotOrders =
          await _firestore_db.collection("orders").get();

      // Count new and existing users
      for (var userDoc in snapshotUsers.docs) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Ensure `dateJoined` is a valid field and parse it correctly
        DateTime dateJoined = (userData['dateJoined'] as Timestamp).toDate();

        if (dateJoined.month == currentMonth && dateJoined.year == year) {
          newUsers++;
        }
        existingUsers++;
      }

      // Calculate revenue and order statistics
      for (var orderDoc in snapshotOrders.docs) {
        Map<String, dynamic> orderData =
            orderDoc.data() as Map<String, dynamic>;

        // Ensure `createdAt` is a valid field and parse it correctly
        DateTime createdAt = (orderData['createdAt'] as Timestamp).toDate();

        if (createdAt.month == currentMonth && createdAt.year == year) {
          if (orderData["orderStatus"] == "Delivered" ||
              orderData["orderStatus"] == "Picked-up") {
            List<dynamic> orderItems = orderData["orderItems"];
            int priceSubtotal = 0;
            int quantitySubtotal = 0;

            for (var item in orderItems) {
              int totalItemPrice = item["totalItemPrice"];
              int quantity = item["quantity"];

              priceSubtotal += totalItemPrice;
              quantitySubtotal += quantity;
            }

            totalPrice += priceSubtotal;
            monthlyOrders += quantitySubtotal;
          }
        }
      }

      // Calculate revenue as 5% of the total price
      revenue = totalPrice * 0.05;
    } catch (error) {
      print("Error fetching monthly report data: $error");
    }

    // Create the MonthlyReport instance
    MonthlyReport report = MonthlyReport(
      id: "", // Provide a meaningful ID if required
      newusers: newUsers,
      currentusers: existingUsers,
      monthlyrevenue: revenue,
      monthlyorders: monthlyOrders,
      month: monthToText(currentMonth),
      year: year,
    );

    return report;
  }

  Future<List<MonthlyReport>> getListOfReport() async {
    List<MonthlyReport> monthlyreport = [];

    try {
      QuerySnapshot snapshotReports =
          await _firestore_db.collection('reports').get();

      for (var snapshotdoc in snapshotReports.docs) {
        Map<String, dynamic> data = snapshotdoc.data() as Map<String, dynamic>;

        monthlyreport.add(MonthlyReport(
            id: data['id'] ?? "",
            newusers: data['newUsers'] ?? "",
            currentusers: data['currentUsers'] ?? "",
            monthlyrevenue: data['monthlyRevenue'] ?? "",
            monthlyorders: data['monthlyOrders'] ?? "",
            month: data['month'] ?? "",
            year: data['year'] ?? ""));
      }
    } catch (error) {
      print(error);
    }

    return monthlyreport;
  }

  Future<List<TopProduct>> getTopProducts() async {
    List<TopProduct> topProducts = [];
    try {
      QuerySnapshot snapshotFurnitures =
          await _firestore_db.collection("furnitures").get();
      QuerySnapshot snapshotOrders =
          await _firestore_db.collection("orders").get();

      for (var furnituredoc in snapshotFurnitures.docs) {
        Map<String, dynamic> data = furnituredoc.data() as Map<String, dynamic>;
        int totalproductsold = 0;

        for (var orderdoc in snapshotOrders.docs) {
          Map<String, dynamic> orderData =
              orderdoc.data() as Map<String, dynamic>;
          List<dynamic> orderItems = orderData["orderItems"];

          for (var item in orderItems) {
            if (data['id'] == item['id']) {
              int quantity = (item['quantity'] as num).toInt();
              totalproductsold += quantity;
            }
          }
        }

        if (totalproductsold > 0) {
          topProducts.add(
            TopProduct(
              id: data['id'] ?? "",
              name: data['name'] ?? "",
              category: data['category'] ?? "",
              solds: totalproductsold,
              price: (data['price'] as num).toDouble(),
              image: getProductImageUrl(
                      data["imagesUrl"], data["imgPreviewFilename"]) ??
                  "",
            ),
          );
        }
      }

      // Sort by solds in descending order
      topProducts.sort((a, b) => b.solds.compareTo(a.solds));
    } catch (ex) {
      print(ex);
    }
    return topProducts;
  }

  Future<Map<String, int>> getDeviceTypeDistribution() async {
    Map<String, int> deviceTypeCounts = {
      "Desktop": 0,
      "Mobile": 0,
      "Tablet": 0,
    };

    try {
      QuerySnapshot snapshotOrders =
          await _firestore_db.collection("orders").get();

      for (var orderdoc in snapshotOrders.docs) {
        Map<String, dynamic> data = orderdoc.data() as Map<String, dynamic>;
        String deviceType = data["deviceType"] ?? "";

        if (deviceTypeCounts.containsKey(deviceType)) {
          deviceTypeCounts[deviceType] = deviceTypeCounts[deviceType]! + 1;
        }
      }
    } catch (error) {
      print(error);
    }

    return deviceTypeCounts;
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
