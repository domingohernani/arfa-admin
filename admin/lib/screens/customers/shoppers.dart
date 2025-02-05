import 'dart:async';
import 'dart:math';

import 'package:admin/models/sellersData.dart';
import 'package:admin/models/shoppersData.dart';
import 'package:admin/screens/customers/viewShopper.dart';
import 'package:admin/services/firestoreService.dart';
import 'package:admin/themes/theme.dart';
import 'package:admin/utilities/logoUrl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ShoppersView extends StatefulWidget {
  const ShoppersView({super.key});

  @override
  State<ShoppersView> createState() => _ShoppersViewState();
}

class _ShoppersViewState extends State<ShoppersView> {
  String? showValue;
  List<String> showItems = ['1', '2', '3', '4'];
  String? statusValue;
  List<String> statusItems = ['Default', 'Top Shoppers'];

  final FirestoreService _fs = FirestoreService();
  TextEditingController _searchController = TextEditingController();
  List<Shopper> _shoppers = [];
  List<Shopper> _filteredShoppers = [];

  @override
  void initState() {
    super.initState();
    _fetchShoppers();
    _searchController.addListener(_filterShoppers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchShoppers() async {
    var shoppers = await _fs.getShoppersData();
    setState(() {
      _shoppers = shoppers;
      _filteredShoppers = shoppers;
    });
  }

  void _filterShoppers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredShoppers = _shoppers.where((shopper) {
        final name = '${shopper.firstname} ${shopper.lastname}'.toLowerCase();
        final email = shopper.email.toLowerCase();
        return name.contains(query) || email.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width =
        MediaQuery.of(context).size.width - sidebarSize - paddingHorizontal;

    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.symmetric(
        vertical: paddingView_vertical,
        horizontal: paddingView_horizontal,
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Shoppers Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: paddingView_horizontal,
              vertical: paddingView_vertical,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 250,
                      height: 40,
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: "Search by name or email...",
                          hintStyle:
                              TextStyle(fontSize: 13, color: Colors.black45),
                          prefixIcon: Icon(color: Colors.grey, Icons.search),
                        ),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    const SizedBox(
                      width: 160,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // DropdownButton<String>(
                          //   value: showValue,
                          //   hint: const Text('Show'),
                          //   icon: const Icon(Icons.arrow_drop_down),
                          //   iconSize: 24,
                          //   elevation: 16,
                          //   style: const TextStyle(
                          //       color: Colors.black45, fontSize: 13),
                          //   onChanged: (String? newValue) {
                          //     setState(() {
                          //       showValue = newValue;
                          //     });
                          //   },
                          //   items: showItems
                          //       .map<DropdownMenuItem<String>>((String value) {
                          //     return DropdownMenuItem<String>(
                          //       value: value,
                          //       child: Text(value),
                          //     );
                          //   }).toList(),
                          // ),
                          // Text("Sort by:"),

                          // DropdownButton<String>(
                          //   value: statusValue,
                          //   hint: const Text('Default'),
                          //   icon: const Icon(Icons.arrow_drop_down),
                          //   iconSize: 24,
                          //   elevation: 16,
                          //   style: const TextStyle(
                          //       color: Colors.black45, fontSize: 13),
                          //   onChanged: (String? newValue) {
                          //     setState(() {
                          //       statusValue = newValue;
                          //     });
                          //   },
                          //   items: statusItems
                          //       .map<DropdownMenuItem<String>>((String value) {
                          //     return DropdownMenuItem<String>(
                          //       value: value,
                          //       child: Text(value),
                          //     );
                          //   }).toList(),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Container(
                  width: double.infinity,
                  height: height - 251,
                  child: _filteredShoppers.isEmpty
                      ? Center(
                          child: Text(
                            "No shoppers found for \"${_searchController.text}\"",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primary,
                            ),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 25,
                            mainAxisSpacing: 30,
                            childAspectRatio: 4 / 4,
                          ),
                          itemCount: _filteredShoppers.length,
                          itemBuilder: (context, index) {
                            var shopper = _filteredShoppers[index];
                            var userProfileUrl = shopper.profileurl;

                            String userProfile = "";
                            if (userProfileUrl.startsWith('https') &&
                                userProfileUrl.isNotEmpty) {
                              userProfile = userProfileUrl;
                            } else if (userProfileUrl.contains('/')) {
                              userProfile = getUserImageUrl(userProfileUrl);
                            } else {
                              userProfile = "";
                            }

                            return Container(
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: primary,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Container(
                                    height: 60,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 15,
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.white,
                                        child: ClipOval(
                                          child: userProfile.isNotEmpty
                                              ? Image.network(
                                                  userProfile,
                                                  fit: BoxFit.cover,
                                                )
                                              : Icon(
                                                  Icons.person,
                                                  size: 60,
                                                  color: Colors.green.shade300,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 110,
                                    child: Container(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Column(
                                        children: [
                                          Text(
                                            (shopper.firstname.isEmpty &&
                                                    shopper.lastname.isEmpty)
                                                ? "No Name"
                                                : "${shopper.firstname} ${shopper.lastname}",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "Phone: ${shopper.phone}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "Email: ${shopper.email}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          ElevatedButton(
                                            onPressed: () async {
                                              await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return ViewShopperProfile(
                                                      id: shopper.id);
                                                },
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: primaryBg,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 24,
                                                vertical: 12,
                                              ),
                                            ),
                                            child: const Text(
                                              "View Profile",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddSellerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Add New Seller",
                style: TextStyle(
                  fontSize: 18,
                  color: primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: <Widget>[
                Container(
                  width: 400,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 90,
                            width: 90,
                            child: const CircleAvatar(
                              backgroundColor: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 25),
                          OutlinedButton(
                            onPressed: () {},
                            child: const Row(
                              children: [
                                Icon(Icons.add_a_photo_rounded),
                                SizedBox(width: 10),
                                Text(
                                  "Upload",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 170,
                            child: const TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Firstname"),
                              ),
                            ),
                          ),
                          Container(
                            width: 170,
                            child: const TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Lastname"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 170,
                            child: const TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Email"),
                              ),
                            ),
                          ),
                          Container(
                            width: 170,
                            child: const TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Phone"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            "ADD",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: 250,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), // Rounded corners
          border: Border.all(
            color: Colors.green, // Outline border color
            width: 2, // Border thickness
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.green.withOpacity(0.1),
              child: const Icon(
                Icons.add, // Add icon
                size: 40,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Add Seller",
              style: TextStyle(
                color: Colors.green,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
