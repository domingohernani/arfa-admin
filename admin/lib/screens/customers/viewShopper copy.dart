// import 'package:admin/models/singleShopData.dart';
// import 'package:admin/services/firestoreService.dart';
// import 'package:admin/themes/theme.dart';
// import 'package:flutter/material.dart';

// class ViewShopperProfile extends StatefulWidget {
//   final String id;
//   ViewShopperProfile({super.key, required this.id});

//   @override
//   State<ViewShopperProfile> createState() => _ViewShopperProfileState();
// }

// class _ViewShopperProfileState extends State<ViewShopperProfile> {
//   FirestoreService _fs = FirestoreService();

//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height * 0.90;
//     var width = MediaQuery.of(context).size.width * 0.50;

//     print("width: ${width}");

//     return FutureBuilder<SingleShop?>(
//         future: _fs.getSingleStoreData(widget.id),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }

//           if (!snapshot.hasData || snapshot.data == null) {
//             return Center(child: Text("No sellers available"));
//           }

//           var seller = snapshot.data!;

//           return Center(
//             child: Container(
//               height: height,
//               width: width,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Container(
//                       height: 250,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         color: primary,
//                       ),
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           Positioned(
//                             right: 10,
//                             top: 10,
//                             child: Container(
//                               width: 90,
//                               child: Container(
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: secondary,
//                                   ),
//                                   child: Text(
//                                     "Close",
//                                     style: TextStyle(
//                                       // color: textWhite,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Align(
//                             alignment: Alignment.bottomCenter,
//                             child: Container(
//                               height: 150,
//                               width: MediaQuery.of(context).size.width,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 80,
//                             top: 40,
//                             child: Container(
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     height: 160,
//                                     width: 160,
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: primaryBg,
//                                         width: 3,
//                                       ),
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(10),
//                                       image: DecorationImage(
//                                         image: NetworkImage(seller.logo),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 30,
//                                   ),
//                                   Container(
//                                     margin: EdgeInsets.only(top: 70),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "Ryan King Ballesteros",
//                                           style: TextStyle(
//                                             fontSize: 25,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 5,
//                                         ),
//                                         Text(
//                                           "ID: LASHFOIHENCVAOEFIJ",
//                                           style: TextStyle(
//                                             fontSize: 18,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Text(
//                       "Personal Information",
//                       style: TextStyle(
//                         fontSize: 20,
//                         color: primary,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Container(
//                       width: double.infinity,
//                       height: 100,
//                       margin: EdgeInsets.symmetric(horizontal: 30),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Column(
//                         children: [
//                           Container(
//                             child: Row(
//                               children: [
//                                 Text("Name")
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }
// }
