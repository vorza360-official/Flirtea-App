import 'dart:math';

import 'package:dating_app/auth/auth_services.dart';
import 'package:dating_app/screens/accountBannedScreen.dart';
import 'package:dating_app/screens/genderScreen.dart';
import 'package:dating_app/screens/paymentScreen.dart';
import 'package:dating_app/widgets/CustomSnackBar.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 3 Texts
                    Text(
                      'Seduce, Swipe',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      'Stay Late',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      'Welcome to Dating App',
                      style: TextStyle(
                        fontSize: 18,
                        color: myPurple,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 40),

                    // Picture placeholder
                    Container(
                      child: Image.asset(
                        "assets/images/welcome_image.png",
                        fit: BoxFit.cover,
                      ),
                    ),

                    SizedBox(height: 40),

                    // Login buttons
                    _buildButton(
                      'Continue with Google',
                      Colors.white,
                      Colors.black,
                      "assets/icons/google.png",
                      () async {
                        final auth = Get.find<AuthService>();
                        final user = await auth.signInWithGoogle();
                        if (user != null) {
                          // StreamBuilder in AuthWrapper will automatically navigate
                          // (you can also do Get.to(() => GenderSelectionScreen()); if you prefer)
                        }
                      },
                    ),
                    SizedBox(height: 12),
                    _buildButton2(
                      'Continue with Facebook',
                      Colors.blue,
                      Colors.white,
                      "assets/icons/facebook.png",
                      () {
                        CustomSnackBar.show(context);
                      },
                    ),
                    SizedBox(height: 12),
                    _buildButton2(
                      'Continue with Apple',
                      Colors.black,
                      Colors.black,
                      "assets/icons/apple.png",
                      () {
                        Get.to(() => AccountBannedScreen());
                      },
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),

              // Age restriction container
              TornFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    String text,
    Color bgColor,
    Color textColor,
    String icon,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, height: 30, width: 30),
            SizedBox(width: 12),
            Text(text, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildButton2(
    String text,
    Color bgColor,
    Color textColor,
    String icon,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: bgColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, height: 30, width: 30),
            SizedBox(width: 12),
            Text(text, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class TornFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: JaggedEdgeClipper(),
      child: Container(
        width: double.infinity,
        color: Colors.black,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "You must be at least 18 years old!",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 8),
            Text.rich(
              TextSpan(
                text: "By continuing, you agree with ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text:
                        "Term and Conditions & Privacy Policy, Safety & Community Guidelines",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class JaggedEdgeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 3); // small offset at start

    int jaggedParts = 150; // super fine jaggles
    double step = size.width / jaggedParts;

    for (int i = 1; i <= jaggedParts; i++) {
      double x = step * i;
      double y = (i % 2 == 0) ? 2 : 5; // subtle up and down
      path.lineTo(x, y);
    }

    // complete the shape
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
