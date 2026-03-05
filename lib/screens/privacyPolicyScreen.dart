import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatelessWidget {
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
                        "Privacy Policy",
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

          // Privacy Policy Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Last Updated: January 2026",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildSection(
                    "1. Information We Collect",
                    "We collect information you provide directly to us, including:\n\n• Account information (name, email, phone number)\n• Profile information (photos, bio, preferences)\n• Usage data (interactions, matches, messages)\n• Location data (when you grant permission)\n• Device information (device type, operating system)",
                  ),
                  SizedBox(height: 20),
                  _buildSection(
                    "2. How We Use Your Information",
                    "We use the information we collect to:\n\n• Provide and improve our services\n• Create and maintain your account\n• Connect you with potential matches\n• Send you notifications and updates\n• Ensure safety and security\n• Comply with legal obligations",
                  ),
                  SizedBox(height: 20),
                  _buildSection(
                    "3. Information Sharing",
                    "We do not sell your personal information. We may share your information:\n\n• With other users (profile information, messages)\n• With service providers who help operate our platform\n• When required by law or to protect rights and safety\n• In connection with business transfers or mergers",
                  ),
                  SizedBox(height: 20),
                  _buildSection(
                    "4. Your Privacy Rights",
                    "You have the right to:\n\n• Access your personal information\n• Update or correct your data\n• Delete your account and data\n• Opt-out of certain data collection\n• Control your privacy settings\n• Withdraw consent at any time",
                  ),
                  SizedBox(height: 20),
                  _buildSection(
                    "5. Data Security",
                    "We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.",
                  ),
                  SizedBox(height: 20),
                  _buildSection(
                    "6. Data Retention",
                    "We retain your information for as long as your account is active or as needed to provide services. You may request deletion of your data at any time.",
                  ),
                  SizedBox(height: 20),
                  _buildSection(
                    "7. Contact Us",
                    "If you have questions about this Privacy Policy, please contact us at:\n\nprivacy@datingapp.com",
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
