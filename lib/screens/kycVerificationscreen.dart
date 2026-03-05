import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/screens/kyc_id_front_screen.dart';
import 'package:dating_app/screens/sexualityTypeScreen.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/utils.dart';

class KYCVerificationScreen extends StatefulWidget {
  const KYCVerificationScreen({super.key});

  @override
  State<KYCVerificationScreen> createState() => _KYCVerificationScreenState();
}

class _KYCVerificationScreenState extends State<KYCVerificationScreen> {
  @override
  void initState() {
    super.initState();
    // Show bottom sheet after the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showKYCVerificationBottomSheet();
    });
  }

  void _showKYCVerificationBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildKYCVerificationBottomSheet(),
    );
  }

  Widget _buildKYCVerificationBottomSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: [
            // Left image - kyc01.png
            Row(
              children: [
                Container(
                  height: 160,
                  child: Image.asset(
                    width: 130,
                    genderController.selectedGender.value == Gender.male?
                        "assets/images/kyc01.png":
                        genderController.selectedGender.value == Gender.female ?
                        "assets/images/female/kyc01.png":
                        "assets/images/nonBinary/kyc01.png",
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
                Spacer(),
                Container(
              height: 220,
              child: Image.asset(
                height: 260,
                genderController.selectedGender.value == Gender.male?
                        "assets/images/kyc02.png":
                        genderController.selectedGender.value == Gender.female ?
                        "assets/images/female/kyc02.png":
                        "assets/images/nonBinary/kyc02.png",
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
              ],
            ),

            // Right image - kyc02.png
            
            
            // Title
            const Text(
              'Complete Your KYC Verification',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            
            // Subtitle
            const Text(
              'Complete your KYC verification to securely confirm your identity. This step confirms your identity and activates full access to our services.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
                        
            // Start Verification button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Handle KYC verification start
                  Get.to(() => KYCIdFrontScreen());
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
                  'Start Verification',
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
  final GenderController genderController = Get.find();
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
            ),
          fit: BoxFit.cover,
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