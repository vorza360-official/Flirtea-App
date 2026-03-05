// Screens/kyc_id_back_screen.dart
import 'dart:io';
import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/controller/kyc_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/screens/kyc_photo_screen.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class KYCIdBackScreen extends StatefulWidget {
  const KYCIdBackScreen({super.key});

  @override
  State<KYCIdBackScreen> createState() => _KYCIdBackScreenState();
}

class _KYCIdBackScreenState extends State<KYCIdBackScreen> {
  final GenderController genderController = Get.find();
  final KYCController kycCtrl = Get.find();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickBack() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      kycCtrl.idBack.value = File(picked.path);
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
              'ID Card (Back)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please upload your ID card below for completing your first\nstep of KYC',
              style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _pickBack,
              child: Obx(
                () => Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                    image: kycCtrl.idBack.value != null
                        ? DecorationImage(
                            image: FileImage(kycCtrl.idBack.value!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: kycCtrl.idBack.value == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Upload ID card back photo',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      genderController.selectedGender.value ==
                                          Gender.male
                                      ? myPurple
                                      : genderController.selectedGender.value ==
                                            Gender.female
                                      ? myBrown
                                      : myYellow,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Text(
                                'Upload +',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Obx(
              () => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: kycCtrl.consentGiven.value,
                    onChanged: (v) => kycCtrl.consentGiven.value = v ?? false,
                    activeColor: const Color(0xFF8B4CB8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'I hereby agree that the above document belongs to me and voluntarily give my consent to Founderweasler Capital Pvt Ltd (Wint Wealth) to utilize it as my address proof for KYC on purpose only',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: kycCtrl.canSubmitBack
                      ? () => Get.to(() => const KYCPhotoScreen())
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        genderController.selectedGender.value == Gender.male
                        ? myPurple
                        : genderController.selectedGender.value == Gender.female
                        ? myBrown
                        : myYellow,
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit',
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
            const Center(
              child: Text(
                'If you are facing any difficulties, please get in touch\nwith us on ',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const Center(
              child: Text(
                'Whatsapp',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8B4CB8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
