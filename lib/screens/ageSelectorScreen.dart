import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/controller/profile_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/screens/ageConfirmationScreen.dart';
import 'package:dating_app/screens/sexualityTypeScreen.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/utils.dart';

class AgeSelectionScreen extends StatefulWidget {
  @override
  _AgeSelectionScreenState createState() => _AgeSelectionScreenState();
}

class _AgeSelectionScreenState extends State<AgeSelectionScreen> {
  DateTime? selectedDate;
  bool hideAge = false;
  TextEditingController dateController = TextEditingController();
  final GenderController genderController = Get.find();
  final ProfileController profileCtrl = Get.find();
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
              color: genderController.selectedGender.value == Gender.nonBinary
                  ? myPurple
                  : Colors.black,
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
                        "What Is Your Age",
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
                    "Your Age",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),

                  SizedBox(height: 15),

                  // Date of Birth Section
                  Text(
                    "Date of Birth",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),

                  // Date Picker Field
                  GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime(2000),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary:
                                    genderController.selectedGender.value ==
                                        Gender.male
                                    ? myPurple
                                    : genderController.selectedGender.value ==
                                          Gender.female
                                    ? myBrown
                                    : myYellow,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null && picked != selectedDate) {
                        setState(() {
                          selectedDate = picked;
                          dateController.text =
                              "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                        });
                        profileCtrl.dob.value = picked; // Set DOB
                        profileCtrl.calculateAge();
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dateController.text.isEmpty
                                ? "dd/mm/yyyy"
                                : dateController.text,
                            style: TextStyle(
                              fontSize: 16,
                              color: dateController.text.isEmpty
                                  ? Colors.grey[500]
                                  : Colors.black,
                            ),
                          ),
                          Icon(
                            Icons.calendar_today,
                            color:
                                genderController.selectedGender.value ==
                                    Gender.male
                                ? myPurple
                                : genderController.selectedGender.value ==
                                      Gender.female
                                ? myBrown
                                : myYellow,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Hide My Age Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hide My Age",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Switch(
                        value: hideAge,
                        onChanged: (value) {
                          setState(() {
                            hideAge = value;
                          });
                        },
                        activeColor:
                            genderController.selectedGender.value == Gender.male
                            ? myPurple
                            : genderController.selectedGender.value ==
                                  Gender.female
                            ? myBrown
                            : myYellow,
                      ),
                    ],
                  ),

                  // Image placeholder - you'll update this
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        genderController.selectedGender.value == Gender.male
                            ? "assets/images/dateofbirth_image.png"
                            : genderController.selectedGender.value ==
                                  Gender.female
                            ? "assets/images/female/dateofbirth_image.png"
                            : "assets/images/nonBinary/dateofbirth_image.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

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
                        if (profileCtrl.dob.value != null) {
                          Get.to(
                            () => AgeConfirmingScreen(),
                          ); // Assume confirms, then next
                        } else {
                          Get.snackbar('Error', 'Select DOB');
                        }
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
