import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SafetyPrivacyScreen extends StatelessWidget {
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
                        "Safety & Privacy",
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

          // Safety Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(
                    "Your Safety is Our Priority",
                    "We're committed to creating a safe and respectful environment for everyone. Here are important safety tips and privacy guidelines.",
                  ),
                  SizedBox(height: 25),

                  _buildSection("🛡️ Safety Tips", ""),
                  SizedBox(height: 10),
                  _buildTip(
                    "Protect Your Personal Information",
                    "Never share your full name, address, financial information, or other sensitive details until you feel comfortable and safe.",
                  ),
                  SizedBox(height: 12),
                  _buildTip(
                    "Meet in Public Places",
                    "For first meetings, always choose public locations during daytime. Let friends or family know where you're going.",
                  ),
                  SizedBox(height: 12),
                  _buildTip(
                    "Trust Your Instincts",
                    "If something feels off or uncomfortable, trust your gut. You can unmatch or block users at any time.",
                  ),
                  SizedBox(height: 12),
                  _buildTip(
                    "Be Cautious of Scams",
                    "Be wary of users asking for money, gift cards, or financial help. Report suspicious behavior immediately.",
                  ),
                  SizedBox(height: 12),
                  _buildTip(
                    "Verify Profile Authenticity",
                    "If something seems too good to be true, it probably is. Watch for fake profiles or catfishing.",
                  ),

                  SizedBox(height: 25),

                  _buildSection("🔒 Privacy Controls", ""),
                  SizedBox(height: 10),
                  _buildPrivacyControl(
                    "Block Users",
                    "Block anyone who makes you uncomfortable. They won't be able to see your profile or contact you.",
                  ),
                  SizedBox(height: 12),
                  _buildPrivacyControl(
                    "Report Abuse",
                    "Report inappropriate behavior, harassment, or violations. We review all reports promptly.",
                  ),
                  SizedBox(height: 12),
                  _buildPrivacyControl(
                    "Control Your Visibility",
                    "Manage who can see your profile and adjust your privacy settings in the app.",
                  ),
                  SizedBox(height: 12),
                  _buildPrivacyControl(
                    "Location Privacy",
                    "We only show approximate location. You can disable location services anytime in settings.",
                  ),

                  SizedBox(height: 25),

                  _buildSection(
                    "⚠️ Report & Block",
                    "If you encounter inappropriate behavior:",
                  ),
                  SizedBox(height: 10),
                  _buildStep("1", "Tap the user's profile"),
                  SizedBox(height: 8),
                  _buildStep("2", "Tap the three dots menu (⋮)"),
                  SizedBox(height: 8),
                  _buildStep("3", "Select 'Report' or 'Block'"),
                  SizedBox(height: 8),
                  _buildStep("4", "Provide details about the issue"),

                  SizedBox(height: 25),

                  _buildSection(
                    "📞 Emergency Support",
                    "If you're in immediate danger, contact local emergency services.\n\nFor safety concerns or support:\nsafety@datingapp.com\n\nWe're here to help 24/7.",
                  ),

                  SizedBox(height: 25),

                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.grey[700]),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Remember: Your safety matters. Don't hesitate to report suspicious activity or reach out for help.",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[800],
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
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

  Widget _buildHeaderSection(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        if (content.isNotEmpty) ...[
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTip(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 2),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyControl(String title, String description) {
    return _buildTip(title, description);
  }

  Widget _buildStep(String number, String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          ),
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
