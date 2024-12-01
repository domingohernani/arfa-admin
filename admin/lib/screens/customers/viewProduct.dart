import 'package:admin/models/furnituresData.dart';
import 'package:admin/models/productData.dart';
import 'package:admin/services/firestoreService.dart';
import 'package:admin/themes/theme.dart';
import 'package:flutter/material.dart';

class ViewProductDetailsModal extends StatefulWidget {
  final String productid;
  const ViewProductDetailsModal({super.key, required this.productid});

  @override
  State<ViewProductDetailsModal> createState() =>
      _ViewProductDetailsModalState();
}

class _ViewProductDetailsModalState extends State<ViewProductDetailsModal> {
  final FirestoreService _fs = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.80;
    final double width = MediaQuery.of(context).size.width * 0.6;

    return Center(
      child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 25),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header Row with Title and Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Product Details",
                  style: TextStyle(
                    fontSize: 25,
                    color: primaryBg,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: primary),
                  child: Text(
                    "Close",
                    style: TextStyle(
                      color: textWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Product Details Section
            Expanded(
              child: FutureBuilder<Furniture?>(
                future: _fs.getSingleFurnituresData(widget.productid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(
                        child: Text("No product details available"));
                  }

                  final furniture = snapshot.data!;

                  Stock stock = furniture.stockwithvariant.first;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Container
                      Container(
                        width: width * 0.4,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: primary, width: 3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            furniture.imageurl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),

                      // Details Column
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                furniture.name,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: primaryBg,
                                ),
                              ),
                              Text(
                                "\"${furniture.category}\"",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: primary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const Divider(thickness: 1.5),

                              // Description Section
                              const Text(
                                "Description: ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                furniture.description,
                                style: const TextStyle(fontSize: 15),
                                textAlign: TextAlign.justify,
                              ),
                              const SizedBox(height: 15),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: primary, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: furniture.issale
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "₱ ${furniture.discountedprice}",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: primaryBg,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "₱ ${furniture.price}",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        "₱ ${furniture.price}",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: primaryBg,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  const Text(
                                    "Stocks: ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${stock.latestQuantity}",
                                    style: const TextStyle(fontSize: 20),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 25),
                              const Text(
                                "Reviews: ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              furniture.review.isNotEmpty
                                  ? SizedBox(
                                      height: height,
                                      child: ListView.builder(
                                        itemCount: furniture.review.length,
                                        itemBuilder: (context, index) {
                                          final rev = furniture.review[index];
                                          return Card(
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Row(
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 20,
                                                            child: Icon(
                                                                Icons.person),
                                                          ),
                                                          SizedBox(width: 10),
                                                          Text(
                                                            "Ryan King Ballesteros",
                                                            style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 50),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                              "Title: ",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(rev.title),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 50),
                                                        child: Text(
                                                          rev.description,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15),
                                                          maxLines: 5,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  // Rating Box
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: primary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "Rating",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: textWhite,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${rev.rating}",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: textWhite,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : const Center(
                                      child: Text("No reviews available.")),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
