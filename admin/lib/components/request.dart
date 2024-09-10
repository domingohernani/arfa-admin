import 'package:admin/constants/constant.dart';
import 'package:flutter/material.dart';

class RequestsView extends StatefulWidget {
  const RequestsView({super.key});

  @override
  State<RequestsView> createState() => _RequestsViewState();
}

class _RequestsViewState extends State<RequestsView> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width =
        MediaQuery.of(context).size.width - sidebarSize - paddingHorizontal;
    return SizedBox(
      height: height,
      width: width,
      child: const Text("Requests"),
    );
  }
}
