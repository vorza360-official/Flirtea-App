import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/controller/profile_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/screens/addPicturesScreen.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BioSelectionScreen extends StatefulWidget {
  @override
  _BioSelectionScreenState createState() => _BioSelectionScreenState();
}

class _BioSelectionScreenState extends State<BioSelectionScreen> {
  TextEditingController bioController = TextEditingController();
  final GenderController genderController = Get.find();
  final ProfileController profileCtrl = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bioController.text = profileCtrl.bio.value;
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
                          "Write Something About Yourself",
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
                    "Bio/About",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),

                  SizedBox(height: 15),

                  // Bio Input Label
                  Text(
                    "Write a short bio or tagline",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),

                  // Bio Input Field
                  TextField(
                    controller: bioController,
                    maxLines: 2,
                    maxLength: 500,
                    decoration: InputDecoration(
                      hintText: "Write here...",
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: myPurple, width: 2),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      counterStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Bio Image
                  Center(
                    child: Image.asset(
                      genderController.selectedGender.value == Gender.male
                          ? "assets/images/bio_image.png"
                          : genderController.selectedGender.value ==
                                Gender.female
                          ? "assets/images/female/bio_image.png"
                          : "assets/images/nonBinary/bio_image.png",
                      fit: BoxFit.contain,
                      height: 300,
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
                      onPressed: () {
                        profileCtrl.bio.value = bioController.text;
                        Get.to(() => UploadPicturesScreen());
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),

                  // Bottom safe area
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

// Jagged Edge Clipper for AppBar (same as your height screen)
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
