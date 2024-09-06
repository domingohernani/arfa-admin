import 'package:admin/constants/constant.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hidePassword = true;
  Color? forgotPassword;

  void togglePassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
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
                    onPressed: () {},
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
            )
          ],
        ),
      ),
    );
  }
}
