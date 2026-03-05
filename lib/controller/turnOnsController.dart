// Controller/turnons_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class TurnOnsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<String> selectedTurnOns = <String>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserTurnOns();
  }

  // Load user's selected turn-ons from Firebase
  Future<void> loadUserTurnOns() async {
    try {
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (data.containsKey('turnOns') && data['turnOns'] is List) {
          selectedTurnOns.assignAll(List<String>.from(data['turnOns']));
        }
      }
    } catch (e) {
      print('Error loading turn-ons: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle turn-on selection
  void toggleTurnOn(String turnOnTitle) {
    if (selectedTurnOns.contains(turnOnTitle)) {
      selectedTurnOns.remove(turnOnTitle);
    } else {
      selectedTurnOns.add(turnOnTitle);
    }
  }

  // Save selected turn-ons to Firebase
  Future<bool> saveTurnOns() async {
    try {
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      await _firestore.collection('users').doc(user.uid).update({
        'turnOns': selectedTurnOns,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Error saving turn-ons: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Remove a turn-on and save immediately
  Future<bool> removeTurnOn(String turnOnTitle) async {
    try {
      if (selectedTurnOns.contains(turnOnTitle)) {
        selectedTurnOns.remove(turnOnTitle);
        return await saveTurnOns();
      }
      return true;
    } catch (e) {
      print('Error removing turn-on: $e');
      // Revert if failed
      if (!selectedTurnOns.contains(turnOnTitle)) {
        selectedTurnOns.add(turnOnTitle);
      }
      return false;
    }
  }

  // Check if a turn-on is selected
  bool isSelected(String turnOnTitle) {
    return selectedTurnOns.contains(turnOnTitle);
  }

  // Clear all selections
  void clearSelections() {
    selectedTurnOns.clear();
  }
}
