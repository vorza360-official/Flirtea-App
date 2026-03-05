// controllers/kyc_controller.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/screens/HomeScreen.dart';
import 'package:dating_app/const/loadingOverlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KYCController extends GetxController {
  // Observables
  final RxString idNumber = ''.obs;
  final Rx<File?> idFront = Rx(null);
  final Rx<File?> idBack = Rx(null);
  final Rx<File?> selfie = Rx(null);
  final RxBool consentGiven = false.obs;

  // Validation
  bool get canSubmitFront => idNumber.value.isNotEmpty && idFront.value != null;
  bool get canSubmitBack => idBack.value != null && consentGiven.value;
  bool get canSubmitSelfie => selfie.value != null;

  // Upload & Save
  Future<void> submitKYC() async {
    if (!canSubmitSelfie) return;

    LoadingOverlay.show();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'No user logged in';

      final storageRef = FirebaseStorage.instance.ref('users/${user.uid}/kyc');
      final urls = await Future.wait([
        _uploadFile(storageRef.child('id_front.jpg'), idFront.value!),
        _uploadFile(storageRef.child('id_back.jpg'), idBack.value!),
        _uploadFile(storageRef.child('selfie.jpg'), selfie.value!),
      ]);

      final kycData = {
        'idCardFrontUrl': urls[0],
        'idCardBackUrl': urls[1],
        'selfieUrl': urls[2],
        'submittedAt': FieldValue.serverTimestamp(),
        'verifiedBy': '',
        'verificationNotes': '',
        'status': 'pending',
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('kyc')
          .add(kycData);

      LoadingOverlay.hide();
      Get.snackbar(
        'Success',
        'Your KYC details are submitted successfully. Wait until it gets approved.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAll(() => HomeScreen());
    } catch (e) {
      LoadingOverlay.hide();
      Get.snackbar(
        'Error',
        'Submission failed: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<String> _uploadFile(Reference ref, File file) async {
    final task = await ref.putFile(file);
    return await task.ref.getDownloadURL();
  }
}
