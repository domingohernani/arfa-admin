import 'package:admin/themes/theme.dart';
import 'package:flutter/material.dart';

class RequestsView extends StatefulWidget {
  const RequestsView({super.key});

  @override
  State<RequestsView> createState() => _RequestsViewState();
}

class _RequestsViewState extends State<RequestsView> {
  List<String> filterItems = [];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width =
        MediaQuery.of(context).size.width - sidebarSize - paddingHorizontal;
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.symmetric(
        vertical: paddingView_vertical,
        horizontal: paddingView_horizontal,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Request",
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
              padding: EdgeInsets.symmetric(
                  horizontal: paddingView_horizontal,
                  vertical: paddingView_vertical),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text("All Request"),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Pending Request"),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Rejected Request"),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 220,
                        height: 25,
                        child: const TextField(
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            hintText: "Search...",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                            contentPadding: EdgeInsets.only(bottom: 14),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            prefixIcon: Icon(
                              Icons.search_sharp,
                              size: 18,
                            ),
                          ),
                          cursorHeight: 15,
                          maxLines: 1,
                        ),
                      ),
                      Container(
                        width: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: OutlinedButton(
                                onPressed: () {},
                                child: Icon(
                                  Icons.mode_edit_outline_outlined,
                                  size: 22,
                                  color: primary,
                                ),
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () {},
                              child: Icon(
                                Icons.delete_outline_rounded,
                                size: 22,
                                color: primary,
                              ),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Seller ID"),
                        Text("Date"),
                        Text("Time"),
                        Text("Seller"),
                        Text("Request Status"),
                      ],
                    ),
                  ),
                  const Divider(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("01150${index}"),
                                  const Text("September 20, 2024"),
                                  const Text("8:20 AM"),
                                  const Text("Vincent Cueva"),
                                  Container(
                                    width: 80,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: secondary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child:
                                        const Center(child: Text("Accepted")),
                                  )
                                ],
                              ),
                            ),
                            const Divider(
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
            )
          ],
        ),
      ),
    );
  }
}
