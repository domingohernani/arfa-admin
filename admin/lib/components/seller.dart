import 'package:admin/constants/constant.dart';
import 'package:flutter/material.dart';

class SellersView extends StatefulWidget {
  const SellersView({super.key});

  @override
  State<SellersView> createState() => _SellersViewState();
}

class _SellersViewState extends State<SellersView> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width =
        MediaQuery.of(context).size.width - sidebarSize - paddingHorizontal;
    return SizedBox(
      height: height,
      width: width,
      child: const Text("Sellers"),
    );
  }
}
