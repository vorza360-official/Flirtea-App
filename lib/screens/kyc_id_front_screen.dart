// Screens/kyc_id_front_screen.dart
import 'dart:io';
import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/controller/kyc_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/screens/kyc_id_back_screen.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class KYCIdFrontScreen extends StatefulWidget {
  const KYCIdFrontScreen({super.key});

  @override
  State<KYCIdFrontScreen> createState() => _KYCIdFrontScreenState();
}

class _KYCIdFrontScreenState extends State<KYCIdFrontScreen> {
  final TextEditingController _idNumberController = TextEditingController();
  final GenderController genderController = Get.find();
  final KYCController kycCtrl = Get.find();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _idNumberController.text = kycCtrl.idNumber.value;
    _idNumberController.addListener(() {
      kycCtrl.idNumber.value = _idNumberController.text;
    });
  }

  Future<void> _pickFront() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      kycCtrl.idFront.value = File(picked.path);
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
              'ID Card (Front)',
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
            const SizedBox(height: 30),
            const Text(
              'ID Card Number',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _idNumberController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF8B4CB8)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _pickFront,
              child: Obx(
                () => Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                    image: kycCtrl.idFront.value != null
                        ? DecorationImage(
                            image: FileImage(kycCtrl.idFront.value!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: kycCtrl.idFront.value == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Upload ID card front photo',
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
            const Spacer(),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: kycCtrl.canSubmitFront
                      ? () => Get.to(() => const KYCIdBackScreen())
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

  @override
  void dispose() {
    _idNumberController.dispose();
    super.dispose();
  }
}
