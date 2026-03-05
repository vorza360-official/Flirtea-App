// utils/loading_overlay.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingOverlay {
  static void show() {
    if (Get.isOverlaysOpen) return;
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  static void hide() {
    if (Get.isOverlaysOpen) Get.back();
  }
}
