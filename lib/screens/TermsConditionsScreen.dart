import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsConditionsScreen extends StatelessWidget {
  final GenderController genderController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom Torn AppBar
          ClipPath(
            clipper: JaggedEdgeClipper(),
            child: Container(
              color: genderController.selectedGender.value == Gender.male
                  ? Colors.black
                  : genderController.selectedGender.value == Gender.female
                  ? Colors.black
                  : myPurple,
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 40,
                left: 16,
                right: 16,
                bottom: 30,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Terms & Conditions",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Terms Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Effective Date: January 2026",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildSection(
                    "1. Acceptance of Terms",
                    "By accessing and using this dating application, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to these terms, please do not use our services.",
                  ),
                  SizedBox(height: 20),
                  _buildSection(
                    "2. Eligibility",
                    "You must be at least 18 years old to use this service. By creating an account, you represent and warrant that:\n\n• You are at least 18 years of age\n• You have the right, authority, and capacity to enter into this agreement\n• You will comply with all terms and conditions",
                  ),
                  SizedBox(height: 20),
                  _buildSection(
                    "3. Account Responsibilities",
                    "You are responsible for:\n\n• Maintaining the confidentiality of your account\n• All activities that occur under your account\n• Ensuring your profile information is accurate\n• Notifying us of any unauthorized use",
                  ),
                  SizedBox(height: 20),
                  _buildSection(
                    "4. User Conduct",
                    "You agree NOT to:\n\n• Harass, abuse, or harm other users\n• Upload false or misleading information\n• Use the service for commercial purposes\n• Violate any laws or regulations\n• Share explicit or offensive content\n• Impersonate others or create fake profiles",
                  ),
                  SizedBox(height: 20),
                  _buildSection(
                    "5. Subscription & Payments",
                    "• Subscriptions automatically renew unless cancelled\n• Payments are non-refundable except as required by law\n• We reserve the right to change pricing with notice\n• You can cancel your subscription at any time",
                  ),
                  SizedBox(height: 20),
                  _buildSection(
                    "6. Content Ownership",
                    "• You retain ownership of content you post\n• You grant us a license to use your content\n• We may remove content that violates our terms\n• User-generated content does not reflect our views",
                  ),
                  SizedBox(height: 20),
                  _buildSection(
                    "7. Termination",
                    "We may suspend or terminate your account if you:\n\n• Violate these terms and conditions\n• Engage in fraudulent or illegal activity\n• Harm other users or the platform\n• At our discretion for any reason",
                  ),
                  SizedBox(height: 20),
                  _buildSection(
                    "8. Limitation of Liability",
                    "We are not liable for:\n\n• User conduct or interactions\n• Accuracy of user profiles\n• Any damages arising from use of the service\n• Third-party content or services",
                  ),
                  SizedBox(height: 20),
                  _buildSection(
                    "9. Changes to Terms",
                    "We reserve the right to modify these terms at any time. Continued use of the service constitutes acceptance of modified terms.",
                  ),
                  SizedBox(height: 20),
                  _buildSection(
                    "10. Contact Information",
                    "For questions about these Terms and Conditions:\n\nlegal@datingapp.com",
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.6),
        ),
      ],
    );
  }
}

// Jagged Edge Clipper
class JaggedEdgeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 5);

    int jaggedParts = 150;
    double step = size.width / jaggedParts;

    for (int i = 1; i <= jaggedParts; i++) {
      double x = step * i;
      double y = (i % 2 == 0) ? size.height - 3 : size.height - 7;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
