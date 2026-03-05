import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FAQScreen extends StatelessWidget {
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
                        "FAQ",
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

          // FAQ Content
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                _buildFAQItem(
                  "How do I create an account?",
                  "To create an account, download the app and sign up using your email, phone number, or social media accounts. Follow the prompts to complete your profile.",
                ),
                SizedBox(height: 15),
                _buildFAQItem(
                  "How does matching work?",
                  "Our app uses advanced algorithms to match you with compatible people based on your preferences, interests, and location. Swipe right to like, left to pass.",
                ),
                SizedBox(height: 15),
                _buildFAQItem(
                  "Can I change my preferences?",
                  "Yes! Go to Settings > General to update your preferences including distance, age range, and other filters at any time.",
                ),
                SizedBox(height: 15),
                _buildFAQItem(
                  "How do I report inappropriate behavior?",
                  "You can report any user by going to their profile, tapping the three dots menu, and selecting 'Report'. We take all reports seriously.",
                ),
                SizedBox(height: 15),
                _buildFAQItem(
                  "What are chips, gifts, and hats?",
                  "These are premium features that enhance your experience. Chips unlock special features, gifts can be sent to matches, and hats are profile decorations.",
                ),
                SizedBox(height: 15),
                _buildFAQItem(
                  "How do I delete my account?",
                  "Go to Settings > General > My Account/ID and tap 'Delete Account'. Please note this action is permanent.",
                ),
                SizedBox(height: 15),
                _buildFAQItem(
                  "Can I use the app on multiple devices?",
                  "Yes, you can log in to your account from multiple devices using the same credentials.",
                ),
                SizedBox(height: 15),
                _buildFAQItem(
                  "How do subscriptions work?",
                  "Subscriptions give you premium features like unlimited swipes, advanced filters, and more. Manage your subscription in Settings > Purchase.",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.only(bottom: 10),
      title: Text(
        question,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      children: [
        Text(
          answer,
          style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
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
