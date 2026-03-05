// controllers/feed_controller.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FeedController extends GetxController {
  // Observables
  final RxString bio = ''.obs;
  final RxList<String> imageUrls = <String>[].obs;
  final RxBool hasChanges = false.obs;

  // Local files (for editing)
  final List<Rx<File?>> localImages = List.generate(3, (_) => Rx<File?>(null));

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (!doc.exists) return;

    final data = doc.data()!;
    bio.value = data['bio']?.toString() ?? '';
    final urls = data['images'] as List<dynamic>?;
    imageUrls.value = urls?.map((e) => e.toString()).toList() ?? [];
  }

  Future<void> pickImage(int index) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      localImages[index].value = File(picked.path);
      hasChanges.value = true;
    }
  }

  Future<void> updateFeed() async {
    if (!hasChanges.value) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final storageRef = FirebaseStorage.instance.ref('users/${user.uid}/feed');

    List<String> newUrls = List.from(imageUrls);

    // Upload changed images
    for (int i = 0; i < 3; i++) {
      if (localImages[i].value != null) {
        final file = localImages[i].value!;
        final task = await storageRef.child('image_$i.jpg').putFile(file);
        final url = await task.ref.getDownloadURL();
        if (i < newUrls.length) {
          newUrls[i] = url;
        } else {
          newUrls.add(url);
        }
        localImages[i].value = null; // reset
      }
    }

    await ref.update({'bio': bio.value, 'images': newUrls});

    imageUrls.value = newUrls;
    hasChanges.value = false;
    Get.snackbar(
      'Success',
      'Feed updated!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
