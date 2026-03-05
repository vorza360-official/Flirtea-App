import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/controller/profile_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/screens/heightSelectionScreen.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/utils.dart';

class SexualitySelectionScreen extends StatefulWidget {
  @override
  _SexualitySelectionScreenState createState() =>
      _SexualitySelectionScreenState();
}

class _SexualitySelectionScreenState extends State<SexualitySelectionScreen> {
  String selectedSexuality = "Hetero";

  // Map sexuality options to their corresponding images
  final Map<String, String> sexualityImages = {
    "Hetero": "assets/images/hetero.png",
    "Bisexual": "assets/images/bisexual.png",
    "Asexual": "assets/images/asexual.png",
    "Queer": "assets/images/queer.png",
    "Lesbian": "assets/images/lesbian.png",
  };
  final GenderController genderController = Get.find();
  final ProfileController profileCtrl = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedSexuality = profileCtrl.sexuality.value;
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
                        "Chose Your Sexuality",
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
                padding: const EdgeInsets.all(
                  20.0,
                ), // Add padding for better spacing
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
                      "Sexuality",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),

                    SizedBox(height: 15),

                    // Sexuality Options
                    RadioListTile<String>(
                      title: Text("Hetero"),
                      value: "Hetero",
                      groupValue: selectedSexuality,
                      onChanged: (val) {
                        setState(() => selectedSexuality = val!);
                        profileCtrl.sexuality.value = val!;
                      },
                    ),
                    RadioListTile<String>(
                      title: Text("Bisexual"),
                      value: "Bisexual",
                      groupValue: selectedSexuality,
                      onChanged: (val) {
                        setState(() => selectedSexuality = val!);
                        profileCtrl.sexuality.value = val!;
                      },
                    ),
                    RadioListTile<String>(
                      title: Text("Asexual"),
                      value: "Asexual",
                      groupValue: selectedSexuality,
                      onChanged: (val) {
                        setState(() => selectedSexuality = val!);
                        profileCtrl.sexuality.value = val!;
                      },
                    ),
                    RadioListTile<String>(
                      title: Text("Queer"),
                      value: "Queer",
                      groupValue: selectedSexuality,
                      onChanged: (val) {
                        setState(() => selectedSexuality = val!);
                        profileCtrl.sexuality.value = val!;
                      },
                    ),
                    RadioListTile<String>(
                      title: Text("Lesbian"),
                      value: "Lesbian",
                      groupValue: selectedSexuality,
                      onChanged: (val) {
                        setState(() => selectedSexuality = val!);
                        profileCtrl.sexuality.value = val!;
                      },
                    ),

                    // Dynamic Image based on selection
                    Center(
                      child: Image.asset(
                        sexualityImages[selectedSexuality] ??
                            "assets/images/hetero_image.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 15),
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
                          Get.to(() => HeightSelectionScreen());
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

// Jagged Edge Clipper for AppBar
class JaggedEdgeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 5);

    int jaggedParts = 150; // jaggle count
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
