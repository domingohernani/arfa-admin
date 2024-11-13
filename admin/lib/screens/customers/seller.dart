import 'dart:async';

import 'package:admin/models/sellersData.dart';
import 'package:admin/screens/customers/viewStore.dart';
import 'package:admin/services/firestoreService.dart';
import 'package:admin/themes/theme.dart';
import 'package:admin/utilities/logoUrl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SellersView extends StatefulWidget {
  const SellersView({super.key});

  @override
  State<SellersView> createState() => _SellersViewState();
}

class _SellersViewState extends State<SellersView> {
  String? showValue;
  List<String> showItems = ['1', '2', '3', '4'];
  String? statusValue;
  List<String> statusItems = ['Default', 'Top Sellers'];

  final FirestoreService _fs = FirestoreService();
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Seller Shops",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Row(
                  children: [
                    Icon(Icons.add, size: 20, color: Colors.black),
                    SizedBox(width: 5),
                    Text("Add Shop", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: paddingView_horizontal,
                vertical: paddingView_vertical),
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
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: "Search seller by name or email...",
                          hintStyle:
                              TextStyle(fontSize: 13, color: Colors.black45),
                          prefixIcon: Icon(color: Colors.grey, Icons.search),
                        ),
                        style: const TextStyle(fontSize: 13),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 160,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Sort by:"),
                          DropdownButton<String>(
                            value: statusValue,
                            hint: const Text('Default'),
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(
                                color: Colors.black45, fontSize: 13),
                            onChanged: (String? newValue) {
                              setState(() {
                                statusValue = newValue;
                              });
                            },
                            items: statusItems
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Container(
                  width: double.infinity,
                  height: height - 251,
                  child: FutureBuilder<List<Seller>>(
                    future: _fs.getSellersData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("No sellers available"));
                      }

                      List<Seller> sellers = snapshot.data!
                          .where((seller) =>
                              seller.shopname
                                  .toLowerCase()
                                  .contains(searchQuery) ||
                              seller.email.toLowerCase().contains(searchQuery))
                          .toList();

                      // Apply sorting based on the selected dropdown option
                      if (statusValue == "Top Sellers") {
                        sellers.sort(
                            (a, b) => b.productSold.compareTo(a.productSold));
                      }

                      if (sellers.isEmpty) {
                        return Center(
                          child: Text(
                            "No sellers found for \"$searchQuery\"",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primary,
                            ),
                          ),
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 25,
                          mainAxisSpacing: 30,
                          childAspectRatio: 4 / 4,
                        ),
                        itemCount: sellers.length,
                        itemBuilder: (context, index) {
                          var seller = sellers[index];

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
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Container(
                                  height: 60,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
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
                                      backgroundColor: Colors.white,
                                      child: ClipOval(
                                        child: Image.network(
                                          seller.logo,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 110,
                                  child: Container(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Column(
                                      children: [
                                        Text(
                                          "${seller.shopname}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "ID: ${seller.id}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Email: ${seller.email}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await showDialog(
                                              context: context,
                                              builder: (context) {
                                                return ViewStoreProile(
                                                  id: seller.id,
                                                );
                                              },
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryBg,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 12),
                                          ),
                                          child: Text(
                                            "View Store",
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
