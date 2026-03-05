// controllers/gender_controller.dart
import 'package:dating_app/models/gender.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GenderController extends GetxController {
  var selectedGender = Rx<Gender?>(null);

  final storage = GetStorage();

  void setGender(Gender gender) {
    selectedGender.value = gender;
    storage.write('selected_gender', gender.toString());
  }

  Color get selectedColor {
    switch (selectedGender.value) {
      case Gender.female:
        return const Color(0xFF8B4513);
      case Gender.nonBinary:
        return Colors.purple;
      case Gender.male:
      default:
        return const Color(0xFF800080);
    }
  }

  LinearGradient get lgbtqGradient {
    return const LinearGradient(
      colors: [
        Color(0xFFE40303),
        Color(0xFFFF8C00),
        Color(0xFFFFED00),
        Color(0xFF008018),
        Color(0xFF0000FF),
        Color(0xFF8B00FF),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
  }

  @override
  void onInit() {
    super.onInit();
    String? stored = storage.read('selected_gender');
    if (stored != null) {
      selectedGender.value = Gender.values.firstWhere(
        (g) => g.toString() == stored,
        orElse: () => Gender.male,
      );
    }
  }
}
