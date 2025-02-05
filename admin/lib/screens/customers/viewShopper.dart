import 'package:admin/models/furnituresData.dart';
import 'package:admin/models/singleShopData.dart';
import 'package:admin/models/singleUser.dart';
import 'package:admin/screens/customers/viewProduct.dart';
import 'package:admin/services/firestoreService.dart';
import 'package:admin/themes/theme.dart';
import 'package:admin/utilities/logoUrl.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewShopperProfile extends StatefulWidget {
  final String id;
  ViewShopperProfile({super.key, required this.id});

  @override
  State<ViewShopperProfile> createState() => _ViewShopperProfileState();
}

class _ViewShopperProfileState extends State<ViewShopperProfile> {
  FirestoreService _fs = FirestoreService();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 0.90;
    var width = MediaQuery.of(context).size.width * 0.55;

    return FutureBuilder<SingleUser?>(
        future: _fs.getSingleUserData(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No users available"));
          }

          var shopper = snapshot.data!;

          String userProfile = "";

          if (!shopper.profileUrl.startsWith('https') &&
              shopper.profileUrl.isNotEmpty) {
            userProfile = getUserImageUrl(shopper.profileUrl);
          } else {
            userProfile = shopper.profileUrl;
          }

          print("List: ${shopper.wishlists.length}");

          return Center(
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 480,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: primary,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            right: 10,
                            top: 10,
                            child: Container(
                              width: 90,
                              child: Container(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: secondary,
                                  ),
                                  child: const Text(
                                    "Close",
                                    style: TextStyle(
                                      // color: textWhite,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 380,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 40,
                            top: 30,
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                    height: 160,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: primaryBg,
                                        width: 3,
                                      ),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: userProfile.isNotEmpty
                                        ? Image.network(
                                            userProfile,
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(
                                            Icons.person,
                                            size: 100,
                                            color: Colors.green.shade300,
                                          ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 60,
                                      left: 20,
                                    ),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              (shopper.firstname.isEmpty &&
                                                      shopper.lastname.isEmpty)
                                                  ? "No Name"
                                                  : "${shopper.firstname} ${shopper.lastname}",
                                              style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "ID: ${shopper.id}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              top: 210,
                              child: Container(
                                width: MediaQuery.of(context).size.width * .45,
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  children: [
                                    const Divider(
                                      color: Colors.black,
                                      thickness: 0.5,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Personal Information",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Row(
                                              children: [
                                                const Text(
                                                  "Email: ",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "${shopper.email}",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 0.5,
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                const Text(
                                                  "Phone Number: ",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "${shopper.phone}",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 0.5,
                                          ),
                                          Container(
                                            child: Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.start,
                                              children: [
                                                const Text(
                                                  "Address: ",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  shopper.address['street']!
                                                          .isNotEmpty
                                                      ? "${shopper.address['street']}, "
                                                      : "",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  shopper.address['barangay']!
                                                          .isNotEmpty
                                                      ? "${shopper.address['barangay']}, "
                                                      : "",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  shopper.address['city']!
                                                          .isNotEmpty
                                                      ? "${shopper.address['city']}, "
                                                      : "",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  shopper.address['province']!
                                                          .isNotEmpty
                                                      ? "${shopper.address['province']}, "
                                                      : "",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  shopper.address['region']!
                                                          .isNotEmpty
                                                      ? "${shopper.address['region']}, "
                                                      : "",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 0.5,
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                const Text(
                                                  "Date Created: ",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "${DateFormat('yyyy-MM-dd').format(shopper.datejoined.toDate())}",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 0.5,
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                const Text(
                                                  "Time Created: ",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "${DateFormat('HH:mm:ss').format(shopper.datejoined.toDate())}",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 0.5,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Wishlists",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: shopper.wishlists.isNotEmpty
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 25,
                                      mainAxisSpacing: 30,
                                      childAspectRatio: 4 / 4,
                                    ),
                                    itemCount: shopper.wishlists.length,
                                    itemBuilder: (context, index) {
                                      var wishlist = shopper.wishlists[index];

                                      return GestureDetector(
                                        onTap: () async {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return ViewProductDetailsModal(
                                                  productid:
                                                      wishlist.productid);
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 400,
                                          child: Card(
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Product Image
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius
                                                          .vertical(
                                                          top: Radius.circular(
                                                              16)),
                                                  child: Image.network(
                                                    wishlist
                                                        .imageurl, // Replace with your image URL
                                                    height: 120,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            '${wishlist.name}',
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          // Text(
                                                          //   'Rating',
                                                          //   style: TextStyle(
                                                          //     fontSize: 14,
                                                          //     color: Colors
                                                          //         .grey[600],
                                                          //   ),
                                                          // ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            '₱ ${wishlist.price}',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Align(
                                    alignment: Alignment.topCenter,
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.no_backpack_outlined,
                                          size: 100,
                                          color: Colors.green.shade300,
                                        ),
                                        Text(
                                          "No Product.",
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.green.shade300,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Cart",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: shopper.cartitems.isNotEmpty
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 25,
                                      mainAxisSpacing: 30,
                                      childAspectRatio: 4 / 4,
                                    ),
                                    itemCount: shopper.cartitems.length,
                                    itemBuilder: (context, index) {
                                      var cart = shopper.cartitems[index];

                                      return GestureDetector(
                                        onTap: () async {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return ViewProductDetailsModal(
                                                  productid: cart.productid);
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 200,
                                          child: Card(
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Product Image
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius
                                                          .vertical(
                                                          top: Radius.circular(
                                                              16)),
                                                  child: Image.network(
                                                    cart.imageurl, // Replace with your image URL
                                                    height: 120,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            '${cart.name}',
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          // Text(
                                                          //   'Rating',
                                                          //   style: TextStyle(
                                                          //     fontSize: 14,
                                                          //     color: Colors
                                                          //         .grey[600],
                                                          //   ),
                                                          // ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            '₱ ${cart.price}',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Align(
                                    alignment: Alignment.topCenter,
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.no_backpack_outlined,
                                          size: 100,
                                          color: Colors.green.shade300,
                                        ),
                                        Text(
                                          "No Product.",
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.green.shade300,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
