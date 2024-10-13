import 'dart:ui';

import 'package:admin/themes/theme.dart';
import 'package:admin/screens/menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hidePassword = true;
  Color? forgotPassword;
  final emailCont = TextEditingController();
  final passwordCont = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void togglePassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Logging In. Please wait...');

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailCont.text, password: passwordCont.text);

        String id = FirebaseAuth.instance.currentUser!.uid;

        print("My id: $id");

        EasyLoading.dismiss();

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MenuScreen(uid: id),
        ));

        print('Login successful');
      } catch (error) {
        EasyLoading.dismiss();

        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'No User Found!',
            text: 'Enter a valid account.');

        print('Login failed: $error');
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Row(
          children: [
            Container(
              width: width * 0.5,
              height: height,
              color: primary,
            ),
            Container(
              width: width * 0.5,
              height: height,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: height * 0.08,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * 0.075,
                      child: Image.asset(
                        "assets/logo/logo-green.png",
                      ),
                    ),
                    SizedBox(
                      height: height * 0.065,
                    ),
                    Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: height * 0.07,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Please login your account",
                      style: TextStyle(
                        fontSize: height * 0.03,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.075,
                    ),
                    Container(
                      height: height * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(height * 0.01),
                      ),
                      child: TextFormField(
                        controller: emailCont,
                        decoration: InputDecoration(
                          label: const Text("Email"),
                          labelStyle: TextStyle(fontSize: height * 0.02),
                          border: const OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.person,
                            size: height * 0.03,
                          ),
                          suffix: Text(
                            "",
                            style: TextStyle(
                              fontSize: height * 0.03,
                            ),
                          ),
                        ),
                        cursorHeight: height * 0.02,
                        style: TextStyle(
                          fontSize: height * 0.02,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Container(
                      height: height * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(height * 0.01),
                      ),
                      child: TextFormField(
                        controller: passwordCont,
                        decoration: InputDecoration(
                          label: const Text("Password"),
                          labelStyle: TextStyle(fontSize: height * 0.02),
                          border: const OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.lock,
                            size: height * 0.03,
                          ),
                          suffix: IconButton(
                            onPressed: togglePassword,
                            icon: Icon(
                              hidePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: height * 0.03,
                            ),
                          ),
                        ),
                        cursorHeight: height * 0.02,
                        style: TextStyle(
                          fontSize: height * 0.02,
                        ),
                        obscureText: hidePassword,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {},
                        onHover: (value) {
                          if (value == true) {
                            forgotPassword = Colors.black;
                          } else {
                            forgotPassword = Colors.grey;
                          }
                          setState(() {});
                        },
                        style: TextButton.styleFrom(
                          overlayColor: Colors.transparent,
                        ),
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                            fontSize: height * 0.018,
                            color: forgotPassword,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(width, height * 0.06),
                        backgroundColor: primary,
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: height * 0.02,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
