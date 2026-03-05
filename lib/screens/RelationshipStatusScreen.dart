import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/controller/profile_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/screens/locationSelectionScreen.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class RelationshipStatusScreen extends StatefulWidget {
  @override
  _RelationshipStatusScreenState createState() =>
      _RelationshipStatusScreenState();
}

class _RelationshipStatusScreenState extends State<RelationshipStatusScreen> {
  String selectedStatus = "Single";
  final GenderController genderController = Get.find();
  final ProfileController profileCtrl = Get.find();

  // Map relationship status to their corresponding images
  Map<String, String> get statusImages {
    return {
      "Single": genderController.selectedGender.value == Gender.male
          ? "assets/images/single.png"
          : genderController.selectedGender.value == Gender.female
          ? "assets/images/female/single.png"
          : "assets/images/nonBinary/single.png",
      "Couple": genderController.selectedGender.value == Gender.male
          ? "assets/images/couple.png"
          : genderController.selectedGender.value == Gender.female
          ? "assets/images/female/couple.png"
          : "assets/images/nonBinary/couple.png",
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedStatus = profileCtrl.relationshipStatus.value;
  }

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
                        "What Is Your Relationship Status",
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

          // Body Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tell Us About Yourself",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "Open, honest dating without shame",
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 25),

                    Text(
                      "Relationship Status",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),

                    SizedBox(height: 15),

                    // Relationship Status Options with Custom Radio Design
                    GestureDetector(
                      onTap: () {
                        setState(() => selectedStatus = "Single");
                        profileCtrl.relationshipStatus.value = "Single";
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selectedStatus == "Single"
                                    ? myPurple
                                    : Colors.transparent,
                                border: Border.all(
                                  color: selectedStatus == "Single"
                                      ? myPurple
                                      : Colors.grey[400]!,
                                  width: 2,
                                ),
                              ),
                              child: selectedStatus == "Single"
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : null,
                            ),
                            SizedBox(width: 16),
                            Text(
                              "Single",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        setState(() => selectedStatus = "Couple");
                        profileCtrl.relationshipStatus.value = "Couple";
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selectedStatus == "Couple"
                                    ? myPurple
                                    : Colors.transparent,
                                border: Border.all(
                                  color: selectedStatus == "Couple"
                                      ? myPurple
                                      : Colors.grey[400]!,
                                  width: 2,
                                ),
                              ),
                              child: selectedStatus == "Couple"
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : null,
                            ),
                            SizedBox(width: 16),
                            Text(
                              "Couple",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Dynamic Image based on selection
                    Center(
                      child: Container(
                        height: 300,
                        child: Image.asset(
                          statusImages[selectedStatus] ??
                              "assets/images/single.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Next Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              genderController.selectedGender.value ==
                                  Gender.male
                              ? myPurple
                              : genderController.selectedGender.value ==
                                    Gender.female
                              ? myBrown
                              : myYellow,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // Navigate to next screen
                          Get.to(() => LocationSelectionScreen());
                        },
                        child: Text(
                          "Next",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Jagged Edge Clipper for AppBar (reusing from your existing code)
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
