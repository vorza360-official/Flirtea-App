// Screens/kyc_photo_screen.dart
import 'dart:io';
import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/controller/kyc_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/screens/kyc_completed_screen.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class KYCPhotoScreen extends StatefulWidget {
  const KYCPhotoScreen({super.key});

  @override
  State<KYCPhotoScreen> createState() => _KYCPhotoScreenState();
}

class _KYCPhotoScreenState extends State<KYCPhotoScreen> {
  final GenderController genderController = Get.find();
  final KYCController kycCtrl = Get.find();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickSelfie() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (picked != null) {
      kycCtrl.selfie.value = File(picked.path);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'KYC Verification',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Take a Selfie',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hold your phone at eye level and take a clear selfie',
              style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _pickSelfie,
              child: Obx(
                () => Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                    image: kycCtrl.selfie.value != null
                        ? DecorationImage(
                            image: FileImage(kycCtrl.selfie.value!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: kycCtrl.selfie.value == null
                      ? const Center(
                          child: Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.grey,
                          ),
                        )
                      : null,
                ),
              ),
            ),
            const Spacer(),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: kycCtrl.canSubmitSelfie
                      ? () async {
                          await kycCtrl.submitKYC();
                          Get.off(() => KYCCompletedScreen());
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        genderController.selectedGender.value == Gender.male
                        ? myPurple
                        : genderController.selectedGender.value == Gender.female
                        ? myBrown
                        : myYellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit KYC',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
