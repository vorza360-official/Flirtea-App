import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/controller/profile_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ageSelectorScreen.dart';

class GenderSelectionScreen extends StatelessWidget {
  final GenderController genderController = Get.find();
  final ProfileController profileCtrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom Torn AppBar (unchanged)
          ClipPath(
            clipper: JaggedEdgeClipper(),
            child: Container(
              color: Colors.black,
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
                        "Chose Your Gender",
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
            child: Padding(
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
                    "Your Gender",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 15),

                  // Gender Options with custom styling
                  Obx(
                    () => Theme(
                      data: Theme.of(context).copyWith(
                        radioTheme: RadioThemeData(
                          fillColor: MaterialStateProperty.resolveWith<Color>((
                            states,
                          ) {
                            if (states.contains(MaterialState.selected)) {
                              return genderController.selectedColor;
                            }
                            return Colors.grey;
                          }),
                        ),
                      ),
                      child: Column(
                        children: [
                          RadioListTile<Gender>(
                            title: Text("Male"),
                            value: Gender.male,
                            groupValue: genderController.selectedGender.value,
                            onChanged: (val) {
                              genderController.setGender(val!);
                              profileCtrl.gender.value = val!;
                            },
                          ),
                          RadioListTile<Gender>(
                            title: Text("Female"),
                            value: Gender.female,
                            groupValue: genderController.selectedGender.value,
                            onChanged: (val) {
                              genderController.setGender(val!);
                              profileCtrl.gender.value = val!;
                            },
                          ),
                          Container(
                            decoration:
                                genderController.selectedGender.value ==
                                    Gender.nonBinary
                                ? BoxDecoration(
                                    gradient: genderController.lgbtqGradient,
                                    borderRadius: BorderRadius.circular(8),
                                  )
                                : null,
                            child:
                                genderController.selectedGender.value ==
                                    Gender.nonBinary
                                ? Container(
                                    margin: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: RadioListTile<Gender>(
                                      title: ShaderMask(
                                        shaderCallback: (bounds) =>
                                            genderController.lgbtqGradient
                                                .createShader(bounds),
                                        child: Text(
                                          "Non-Binary",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      value: Gender.nonBinary,
                                      groupValue:
                                          genderController.selectedGender.value,
                                      onChanged: (val) =>
                                          genderController.setGender(val!),
                                      activeColor: Colors.purple,
                                    ),
                                  )
                                : RadioListTile<Gender>(
                                    title: Text("Non-Binary"),
                                    value: Gender.nonBinary,
                                    groupValue:
                                        genderController.selectedGender.value,
                                    onChanged: (val) =>
                                        genderController.setGender(val!),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Placeholder for Gender Image (you'll handle assets)
                  Expanded(
                    child: Obx(
                      () => Center(
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          child: Container(
                            key: ValueKey(
                              genderController.selectedGender.value,
                            ),
                            // Replace with your asset logic based on genderController.selectedGender.value
                            child: Image.asset(
                              genderController.selectedGender.value ==
                                      Gender.male
                                  ? "assets/images/male.png"
                                  : genderController.selectedGender.value ==
                                        Gender.female
                                  ? "assets/images/female.png"
                                  : "assets/images/non_binary.png",
                            ),
                            // child: Text(
                            //   'Gender Image Placeholder (${genderController.selectedGender.value?.toString() ?? "None"})',
                            //   style: TextStyle(fontSize: 16),
                            // ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Dynamic Next Button
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      child:
                          genderController.selectedGender.value ==
                              Gender.nonBinary
                          ? Container(
                              decoration: BoxDecoration(
                                gradient: genderController.lgbtqGradient,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  if (profileCtrl.gender.value != null) {
                                    // Optional validation
                                    Get.to(() => AgeSelectionScreen());
                                  } else {
                                    Get.snackbar('Error', 'Select gender');
                                  }
                                },
                                child: Text(
                                  "Next",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: genderController.selectedColor,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Get.to(() => AgeSelectionScreen());
                              },
                              child: Text(
                                "Next",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// JaggedEdgeClipper (unchanged)
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
