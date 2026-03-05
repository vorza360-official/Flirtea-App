// Screens/languageSelectionScreen.dart
import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/controller/profile_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/screens/RelationshipStatusScreen.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? selectedLanguage;
  final GenderController genderController = Get.find();
  final ProfileController profileCtrl = Get.find();

  // All values are UNIQUE
  final List<String> languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Russian',
    'Chinese (Mandarin)',
    'Japanese',
    'Korean',
    'Arabic',
    'Hindi',
    'Urdu',
    'Dutch',
    'Swedish',
    'Norwegian',
    'Turkish',
    'Greek',
    'Hebrew',
    'Thai',
  ];

  @override
  void initState() {
    super.initState();
    selectedLanguage = profileCtrl.language.value.isEmpty
        ? null
        : profileCtrl.language.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
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
                          "Chose Your Language",
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tell Us About Yourself",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    "Open, honest dating without shame",
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 25),
                  Text(
                    "Language Spoken",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Select your Language",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),

                  // Language Dropdown - NOW SAFE
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedLanguage,
                        hint: Text(
                          "Select language...",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                        ),
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey[600],
                        ),
                        // Ensure items is NEVER null or empty
                        items: languages.map((String language) {
                          return DropdownMenuItem<String>(
                            value: language,
                            child: Text(
                              language,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLanguage = newValue;
                          });
                          profileCtrl.language.value = newValue ?? '';
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Selected Language Chip
                  if (selectedLanguage != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: myPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: myPurple.withOpacity(0.3)),
                      ),
                      child: Text(
                        selectedLanguage!,
                        style: TextStyle(
                          color: myPurple,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                  SizedBox(height: 40),

                  // Language Image
                  Center(
                    child: Image.asset(
                      genderController.selectedGender.value == Gender.male
                          ? "assets/images/language.png"
                          : genderController.selectedGender.value ==
                                Gender.female
                          ? "assets/images/female/language.png"
                          : "assets/images/nonBinary/language.png",
                      fit: BoxFit.contain,
                      height: 400,
                    ),
                  ),

                  SizedBox(height: 40),

                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            genderController.selectedGender.value == Gender.male
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
                      onPressed: selectedLanguage != null
                          ? () => Get.to(() => RelationshipStatusScreen())
                          : null,
                      child: Text(
                        "Next",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                ],
              ),
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
