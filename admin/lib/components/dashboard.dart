import 'package:admin/components/bargraph.dart';
import 'package:admin/components/linegraph.dart';
import 'package:admin/constants/constant.dart';

import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width =
        MediaQuery.of(context).size.width - sidebarSize - paddingHorizontal;
    return Container(
      height: height,
      width: width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Dashboard",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Row(
                    children: [
                      Icon(
                        Icons.settings,
                        size: 20,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Manage",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DataCard(
                  title: "₱ 100,000.00",
                  subTitle: "Monthly Revenue",
                  percentage: "98.00",
                  iconData: Icons.arrow_drop_up_outlined,
                  cardIcon: Icons.attach_money_outlined,
                ),
                DataCard(
                  title: "1,000",
                  subTitle: "Orders",
                  percentage: "98.00",
                  iconData: Icons.arrow_drop_up_outlined,
                  cardIcon: Icons.shopping_bag_outlined,
                ),
                DataCard(
                  title: "100",
                  subTitle: "New Users",
                  percentage: "98.00",
                  iconData: Icons.arrow_drop_up_outlined,
                  cardIcon: Icons.person_add_alt_1_outlined,
                ),
                DataCard(
                  title: "1,000",
                  subTitle: "Existing Users",
                  percentage: "98.00",
                  iconData: Icons.arrow_drop_up_outlined,
                  cardIcon: Icons.groups_2_outlined,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: width * 0.63,
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 20,
                    bottom: 10,
                    right: 25,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Orders Over Time",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 300,
                        width: width * 0.63,
                        child: LineGraph(),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: width * 0.35,
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 20,
                    bottom: 10,
                    right: 25,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Weekly Sales",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 300,
                        width: width * 0.35,
                        child: BarGraph(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: width,
              padding: const EdgeInsets.only(
                top: 10,
                left: 20,
                bottom: 10,
                right: 25,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Top Seller by Units Sold",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Name"),
                        Text("Revenue"),
                        Text("Units Sold"),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.black,
                  ),
                  Container(
                    width: width,
                    height: 400,
                    child: ListView.builder(
                      itemCount: 15,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Ryan Shop"),
                                  Text("P 100,000.00"),
                                  Text("1,100"),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                              thickness: 0.5,
                            )
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DataCard extends StatelessWidget {
  const DataCard(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.percentage,
      required this.iconData,
      required this.cardIcon});

  final String title;
  final String subTitle;
  final String percentage;
  final IconData iconData;
  final IconData cardIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
              Text(
                subTitle,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
              Row(
                children: [
                  Text(
                    "+ $percentage",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.green,
                    ),
                  ),
                  Icon(
                    iconData,
                    color: Colors.green,
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            width: 30,
          ),
          Icon(
            cardIcon,
            color: primaryBg,
            size: 40,
          ),
        ],
      ),
    );
  }
}
