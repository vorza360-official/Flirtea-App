import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/screens/sexualityTypeScreen.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/utils.dart';

class AgeConfirmingScreen extends StatefulWidget {
  const AgeConfirmingScreen({super.key});

  @override
  State<AgeConfirmingScreen> createState() => _AgeConfirmingScreenState();
}

class _AgeConfirmingScreenState extends State<AgeConfirmingScreen> {

  final GenderController genderController = Get.find();
  @override
  void initState() {
    super.initState();
    // Show bottom sheet after the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showAgeConfirmationBottomSheet();
    });
  }

  void _showAgeConfirmationBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAgeConfirmationBottomSheet(),
    );
  }

  Widget _buildAgeConfirmationBottomSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            // Age confirmation image
            Container(
              height: 260,
              child: Image.asset(
                height: 300,
                width: 300,
                genderController.selectedGender.value == Gender.male?
                        "assets/images/age_confirmation.png":
                        genderController.selectedGender.value == Gender.female ?
                        "assets/images/female/age_confirmation.png":
                        "assets/images/nonBinary/age_confirmation.png",
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback widget if image doesn't load
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple.shade400,
                          Colors.purple.shade600,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
            
            // Title
            const Text(
              'Are You 18?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            
            
            // Subtitle
            const Text(
              'Make Sure Your Age is Correct? You Won\'t Be Able To Change It Later',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            
            
            // That's Right button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Handle age confirmation
                  Get.to(()=> SexualitySelectionScreen()); // Close bottom sheet
                  // Add your navigation logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: genderController.selectedGender.value == Gender.male?
                        myPurple:
                        genderController.selectedGender.value == Gender.female ?
                        myBrown:
                        myYellow,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'That\'s Right',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),            
            // Cancel button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton(
                onPressed: () {
                  // Handle cancel
                  Navigator.pop(context); // Close bottom sheet
                  // Add your navigation logic here
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: genderController.selectedGender.value == Gender.male?
                        myPurple:
                        genderController.selectedGender.value == Gender.female ?
                        myBrown:
                        myYellow,
                  side: BorderSide(
                    color: genderController.selectedGender.value == Gender.male?
                        myPurple:
                        genderController.selectedGender.value == Gender.female ?
                        myBrown:
                        myYellow,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            // Add bottom padding for safe area
            //SizedBox(height: MediaQuery.of(context).padding.bottom + 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                genderController.selectedGender.value == Gender.male?
                        "assets/images/bg1.png":
                        genderController.selectedGender.value == Gender.female ?
                        "assets/images/female/bg1.png":
                        "assets/images/nonBinary/bg1.png"
              ), // your image
            fit: BoxFit.cover, // cover whole screen
          ),
        ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(),
        ),
      ),
    );
  }
}