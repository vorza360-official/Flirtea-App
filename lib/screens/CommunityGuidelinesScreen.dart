import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityGuidelinesScreen extends StatelessWidget {
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
                        "Community Guidelines",
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

          // Community Guidelines Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(
                    "Building a Respectful Community",
                    "Our community thrives on respect, authenticity, and kindness. These guidelines help create a positive experience for everyone.",
                  ),
                  SizedBox(height: 25),

                  _buildSection("✅ Do's - What We Encourage", ""),
                  SizedBox(height: 10),
                  _buildGuideline(
                    "Be Yourself",
                    "Use real photos and honest information. Authenticity helps create meaningful connections.",
                  ),
                  SizedBox(height: 12),
                  _buildGuideline(
                    "Treat Others with Respect",
                    "Be kind and courteous. Remember there's a real person behind every profile.",
                  ),
                  SizedBox(height: 12),
                  _buildGuideline(
                    "Communicate Clearly",
                    "Be honest about your intentions and expectations from the start.",
                  ),
                  SizedBox(height: 12),
                  _buildGuideline(
                    "Report Issues",
                    "Help us maintain a safe community by reporting inappropriate behavior.",
                  ),
                  SizedBox(height: 12),
                  _buildGuideline(
                    "Respect Boundaries",
                    "If someone isn't interested, respect their decision and move on gracefully.",
                  ),

                  SizedBox(height: 25),

                  _buildSection("❌ Don'ts - What's Not Allowed", ""),
                  SizedBox(height: 10),
                  _buildProhibition(
                    "Harassment & Hate Speech",
                    "No bullying, threats, or discriminatory language based on race, religion, gender, sexual orientation, or any other characteristic.",
                  ),
                  SizedBox(height: 12),
                  _buildProhibition(
                    "Explicit Content",
                    "No nudity, sexually explicit content, or solicitation. Keep conversations appropriate.",
                  ),
                  SizedBox(height: 12),
                  _buildProhibition(
                    "Fake Profiles & Catfishing",
                    "Don't impersonate others or use misleading photos. Be authentic.",
                  ),
                  SizedBox(height: 12),
                  _buildProhibition(
                    "Spam & Commercial Activity",
                    "No promotional content, advertising, or using the platform for business purposes.",
                  ),
                  SizedBox(height: 12),
                  _buildProhibition(
                    "Scams & Fraud",
                    "Never ask for money, gift cards, or financial information. Report suspicious activity.",
                  ),
                  SizedBox(height: 12),
                  _buildProhibition(
                    "Minor Safety Violations",
                    "Absolutely no content involving minors. Users must be 18+.",
                  ),
                  SizedBox(height: 12),
                  _buildProhibition(
                    "Violence & Illegal Activity",
                    "No threats of violence, promotion of illegal activities, or dangerous behavior.",
                  ),

                  SizedBox(height: 25),

                  _buildSection(
                    "⚡ Consequences",
                    "Violating these guidelines may result in:",
                  ),
                  SizedBox(height: 10),
                  _buildConsequence("Warning issued to your account"),
                  _buildConsequence("Temporary suspension of services"),
                  _buildConsequence("Permanent account termination"),
                  _buildConsequence(
                    "Reporting to law enforcement (serious violations)",
                  ),

                  SizedBox(height: 25),

                  _buildSection(
                    "🤝 Our Commitment",
                    "We're committed to:\n\n• Reviewing all reports within 24 hours\n• Maintaining user privacy during investigations\n• Taking appropriate action against violations\n• Continuously improving our safety measures\n• Supporting victims of harassment or abuse",
                  ),

                  SizedBox(height: 25),

                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.gavel, color: Colors.black, size: 20),
                            SizedBox(width: 8),
                            Text(
                              "Zero Tolerance Policy",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          "We have zero tolerance for harassment, hate speech, violence, or content involving minors. Such violations result in immediate permanent ban.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[800],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  _buildSection(
                    "📧 Questions or Concerns?",
                    "If you have questions about these guidelines or need to report a violation:\n\ncommunity@datingapp.com",
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

  Widget _buildGuideline(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 2),
          child: Icon(Icons.check_circle, color: Colors.green[600], size: 20),
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

  Widget _buildProhibition(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 2),
          child: Icon(Icons.cancel, color: Colors.red[600], size: 20),
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

  Widget _buildConsequence(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8, left: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
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
