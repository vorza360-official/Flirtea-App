// Controller/lookingfor_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LookingForController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<String> selectedLookingFor = <String>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserLookingFor();
  }

  // Load user's selected looking-for from Firebase
  Future<void> loadUserLookingFor() async {
    try {
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (data.containsKey('LookingFor') && data['LookingFor'] is List) {
          selectedLookingFor.assignAll(List<String>.from(data['LookingFor']));
        }
      }
    } catch (e) {
      print('Error loading looking-for: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle looking-for selection
  void toggleLookingFor(String lookingForTitle) {
    if (selectedLookingFor.contains(lookingForTitle)) {
      selectedLookingFor.remove(lookingForTitle);
    } else {
      selectedLookingFor.add(lookingForTitle);
    }
  }

  // Save selected looking-for to Firebase
  Future<bool> saveLookingFor() async {
    try {
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      await _firestore.collection('users').doc(user.uid).update({
        'LookingFor': selectedLookingFor,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Error saving looking-for: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Remove a looking-for and save immediately
  Future<bool> removeLookingFor(String lookingForTitle) async {
    try {
      if (selectedLookingFor.contains(lookingForTitle)) {
        selectedLookingFor.remove(lookingForTitle);
        return await saveLookingFor();
      }
      return true;
    } catch (e) {
      print('Error removing looking-for: $e');
      // Revert if failed
      if (!selectedLookingFor.contains(lookingForTitle)) {
        selectedLookingFor.add(lookingForTitle);
      }
      return false;
    }
  }

  // Check if a looking-for is selected
  bool isSelected(String lookingForTitle) {
    return selectedLookingFor.contains(lookingForTitle);
  }

  // Clear all selections
  void clearSelections() {
    selectedLookingFor.clear();
  }
}
