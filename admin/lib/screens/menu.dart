import 'package:admin/components/headerNavigation.dart';
import 'package:admin/components/sideBarNavigation.dart';
import 'package:admin/screens/customers/shoppers.dart';
import 'package:admin/screens/customers/viewStore.dart';
import 'package:admin/screens/dashboard/dashboard.dart';
import 'package:admin/screens/platform/platform.dart';
import 'package:admin/screens/refund/refund.dart';
import 'package:admin/screens/reports/report.dart';
import 'package:admin/screens/requests/request.dart';
import 'package:admin/screens/customers/seller.dart';
import 'package:admin/screens/shopScreen.dart';
import 'package:admin/themes/theme.dart';
import 'package:admin/models/adminData.dart';
import 'package:admin/screens/login.dart';
import 'package:admin/services/firestoreService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MenuScreen extends StatefulWidget {
  final String uid;
  final String? menu;

  const MenuScreen({super.key, required this.uid, this.menu});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // Widget menuView = DashboardView();
  final FirestoreService _fs = FirestoreService();
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: _fs.getAdminData(widget.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No admin data found.'));
        }

        var admin = snapshot.data!;

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              color: primaryBg,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 30,
                        child: Image.asset("assets/logo/logo-white.png"),
                      ),
                      const SizedBox(width: 50),
                      Container(
                        width: 350,
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: const Text(
                                "Augmented Reality Furniture Assistant",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                            // const Icon(
                            //   Icons.search_sharp,
                            //   color: Colors.white,
                            //   size: 18,
                            // ),
                            // const SizedBox(
                            //   width: 5,
                            // ),
                            // SizedBox(
                            //   width: 180,
                            //   height: 25,
                            //   child: const TextField(
                            //     textAlign: TextAlign.start,
                            //     decoration: InputDecoration(
                            //       hintText: "Search",
                            //       hintStyle: TextStyle(
                            //         color: Colors.white,
                            //         fontWeight: FontWeight.normal,
                            //       ),
                            //       contentPadding: EdgeInsets.only(bottom: 14),
                            //       enabledBorder: UnderlineInputBorder(
                            //         borderSide: BorderSide(color: Colors.white),
                            //       ),
                            //       focusedBorder: UnderlineInputBorder(
                            //         borderSide: BorderSide(color: Colors.white),
                            //       ),
                            //     ),
                            //     cursorColor: Colors.white,
                            //     cursorHeight: 15,
                            //     maxLines: 1,
                            //     style: TextStyle(
                            //       color: Colors.white,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                    width: 260,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.message_outlined,
                            color: Color(0xFF05583C),
                            size: 20,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: Color(0xFF05583C),
                            size: 20,
                          ),
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: secondary,
                              child: Text(
                                admin.name[0],
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              admin.name,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (String value) {
                                if (value == "Logout") {
                                  _fs.signOut();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                  EasyLoading.showToast(
                                    'You\'ve been logout!',
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                // const PopupMenuItem<String>(
                                //   value: 'Profile',
                                //   child: Text('Profile'),
                                // ),
                                // const PopupMenuItem<String>(
                                //   value: 'Settings',
                                //   child: Text('Settings'),
                                // ),
                                const PopupMenuItem<String>(
                                  value: 'Logout',
                                  child: Text('Logout'),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SideMenu(
                controller: sideMenu,
                style: SideMenuStyle(
                  displayMode: SideMenuDisplayMode.auto,
                  openSideMenuWidth: 220,
                  arrowCollapse: Colors.white,
                  showHamburger: true,
                  hoverColor: secondary,
                  unselectedIconColor: Colors.white,
                  unselectedTitleTextStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  selectedHoverColor: Colors.grey.shade200,
                  selectedColor: Colors.white,
                  selectedTitleTextStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  selectedIconColor: Colors.black,
                  itemHeight: 45,
                  itemOuterPadding: const EdgeInsets.only(
                    right: 10,
                    left: 10,
                    bottom: 10,
                  ),
                  backgroundColor: primary,
                ),
                collapseWidth: 800,
                title: Center(
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                      bottom: 10,
                      right: 10,
                      left: 10,
                    ),
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: secondary,
                        size: 50,
                      ),
                    ),
                  ),
                ),
                items: [
                  SideMenuItem(
                    title: 'Dashboard',
                    onTap: (index, _) {
                      sideMenu.changePage(index);
                    },
                    icon: const Icon(Icons.home),
                    // badgeContent: const Text(
                    //   '3',
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 12,
                    //   ),
                    // ),
                    tooltipContent: "Dashboard",
                  ),
                  SideMenuExpansionItem(
                    title: 'Customers',
                    iconWidget: const Icon(
                      Icons.group_rounded,
                      color: Colors.white,
                    ),
                    children: [
                      SideMenuItem(
                        title: 'Sellers',
                        onTap: (index, _) {
                          sideMenu.changePage(index);
                        },
                        icon: const Icon(Icons.store_rounded),
                      ),
                      SideMenuItem(
                        title: 'Shoppers',
                        onTap: (index, _) {
                          sideMenu.changePage(index);
                        },
                        icon: const Icon(Icons.supervised_user_circle_rounded),
                      ),
                    ],
                  ),
                  SideMenuItem(
                    title: 'Refunds',
                    onTap: (index, _) {
                      sideMenu.changePage(index);
                    },
                    icon: const Icon(Icons.swap_horiz),
                  ),
                  SideMenuItem(
                    title: 'Reports',
                    onTap: (index, _) {
                      sideMenu.changePage(index);
                    },
                    icon: const Icon(Icons.file_copy_rounded),
                  ),
                  SideMenuItem(
                    title: 'Platform',
                    onTap: (index, _) {
                      sideMenu.changePage(index);
                    },
                    icon: const Icon(Icons.layers),
                  ),
                  SideMenuItem(
                    title: 'Documents',
                    onTap: (index, _) {
                      sideMenu.changePage(index);
                    },
                    icon: const Icon(Icons.description),
                  ),
                  // SideMenuItem(
                  //   title: 'Requests',
                  //   onTap: (index, _) {
                  //     sideMenu.changePage(index);
                  //   },
                  //   icon: const Icon(Icons.download),
                  // ),

                  // SideMenuItem(
                  //   onTap:(index, _){
                  //     sideMenu.changePage(index);
                  //   },
                  //   icon: const Icon(Icons.image_rounded),
                  // ),
                  // SideMenuItem(
                  //   title: 'Only Title',
                  //   onTap:(index, _){
                  //     sideMenu.changePage(index);
                  //   },
                  // ),
                ],
              ),
              const VerticalDivider(
                width: 0,
              ),
              Expanded(
                child: PageView(
                  controller: pageController,
                  children: [
                    const DashboardView(),
                    const SellersView(),
                    const ShoppersView(),
                    Refund(),
                    const ReportsView(),
                    const PlatformScreen(),
                    ShopsScreen()

                    // RequestsView(),

                    // Container(
                    //   color: Colors.white,
                    //   child: const Center(
                    //     child: Text(
                    //       'Dashboardsss',
                    //       style: TextStyle(fontSize: 35),
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   color: Colors.white,
                    //   child: const Center(
                    //     child: Text(
                    //       'Sellers',
                    //       style: TextStyle(fontSize: 35),
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   color: Colors.white,
                    //   child: const Center(
                    //     child: Text(
                    //       'Reports',
                    //       style: TextStyle(fontSize: 35),
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   color: Colors.white,
                    //   child: const Center(
                    //     child: Text(
                    //       'Requests',
                    //       style: TextStyle(fontSize: 35),
                    //     ),
                    //   ),
                    // ),

                    // Container(
                    //   color: Colors.white,
                    //   child: const Center(
                    //     child: Text(
                    //       'Profile Settings',
                    //       style: TextStyle(fontSize: 35),
                    //     ),
                    //   ),
                    // ),
                    // this is for SideMenuItem with builder (divider)
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
