import 'package:admin/components/cookiespolicy.dart';
import 'package:admin/components/termsAndCondition.dart';
import 'package:flutter/material.dart';

class PlatformScreen extends StatelessWidget {
  const PlatformScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 230,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TermsAndConditionUploader(),
              ),
            ),
            SizedBox(
              height: 220,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: CookiesPoliciesUploader(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
