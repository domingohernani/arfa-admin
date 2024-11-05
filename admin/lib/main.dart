import 'package:admin/screens/customers/viewProduct.dart';
import 'package:admin/screens/menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print("WINDOW SIZE ======= Width:${width}, Height:${height}");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Raleway',
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Raleway',
            ),
      ),
      home: Scaffold(
        // body: ViewProductDetailsModal(
        //   productid: "kWNyAinXBaxYN5cLVKDS",
        // ),
        body: MenuScreen(
          uid: "qLpxJlrrP0eK7Z1jVsGAHKWPYL73",
        ),
      ),
      builder: EasyLoading.init(),
    );
  }
}
