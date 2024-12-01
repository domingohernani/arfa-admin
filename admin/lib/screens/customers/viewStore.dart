import 'package:admin/components/viewDocument.dart';
import 'package:admin/models/singleShopData.dart';
import 'package:admin/screens/customers/viewProduct.dart';
import 'package:admin/services/firestoreService.dart';
import 'package:admin/themes/theme.dart';
import 'package:flutter/material.dart';

class ViewStoreProile extends StatefulWidget {
  final String id;
  ViewStoreProile({super.key, required this.id});

  @override
  State<ViewStoreProile> createState() => _ViewStoreProileState();
}

class _ViewStoreProileState extends State<ViewStoreProile> {
  FirestoreService _fs = FirestoreService();
  bool hasValidId = false;
  bool hasBusinessPermit = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 0.90;
    var width = MediaQuery.of(context).size.width * 0.90;

    print("width: ${width}");

    return FutureBuilder<SingleShop?>(
        future: _fs.getSingleStoreData(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No sellers available"));
          }

          var seller = snapshot.data!;

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
                      height: 400,
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
                              height: 310,
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
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: primaryBg,
                                        width: 3,
                                      ),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(seller.logo),
                                      ),
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
                                              "${seller.shopname}",
                                              style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Seller ID: ${seller.id}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              top: 170,
                              child: Container(
                                width: MediaQuery.of(context).size.width * .85,
                                child: Column(
                                  children: [
                                    const Divider(
                                      color: Colors.black,
                                      thickness: 0.5,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Total Sales: "),
                                            Text("Units Sold: "),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 130,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Contacts",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                                "Phone Number: ${seller.phone}"),
                                            Text("Email: ${seller.email}"),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 130,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Address",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                                "${seller.address['street']} ${seller.address['barangay']} ${seller.address['city']}"),
                                            Text(
                                                "${seller.address['province']} ${seller.address['region']}")
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Payment Details",
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  if (seller.payout['method'] ==
                                                      'paypal')
                                                    Container(
                                                      height: 70,
                                                      width: 500,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: primary,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Icon(
                                                                Icons.paypal,
                                                                size: 25,
                                                                color: Colors
                                                                    .blue
                                                                    .shade800,
                                                              ),
                                                              const Text(
                                                                "Paypal",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const VerticalDivider(),
                                                          Container(
                                                            width: 350,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Name: ",
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                        "${seller.payout['paypalname']}")
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Account: ",
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                        "${seller.payout['paypalemail']}")
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  if (seller.payout['method'] ==
                                                      'gcash')
                                                    Container(
                                                      height: 70,
                                                      width: 500,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: primary,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 25,
                                                                child:
                                                                    Image.asset(
                                                                  "assets/payment/gcash.png",
                                                                ),
                                                              ),
                                                              const Text(
                                                                "Gcash",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const VerticalDivider(),
                                                          Container(
                                                            width: 350,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Name: ",
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                        "${seller.payout['gcashname']}")
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Account: ",
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                        "${seller.payout['gcashnumber']}")
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Valid Documents",
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 70,
                                                    width: 500,
                                                    margin:
                                                        const EdgeInsets.only(
                                                      left: 20,
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: primary,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              Checkbox(
                                                                value: seller
                                                                        .shoppermit
                                                                        .isNotEmpty
                                                                    ? true
                                                                    : false,
                                                                onChanged:
                                                                    (value) {
                                                                  if (seller
                                                                      .shopvalidid
                                                                      .isNotEmpty) {
                                                                    setState(
                                                                        () {
                                                                      hasValidId =
                                                                          true;
                                                                    });
                                                                  }
                                                                },
                                                              ),
                                                              const Text(
                                                                  "Valid Id")
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              Checkbox(
                                                                value: seller
                                                                        .shoppermit
                                                                        .isNotEmpty
                                                                    ? true
                                                                    : false,
                                                                onChanged:
                                                                    (value) {
                                                                  // if (seller
                                                                  //     .shoppermit
                                                                  //     .isNotEmpty) {
                                                                  //   setState(
                                                                  //       () {
                                                                  //     hasBusinessPermit =
                                                                  //         value =
                                                                  //             true;
                                                                  //   });
                                                                  // }
                                                                },
                                                              ),
                                                              const Text(
                                                                  "Business Permit")
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color: primaryBg,
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          child: TextButton(
                                                            onPressed:
                                                                () async {
                                                              await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return ViewDocumentModal(
                                                                    idurl: seller
                                                                        .shopvalidid,
                                                                    permiturl:
                                                                        seller
                                                                            .shoppermit,
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            style: TextButton
                                                                .styleFrom(
                                                              shape:
                                                                  const RoundedRectangleBorder(),
                                                              backgroundColor:
                                                                  primary,
                                                            ),
                                                            child: Text(
                                                              "View Document",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    textWhite,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
                            "Products By Seller",
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
                            height: MediaQuery.of(context).size.height,
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: seller.furniture.isNotEmpty
                                ? GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 25,
                                      mainAxisSpacing: 30,
                                      childAspectRatio: 4 / 4.2,
                                    ),
                                    itemCount: seller.furniture
                                        .length, // +1 for the AddSellerCard
                                    itemBuilder: (context, index) {
                                      var sel = seller.furniture[index];

                                      return GestureDetector(
                                        onTap: () async {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return ViewProductDetailsModal(
                                                  productid: sel.productid);
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
                                                    sel.imageurl, // Replace with your image URL
                                                    height: 200,
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
                                                          Expanded(
                                                            child: Text(
                                                              '${sel.name}',
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            'Rating',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .grey[600],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            '₱ ${sel.price}',
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
                                                          const Text(
                                                            '4.6',
                                                            style: TextStyle(
                                                              fontSize: 14,
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
                                          size: 150,
                                          color: Colors.green.shade300,
                                        ),
                                        Text(
                                          "No Product.",
                                          style: TextStyle(
                                            fontSize: 50,
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
