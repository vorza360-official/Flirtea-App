import 'package:dating_app/auth/auth_wrapper.dart';
import 'package:dating_app/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Navigate after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Get.off(() => AuthWrapper()); // replace LoginScreen with your screen
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/app_logo.png', // add logo in assets folder
              height: 90,
            ),
            SizedBox(height: 30),

            // Title
            Text(
              "Flirtea",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Subtitle
            Text(
              "Flirt Better. Connect Deeper",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
