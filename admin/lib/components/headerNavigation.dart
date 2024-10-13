// import 'package:admin/constants/constant.dart';
// import 'package:admin/screens/login.dart';
// import 'package:admin/services/firestoreService.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';

// class HeaderNavigation extends StatefulWidget {
//   const HeaderNavigation({super.key, required this.id});

//   final String id;

//   @override
//   State<HeaderNavigation> createState() => _HeaderNavigationState();
// }

// class _HeaderNavigationState extends State<HeaderNavigation> {
//   Color activeButtonColor = secondary;
//   String activeMenu = "Dashboard";

//   final FirestoreService _fs = FirestoreService();

//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;

//     return FutureBuilder(
//         future: _fs.getAdminData(widget.id),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data == null) {
//             return const Center(child: Text('No admin data found.'));
//           }
//           print("here:${snapshot.data}");

//           var admin = snapshot.data!;

//           return Container(
//             height: 60,
//             padding: const EdgeInsets.symmetric(
//               horizontal: 50,
//             ),
//             color: primaryBg,
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     SizedBox(
//                       height: 30,
//                       child: Image.asset("assets/logo/logo-white.png"),
//                     ),
//                     SizedBox(width: width * 0.12),
//                     Container(
//                       width: 250,
//                       alignment: Alignment.center,
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Icon(
//                             Icons.search_sharp,
//                             color: Colors.white,
//                             size: 18,
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           SizedBox(
//                             width: 180,
//                             height: 25,
//                             child: const TextField(
//                               textAlign: TextAlign.start,
//                               decoration: InputDecoration(
//                                 hintText: "Search",
//                                 hintStyle: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.normal,
//                                 ),
//                                 contentPadding: EdgeInsets.only(bottom: 14),
//                                 enabledBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.white),
//                                 ),
//                                 focusedBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.white),
//                                 ),
//                               ),
//                               cursorColor: Colors.white,
//                               cursorHeight: 15,
//                               maxLines: 1,
//                               style: TextStyle(
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 30,
//                   width: 260,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         onPressed: () {},
//                         icon: const Icon(
//                           Icons.message_outlined,
//                           color: Colors.white,
//                           size: 20,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {},
//                         icon: const Icon(
//                           Icons.notifications_outlined,
//                           color: Colors.white,
//                           size: 20,
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             backgroundColor: secondary,
//                             child: Text(
//                               admin.name[0],
//                               style: const TextStyle(
//                                 fontSize: 20,
//                               ),
//                             ),
//                           ),
//                           Text(
//                             admin.name,
//                             style: const TextStyle(
//                               fontSize: 15,
//                               color: Colors.white,
//                             ),
//                           ),
//                           PopupMenuButton<String>(
//                             onSelected: (String value) {
//                               if (value == "Logout") {
//                                 _fs.signOut();
//                                 Navigator.of(context).pushReplacement(
//                                   MaterialPageRoute(
//                                     builder: (context) => const LoginScreen(),
//                                   ),
//                                 );
//                                 EasyLoading.showToast(
//                                   'You\'ve been logout!',
//                                 );
//                               }
//                             },
//                             icon: const Icon(
//                               Icons.keyboard_arrow_down_outlined,
//                               color: Colors.white,
//                               size: 20,
//                             ),
//                             itemBuilder: (BuildContext context) =>
//                                 <PopupMenuEntry<String>>[
//                               const PopupMenuItem<String>(
//                                 value: 'Profile',
//                                 child: Text('Profile'),
//                               ),
//                               const PopupMenuItem<String>(
//                                 value: 'Settings',
//                                 child: Text('Settings'),
//                               ),
//                               const PopupMenuItem<String>(
//                                 value: 'Logout',
//                                 child: Text('Logout'),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//   }
// }
