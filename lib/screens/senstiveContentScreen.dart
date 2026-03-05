import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SensitiveContentScreen extends StatefulWidget {
  @override
  _SensitiveContentScreenState createState() => _SensitiveContentScreenState();
}

class _SensitiveContentScreenState extends State<SensitiveContentScreen> {
  final GenderController genderController = Get.find();

  // Content filtering options
  String selectedFilter = "Standard"; // Standard, Strict, Off
  bool blurExplicitPhotos = true;
  bool hideExplicitBios = false;
  bool filterLanguage = true;
  bool reportAutomatic = true;

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
                        "Sensitive Content",
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

          // Content
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                // Intro Text
                Text(
                  "Control what type of content you see on the app. These settings help create a more comfortable experience for you.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),

                SizedBox(height: 25),

                // Content Filter Level Section
                _buildSectionHeader("Content Filter Level"),
                SizedBox(height: 15),

                _buildFilterOption(
                  "Strict",
                  "Maximum protection. Hides potentially sensitive photos, bios, and language",
                  "Strict",
                ),
                SizedBox(height: 12),
                _buildFilterOption(
                  "Standard (Recommended)",
                  "Balanced approach. Blurs explicit content but allows you to view if you choose",
                  "Standard",
                ),
                SizedBox(height: 12),
                _buildFilterOption(
                  "Off",
                  "No filtering. You'll see all content without restrictions",
                  "Off",
                ),

                SizedBox(height: 30),

                // Custom Settings Section
                _buildSectionHeader("Custom Settings"),
                SizedBox(height: 15),

                _buildToggleOption(
                  "Blur Explicit Photos",
                  "Photos flagged as explicit will be blurred. Tap to view",
                  blurExplicitPhotos,
                  (value) => setState(() => blurExplicitPhotos = value),
                ),

                SizedBox(height: 15),

                _buildToggleOption(
                  "Hide Explicit Bios",
                  "Profile bios with explicit language will be hidden",
                  hideExplicitBios,
                  (value) => setState(() => hideExplicitBios = value),
                ),

                SizedBox(height: 15),

                _buildToggleOption(
                  "Filter Strong Language",
                  "Replace profanity and strong language with asterisks",
                  filterLanguage,
                  (value) => setState(() => filterLanguage = value),
                ),

                SizedBox(height: 15),

                _buildToggleOption(
                  "Auto-Report Violations",
                  "Automatically report profiles that violate community guidelines",
                  reportAutomatic,
                  (value) => setState(() => reportAutomatic = value),
                ),

                SizedBox(height: 30),

                // What's Considered Sensitive Section
                _buildSectionHeader("What's Considered Sensitive?"),
                SizedBox(height: 15),

                _buildInfoItem("Nudity or partial nudity"),
                _buildInfoItem("Sexual or suggestive content"),
                _buildInfoItem("Explicit language in bios or messages"),
                _buildInfoItem("Content that violates community guidelines"),

                SizedBox(height: 25),

                // Important Note Box
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange[800],
                        size: 22,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Important",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[900],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "These filters aren't perfect. If you see inappropriate content, please report it. Sharing explicit content is against our Terms of Service.",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.orange[900],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25),

                // Report Button
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      // Navigate to report screen
                    },
                    icon: Icon(Icons.flag_outlined, color: Colors.red[700]),
                    label: Text(
                      "Report Inappropriate Content",
                      style: TextStyle(
                        color: Colors.red[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey[600],
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildFilterOption(String title, String description, String value) {
    bool isSelected = selectedFilter == value;

    return GestureDetector(
      onTap: () => setState(() => selectedFilter = value),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              genderController.selectedGender.value ==
                                  Gender.male
                              ? myPurple
                              : genderController.selectedGender.value ==
                                    Gender.female
                              ? myBrown
                              : myYellow,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleOption(
    String title,
    String description,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: genderController.selectedGender.value == Gender.male
              ? myPurple
              : genderController.selectedGender.value == Gender.female
              ? myBrown
              : myYellow,
        ),
      ],
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
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
          SizedBox(width: 12),
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
