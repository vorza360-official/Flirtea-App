import 'dart:math' as math;

import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/screens/HomeScreen.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/gender.dart';

class KYCCompletedScreen extends StatelessWidget {
  KYCCompletedScreen({super.key});
  final GenderController genderController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'KYC Verification',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success icon
            // Container(
            //   width: 120,
            //   height: 120,
            //   decoration: const BoxDecoration(
            //     color: Color(0xFF8B4CB8),
            //     shape: BoxShape.circle,
            //   ),
            //   child: Stack(
            //     children: [
            //       // Decorative scalloped edge
            //       Positioned.fill(
            //         child: CustomPaint(
            //           painter: ScallopPainter(),
            //         ),
            //       ),
            //       // Check mark
            //       const Center(
            //         child: Icon(
            //           Icons.check,
            //           color: Colors.white,
            //           size: 50,
            //           weight: 800,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Image.asset(
              genderController.selectedGender.value == Gender.male?
                        "assets/images/Successmark.png":
                        genderController.selectedGender.value == Gender.female ?
                        "assets/images/female/Successmark.png":
                        "assets/images/nonBinary/Successmark.png",
              height: 120,width: 120,),
            const SizedBox(height: 24),
            const Text(
              'KYC Completed',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Thanks for submitting your documents we\'ll verify it\nand complete your KYC as soon as possible',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate back to home or main screen
                  //Navigator.of(context).popUntil((route) => route.isFirst);
                  Get.to(()=>HomeScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: genderController.selectedGender.value == Gender.male?
                        myPurple:
                        genderController.selectedGender.value == Gender.female ?
                        myBrown:
                        myYellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Back to home',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScallopPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8B4CB8)
      ..style = PaintingStyle.fill;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Create scalloped edge effect
    const scallops = 16;
    const scallopsAngle = (2 * 3.14159) / scallops;
    
    for (int i = 0; i < scallops; i++) {
      final angle = i * scallopsAngle;
      final x = center.dx + (radius - 8) * math.cos(angle);
      final y = center.dy + (radius - 8) * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      }
      
      // Add scallop curves
      final nextAngle = (i + 1) * scallopsAngle;
      final nextX = center.dx + (radius - 8) * math.cos(nextAngle);
      final nextY = center.dy + (radius - 8) * math.sin(nextAngle);
      
      final controlX = center.dx + radius * math.cos(angle + scallopsAngle / 2);
      final controlY = center.dy + radius * math.sin(angle + scallopsAngle / 2);
      
      path.quadraticBezierTo(controlX, controlY, nextX, nextY);
    }
    
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Import math for the custom painter
