import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/auth/auth_services.dart';
import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/const/loadingOverlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  // From Google
  final RxString fullName = ''.obs;
  final RxString email = ''.obs;

  // Fields from screens
  final Rx<Gender?> gender = Rx(null); // Enum from GenderController
  final Rx<DateTime?> dob = Rx(null); // For age calc
  final RxInt age = 0.obs;
  final RxString sexuality = 'Hetero'.obs;
  final RxString height = ''.obs;
  final RxString language = ''.obs;
  final RxString relationshipStatus = 'Single'.obs;
  final RxMap<String, dynamic> location =
      <String, dynamic>{}.obs; // {city, country, lat, lng}
  final RxString bio = ''.obs;
  final List<Rx<File?>> images = List.generate(
    3,
    (_) => Rx(null),
  ); // Up to 3 files

  // Hardcoded lat/lng for locations (real coords)
  final Map<String, Map<String, double>> _locationCoords = {
    'Paris, France': {'lat': 48.856614, 'lng': 2.352222},
    'New York, USA': {'lat': 40.712776, 'lng': -74.005974},
    'London, UK': {'lat': 51.507351, 'lng': -0.127758},
    'Tokyo, Japan': {'lat': 35.689487, 'lng': 139.691711},
    'Berlin, Germany': {'lat': 52.520008, 'lng': 13.404954},
    'Rome, Italy': {'lat': 41.902784, 'lng': 12.496366},
    'Barcelona, Spain': {'lat': 41.385064, 'lng': 2.173404},
    'Amsterdam, Netherlands': {'lat': 52.370216, 'lng': 4.895168},
    'Sydney, Australia': {'lat': -33.868820, 'lng': 151.209296},
    'Toronto, Canada': {'lat': 43.653226, 'lng': -79.383184},
    'Dubai, UAE': {'lat': 25.204849, 'lng': 55.270783},
    'Singapore': {'lat': 1.352083, 'lng': 103.819839},
    'Mumbai, India': {'lat': 19.075989, 'lng': 72.877393},
    'Bangkok, Thailand': {'lat': 13.756331, 'lng': 100.501762},
    'Istanbul, Turkey': {'lat': 41.008238, 'lng': 28.978359},
    'Moscow, Russia': {'lat': 55.755825, 'lng': 37.617298},
    'Buenos Aires, Argentina': {'lat': -34.603684, 'lng': -58.381559},
    'Cairo, Egypt': {'lat': 30.044420, 'lng': 31.235712},
    'Stockholm, Sweden': {'lat': 59.329323, 'lng': 18.068581},
    'Vienna, Austria': {'lat': 48.208174, 'lng': 16.373819},
  };

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    // Auto-fill from auth after sign-in
    final User? user = Get.find<AuthService>().currentUser;
    if (user != null) {
      fullName.value = user.displayName ?? '';
      email.value = user.email ?? '';
    }
  }

  void setLocation(String selected) {
    final parts = selected.split(',').map((p) => p.trim()).toList();
    final city = parts[0];
    final country = parts.length > 1 ? parts[1] : city;
    final coords = _locationCoords[selected] ?? {'lat': 0.0, 'lng': 0.0};
    location.value = {
      'city': city,
      'country': country,
      'lat': coords['lat'],
      'lng': coords['lng'],
    };
  }

  void calculateAge() {
    if (dob.value != null) {
      final now = DateTime.now();
      age.value =
          now.year -
          dob.value!.year -
          ((now.month > dob.value!.month ||
                  (now.month == dob.value!.month && now.day >= dob.value!.day))
              ? 0
              : 1);
    }
  }

  // Helper methods for updating profile
  void updateFullName(String name) {
    fullName.value = name;
  }

  void updateGender(Gender newGender) {
    // Fixed parameter name
    gender.value = newGender; // Fixed: assign to gender.value
  }

  void updateBio(String newBio) {
    bio.value = newBio;
  }

  void updateLocation(String selectedLocation) {
    setLocation(selectedLocation);
  }

  void updateSexuality(String newSexuality) {
    sexuality.value = newSexuality;
  }

  void updateHeight(String newHeight) {
    height.value = newHeight;
  }

  void updateLanguage(String newLanguage) {
    language.value = newLanguage;
  }

  void updateRelationshipStatus(String newStatus) {
    relationshipStatus.value = newStatus;
  }

  void updateDateOfBirth(DateTime newDob) {
    dob.value = newDob;
    calculateAge();
  }

  void updateImage(int index, File? file) {
    if (index >= 0 && index < images.length) {
      images[index].value = file;
    }
  }

  // Method to update profile in Firestore
  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      final user = Get.find<AuthService>().currentUser;
      if (user == null) throw 'No user logged in';

      // Add updated timestamp
      final updatedData = {...data, 'updatedAt': FieldValue.serverTimestamp()};

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(updatedData);
    } catch (e) {
      throw e;
    }
  }

  // Method to get all profile data as Map
  Map<String, dynamic> getProfileData() {
    return {
      'fullName': fullName.value,
      'email': email.value,
      'gender': gender.value?.name ?? '',
      'age': age.value,
      'sexuality': sexuality.value,
      'height': height.value,
      'language': language.value,
      'relationshipStatus': relationshipStatus.value,
      'location': location.value,
      'bio': bio.value,
    };
  }

  // ProfileController.dart - Update the saveProfile method
  Future<void> saveProfile() async {
    LoadingOverlay.show();
    try {
      final User? user = Get.find<AuthService>().currentUser;
      if (user == null) throw 'No user logged in';

      // Get gender from GenderController
      final GenderController genderController = Get.find<GenderController>();
      final Gender? selectedGender = genderController.selectedGender.value;

      // DEBUG: Log user info
      print('User UID: ${user.uid}');
      print('User Email from Auth: ${user.email}');
      print('Email in controller: ${email.value}');
      print('Selected Gender: ${selectedGender?.name}');

      // **CRITICAL FIX: Always use the latest email from Firebase Auth**
      final String userEmail = user.email ?? email.value;
      if (userEmail.isEmpty) {
        throw 'Email is required. Please sign in again.';
      }

      // Upload images and get URLs
      final List<String> imageUrls = [];
      for (int i = 0; i < images.length; i++) {
        final file = images[i].value;
        if (file != null) {
          final ref = FirebaseStorage.instance.ref(
            'users/${user.uid}/image_${i + 1}.jpg',
          );
          await ref.putFile(file);
          final url = await ref.getDownloadURL();
          imageUrls.add(url);
        }
      }

      // Prepare data
      final data = {
        'uid': user.uid,
        'fullName': fullName.value.isNotEmpty
            ? fullName.value
            : user.displayName ?? '',
        'email': userEmail, // **USE THE FETCHED EMAIL**
        'phoneNumber': '',
        'gender': selectedGender?.name ?? gender.value?.name ?? '',
        'age': age.value,
        'sexuality': sexuality.value,
        'height': height.value,
        'language': language.value,
        'relationshipStatus': relationshipStatus.value,
        'location': location.value,
        'bio': bio.value,
        'images': imageUrls,
        'turnOns': [],
        'LookingFor': [],
        'isKYCVerified': false,
        'kycStatus': 'pending',
        'kycSubmittedAt': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isOnline': true,
        'lastSeen': FieldValue.serverTimestamp(),
        'subscriptionPlan': 'free',
        'subscriptionExpiry': null,
      };

      // DEBUG: Log the data being saved
      print('Saving data to Firestore: $data');

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(
            data,
            SetOptions(merge: true),
          ); // **Use merge to avoid overwriting**

      Get.snackbar('Success', 'Profile completed!');
      LoadingOverlay.hide();
      Get.toNamed('/kyc');
    } catch (e) {
      print('Error saving profile: $e');
      Get.snackbar('Error', 'Failed to save profile: $e');
    } finally {
      LoadingOverlay.hide();
    }
  }

  // Method to load profile from Firestore
  Future<void> loadProfile() async {
    try {
      final user = Get.find<AuthService>().currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        // Update all fields from Firestore
        fullName.value = data['fullName']?.toString() ?? '';
        email.value = data['email']?.toString() ?? '';

        // Update gender
        final genderStr = data['gender']?.toString();
        if (genderStr != null && genderStr.isNotEmpty) {
          try {
            gender.value = Gender.values.firstWhere((g) => g.name == genderStr);
          } catch (e) {
            print('Error parsing gender: $e');
          }
        }

        age.value = data['age'] as int? ?? 0;
        sexuality.value = data['sexuality']?.toString() ?? 'Hetero';
        height.value = data['height']?.toString() ?? '';
        language.value = data['language']?.toString() ?? '';
        relationshipStatus.value =
            data['relationshipStatus']?.toString() ?? 'Single';
        bio.value = data['bio']?.toString() ?? '';

        // Update location
        if (data['location'] is Map) {
          location.value = Map<String, dynamic>.from(data['location'] as Map);
        }
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
  }
}
