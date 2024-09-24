import 'package:admin/components/bargraph.dart';
import 'package:admin/constants/constant.dart';
import 'package:admin/screens/dashboard.dart';
import 'package:admin/screens/report.dart';
import 'package:admin/screens/request.dart';
import 'package:admin/screens/seller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Widget menuView = DashboardView();
  Color activeButtonColor = secondary;
  String activeMenu = "Dashboard";

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(
            horizontal: 50,
          ),
          color: primaryBg,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 30,
                    child: Image.asset("assets/logo/logo-white.png"),
                  ),
                  Gap(width * 0.12),
                  Container(
                    width: 250,
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_sharp,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 180,
                          height: 25,
                          child: TextField(
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              hintText: "Search",
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                              contentPadding: EdgeInsets.only(bottom: 14),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            cursorColor: Colors.white,
                            cursorHeight: 15,
                            maxLines: 1,
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
              Container(
                height: 30,
                width: 230,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.message_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: secondary,
                          child: Text(
                            "B",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Text(
                          "Admin",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (String value) {
                            print(value);
                          },
                          icon: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'Profile',
                              child: Text('Profile'),
                            ),
                            PopupMenuItem<String>(
                              value: 'Settings',
                              child: Text('Settings'),
                            ),
                            PopupMenuItem<String>(
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
      body: Container(
        width: width,
        height: height,
        color: Colors.grey.shade200,
        child: Row(
          children: [
            Container(
              width: sidebarSize,
              height: height,
              color: primary,
              padding: EdgeInsets.symmetric(
                  vertical: paddingView_vertical,
                  horizontal: paddingView_horizontal),
              child: ListView(
                children: [
                  Text(
                    "MENU",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              menuView = DashboardView();
                              activeMenu = "Dashboard";
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.grey,
                            backgroundColor: activeMenu == "Dashboard"
                                ? activeButtonColor
                                : Colors.grey.shade200,
                            elevation: 3,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.home_outlined),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Dashboard",
                                style: TextStyle(
                                  fontWeight: activeMenu == "Dashboard"
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              menuView = SellersView();
                              activeMenu = "Sellers";
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.grey,
                            backgroundColor: activeMenu == "Sellers"
                                ? activeButtonColor
                                : Colors.grey.shade200,
                            elevation: 3,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.co_present_outlined),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Sellers",
                                style: TextStyle(
                                  fontWeight: activeMenu == "Sellers"
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              menuView = ReportsView();
                              activeMenu = "Reports";
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.grey,
                            backgroundColor: activeMenu == "Reports"
                                ? activeButtonColor
                                : Colors.grey.shade200,
                            elevation: 3,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.bar_chart_outlined),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Reports",
                                style: TextStyle(
                                  fontWeight: activeMenu == "Reports"
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              menuView = RequestsView();
                              activeMenu = "Requests";
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.grey,
                            backgroundColor: activeMenu == "Requests"
                                ? activeButtonColor
                                : Colors.grey.shade200,
                            elevation: 3,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.add_business_outlined),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Requests",
                                style: TextStyle(
                                  fontWeight: activeMenu == "Requests"
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "SETTINGS",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Icon(Icons.settings_outlined),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Personal Settings"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: paddingView_vertical,
                  horizontal: paddingView_horizontal),
              child: menuView,
            ),
          ],
        ),
      ),
    );
  }
}
