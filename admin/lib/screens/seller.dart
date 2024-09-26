import 'package:admin/constants/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<String> statusItems = ['Show All', 'Option 2', 'Option 3', 'Option 4'];

  // void fetchData() async {
  //   try {
  //     var document = await FirebaseFirestore.instance.collection("users").where("role", isEqualTo: "seller").snapshots()
  //   } catch (ex) {
  //     print("Error: ${ex}");
  //   }
  // }

  @override
  void dispose() {
    // Clean up listeners if any
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width =
        MediaQuery.of(context).size.width - sidebarSize - paddingHorizontal;

    return SizedBox(
      height: height,
      width: width,
      child: SingleChildScrollView(
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
              width: width,
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
                          decoration: const InputDecoration(
                            hintText: "Search seller...",
                            hintStyle:
                                TextStyle(fontSize: 13, color: Colors.black45),
                            prefixIcon: Icon(color: Colors.grey, Icons.search),
                          ),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      SizedBox(
                        width: 160,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton<String>(
                              value: showValue,
                              hint: const Text('Show'),
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(
                                  color: Colors.black45, fontSize: 13),
                              onChanged: (String? newValue) {
                                setState(() {
                                  showValue = newValue;
                                });
                              },
                              items: showItems.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            DropdownButton<String>(
                              value: statusValue,
                              hint: const Text('Status'),
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
                              items: statusItems.map<DropdownMenuItem<String>>(
                                  (String value) {
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
                  // StreamBuilder<QuerySnapshot>(
                  //   stream: FirebaseFirestore.instance
                  //       .collection("users")
                  //       .where("role", isEqualTo: "seller")
                  //       .snapshots(),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return Center(child: CircularProgressIndicator());
                  //     }

                  //     if (snapshot.hasError) {
                  //       return Center(child: Text("Error: ${snapshot.error}"));
                  //     }

                  //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  //       return Center(child: Text("No sellers available"));
                  //     }

                  //     final sellers = snapshot.data!.docs;

                  //     return ListView.builder(
                  //       shrinkWrap: true,
                  //       physics:
                  //           NeverScrollableScrollPhysics(), // Prevent internal scrolling
                  //       itemCount: sellers.length,
                  //       itemBuilder: (context, index) {
                  //         var sellerData = sellers[index];
                  //         return ListTile(
                  //           title: Text(
                  //               '${sellerData['email']}'), // Adjust according to your fields
                  //         );
                  //       },
                  //     );
                  //   },
                  // ),
                  // const Divider(),
                  Container(
                    height: height * 0.9,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 25,
                        mainAxisSpacing: 30,
                        childAspectRatio: 3.5 / 4,
                      ),
                      itemCount: 20, // +1 for the AddSellerCard
                      itemBuilder: (context, index) {
                        // if (index == shops.length) {
                        //   return AddSellerCard(); // Display the add seller card
                        // }
                        // var shop = shops[index];
                        return Container(
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
                            color:
                                Colors.white, // Background color for the card
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Colors.grey.withOpacity(0.2), // Soft shadow
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3), // Shadow position
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Top Green Section with logo
                              Container(
                                height: 70,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white,
                                    // child: Image.asset(
                                    //   'assets/logo.png', // Your logo image
                                    //   fit: BoxFit.contain,
                                    // ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "arfa", // Assuming 'name' field exists
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Seller ID: ", // Document ID
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "ry@g.com", // Assuming 'email' field exists
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryBg,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20), // Rounded button
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
                            child: CircleAvatar(
                              backgroundColor: Colors.green,
                            ),
                          ),
                          SizedBox(width: 25),
                          OutlinedButton(
                            onPressed: () {},
                            child: Row(
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
                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 170,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Firstname"),
                              ),
                            ),
                          ),
                          Container(
                            width: 170,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Lastname"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 170,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Email"),
                              ),
                            ),
                          ),
                          Container(
                            width: 170,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Phone"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(
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
              child: Icon(
                Icons.add, // Add icon
                size: 40,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 10),
            Text(
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
