import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/auth/auth_services.dart';
import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/screens/HomeScreen.dart';
import 'package:dating_app/screens/LoginScreen.dart';
import 'package:dating_app/screens/genderScreen.dart';
import 'package:dating_app/screens/kycVerificationscreen.dart';
import 'package:dating_app/models/gender.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();
    final genderCtrl = Get.find<GenderController>();

    return StreamBuilder<User?>(
      stream: authService.userStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return WelcomeScreen();
        }

        final user = snapshot.data!;
        final uid = user.uid;

        // SYNC GENDER FROM FIRESTORE IF NOT IN LOCAL STORAGE
        return FutureBuilder<void>(
          future: _syncGenderIfNeeded(genderCtrl, uid),
          builder: (context, syncSnap) {
            if (syncSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // Now gender is 100% loaded → Safe to build any screen
            return _buildUserFlow(uid);
          },
        );
      },
    );
  }

  Future<void> _syncGenderIfNeeded(
    GenderController genderCtrl,
    String uid,
  ) async {
    // If already in GetStorage → skip
    if (genderCtrl.selectedGender.value != null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        final genderStr = doc.data()?['gender'] as String?;
        if (genderStr != null && genderStr.isNotEmpty) {
          final gender = Gender.values.firstWhere(
            (g) => g.toString() == 'Gender.$genderStr',
            orElse: () => Gender.male,
          );
          genderCtrl.setGender(gender); // This saves to GetStorage too
        }
      }
    } catch (e) {
      print('Gender sync failed: $e');
    }
  }

  Widget _buildUserFlow(String uid) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
      builder: (context, profileSnap) {
        if (profileSnap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!profileSnap.hasData) {
          return GenderSelectionScreen();
        }

        final data = profileSnap.data!.data() as Map<String, dynamic>?;

        // If no document exists, go to gender screen
        if (data == null) {
          return GenderSelectionScreen();
        }

        // **IMPROVED PROFILE COMPLETE CHECK**
        // Check for critical required fields
        final hasRequiredFields =
            (data['email']?.toString().isNotEmpty == true) &&
            (data['fullName']?.toString().isNotEmpty == true) &&
            (data['gender']?.toString().isNotEmpty == true) &&
            (data['age'] != null && data['age'] > 0);

        // Debug logging
        print('Profile check for UID: $uid');
        print('Has email: ${data['email']?.toString().isNotEmpty}');
        print('Has fullName: ${data['fullName']?.toString().isNotEmpty}');
        print('Has gender: ${data['gender']?.toString().isNotEmpty}');
        print('Has age: ${data['age'] != null && data['age'] > 0}');
        print('Profile complete: $hasRequiredFields');

        if (!hasRequiredFields) {
          return GenderSelectionScreen();
        }

        return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('kyc')
              .limit(1)
              .get(),
          builder: (context, kycSnap) {
            if (kycSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final hasKyc = kycSnap.hasData && kycSnap.data!.docs.isNotEmpty;

            if (!hasKyc) {
              return const KYCVerificationScreen();
            }

            return HomeScreen();
          },
        );
      },
    );
  }
}
