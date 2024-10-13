// import 'package:admin/themes/theme.dart';
// import 'package:admin/screens/dashboard/dashboard.dart';
// import 'package:flutter/material.dart';

// class SideBarNavigation extends StatefulWidget {
//   const SideBarNavigation({super.key});

//   @override
//   State<SideBarNavigation> createState() => _SideBarNavigationState();
// }

// class _SideBarNavigationState extends State<SideBarNavigation> {
//   Color activeButtonColor = secondary;
//   String activeMenu = "Dashboard";
//   Widget menuView = DashboardScreen();

//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;

//     return Container(
//       width: width,
//       height: height,
//       color: Colors.grey.shade200,
//       child: Row(
//         children: [
//           Container(
//             width: sidebarSize,
//             height: height,
//             color: primary,
//             padding: EdgeInsets.symmetric(
//                 vertical: paddingView_vertical,
//                 horizontal: paddingView_horizontal),
//             child: ListView(
//               children: [
//                 Text(
//                   "MENU",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(vertical: 10),
//                   height: 200,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           // setState(() {
//                           //   menuView = DashboardView();
//                           //   activeMenu = "Dashboard";
//                           // });
//                         },
//                         style: ElevatedButton.styleFrom(
//                           shadowColor: Colors.grey,
//                           backgroundColor: activeMenu == "Dashboard"
//                               ? activeButtonColor
//                               : Colors.grey.shade200,
//                           elevation: 3,
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(Icons.home_outlined),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text(
//                               "Dashboard",
//                               style: TextStyle(
//                                 fontWeight: activeMenu == "Dashboard"
//                                     ? FontWeight.w700
//                                     : FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             // menuView = SellersView();
//                             activeMenu = "Sellers";
//                           });
//                         },
//                         style: ElevatedButton.styleFrom(
//                           shadowColor: Colors.grey,
//                           backgroundColor: activeMenu == "Sellers"
//                               ? activeButtonColor
//                               : Colors.grey.shade200,
//                           elevation: 3,
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(Icons.co_present_outlined),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text(
//                               "Sellers",
//                               style: TextStyle(
//                                 fontWeight: activeMenu == "Sellers"
//                                     ? FontWeight.w700
//                                     : FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             // menuView = ReportsView();
//                             activeMenu = "Reports";
//                           });
//                         },
//                         style: ElevatedButton.styleFrom(
//                           shadowColor: Colors.grey,
//                           backgroundColor: activeMenu == "Reports"
//                               ? activeButtonColor
//                               : Colors.grey.shade200,
//                           elevation: 3,
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(Icons.bar_chart_outlined),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text(
//                               "Reports",
//                               style: TextStyle(
//                                 fontWeight: activeMenu == "Reports"
//                                     ? FontWeight.w700
//                                     : FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             // menuView = RequestsView();
//                             activeMenu = "Requests";
//                           });
//                         },
//                         style: ElevatedButton.styleFrom(
//                           shadowColor: Colors.grey,
//                           backgroundColor: activeMenu == "Requests"
//                               ? activeButtonColor
//                               : Colors.grey.shade200,
//                           elevation: 3,
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(Icons.add_business_outlined),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text(
//                               "Requests",
//                               style: TextStyle(
//                                 fontWeight: activeMenu == "Requests"
//                                     ? FontWeight.w700
//                                     : FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Text(
//                   "SETTINGS",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(vertical: 10),
//                   height: 200,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {},
//                         child: Row(
//                           children: [
//                             Icon(Icons.settings_outlined),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text("Personal Settings"),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(
//                 vertical: paddingView_vertical,
//                 horizontal: paddingView_horizontal),
//             child: menuView,
//           ),
//         ],
//       ),
//     );
//   }
// }
