import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/auth/auth_services.dart';
import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/controller/profile_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/const/loadingOverlay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatelessWidget {
  final GenderController genderController = Get.find();
  final ProfileController profileCtrl = Get.find();

  // Controllers for form fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController languageController = TextEditingController();

  // Location options (same as your ProfileController)
  final List<String> locationOptions = [
    'Paris, France',
    'New York, USA',
    'London, UK',
    'Tokyo, Japan',
    'Berlin, Germany',
    'Rome, Italy',
    'Barcelona, Spain',
    'Amsterdam, Netherlands',
    'Sydney, Australia',
    'Toronto, Canada',
    'Dubai, UAE',
    'Singapore',
    'Mumbai, India',
    'Bangkok, Thailand',
    'Istanbul, Turkey',
    'Moscow, Russia',
    'Buenos Aires, Argentina',
    'Cairo, Egypt',
    'Stockholm, Sweden',
    'Vienna, Austria',
  ];

  final List<String> sexualityOptions = [
    'Hetero',
    'Bisexual',
    'Asexual',
    'Queer',
    'Lesbian',
  ];

  final List<String> relationshipStatusOptions = ['Single', 'Couple'];

  @override
  Widget build(BuildContext context) {
    // Initialize form fields with current values
    fullNameController.text = profileCtrl.fullName.value;
    bioController.text = profileCtrl.bio.value;
    heightController.text = profileCtrl.height.value;
    languageController.text = profileCtrl.language.value;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom Torn AppBar (same theme as GenderSelectionScreen)
          ClipPath(
            clipper: JaggedEdgeClipper(),
            child: Container(
              color: Colors.black,
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 40,
                left: 16,
                right: 16,
                bottom: 30,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Body Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Email (Non-editable)
                  _buildNonEditableField(
                    label: "Email",
                    value: profileCtrl.email.value,
                    icon: Icons.email,
                  ),
                  SizedBox(height: 20),

                  // Full Name
                  _buildTextField(
                    controller: fullNameController,
                    label: "Full Name",
                    hint: "Enter your full name",
                    icon: Icons.person,
                  ),
                  SizedBox(height: 20),

                  // Gender
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Gender",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Obx(
                        () => Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<Gender>(
                              value: profileCtrl.gender.value,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down),
                              items: Gender.values.map((Gender gender) {
                                return DropdownMenuItem<Gender>(
                                  value: gender,
                                  child: Text(
                                    gender.toString().split('.').last,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                );
                              }).toList(),
                              onChanged: (Gender? newValue) {
                                if (newValue != null) {
                                  profileCtrl.gender.value = newValue;
                                  genderController.setGender(newValue);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Age/Date of Birth
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date of Birth",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Obx(
                        () => InkWell(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today, size: 20),
                                SizedBox(width: 12),
                                Text(
                                  profileCtrl.dob.value != null
                                      ? DateFormat(
                                          'dd/MM/yyyy',
                                        ).format(profileCtrl.dob.value!)
                                      : "Select your date of birth",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: profileCtrl.dob.value != null
                                        ? Colors.black
                                        : Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Obx(
                        () => profileCtrl.age.value > 0
                            ? Text(
                                "Age: ${profileCtrl.age.value} years",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              )
                            : SizedBox(),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Sexuality
                  _buildDropdownField(
                    label: "Sexuality",
                    value: profileCtrl.sexuality.value,
                    options: sexualityOptions,
                    onChanged: (value) {
                      profileCtrl.sexuality.value = value;
                    },
                  ),
                  SizedBox(height: 20),

                  // Height
                  _buildTextField(
                    controller: heightController,
                    label: "Height",
                    hint: "e.g., 5'9\" or 175 cm",
                    icon: Icons.height,
                  ),
                  SizedBox(height: 20),

                  // Language
                  _buildTextField(
                    controller: languageController,
                    label: "Language",
                    hint: "e.g., English, Spanish",
                    icon: Icons.language,
                  ),
                  SizedBox(height: 20),

                  // Relationship Status
                  _buildDropdownField(
                    label: "Relationship Status",
                    value: profileCtrl.relationshipStatus.value,
                    options: relationshipStatusOptions,
                    onChanged: (value) {
                      profileCtrl.relationshipStatus.value = value;
                    },
                  ),
                  SizedBox(height: 20),

                  // Location
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Location",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Obx(
                        () => Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: profileCtrl.location['city'] != null
                                  ? "${profileCtrl.location['city']}, ${profileCtrl.location['country']}"
                                  : null,
                              isExpanded: true,
                              hint: Text("Select your location"),
                              icon: Icon(Icons.arrow_drop_down),
                              items: locationOptions.map((String location) {
                                return DropdownMenuItem<String>(
                                  value: location,
                                  child: Text(location),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  profileCtrl.setLocation(newValue);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Bio
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bio",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: bioController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(12),
                            hintText: "Tell us about yourself...",
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            profileCtrl.bio.value = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  // Update Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        _updateProfile();
                      },
                      child: Text(
                        "Update Profile",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildNonEditableField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Colors.grey[600]),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  value.isNotEmpty ? value : "Not available",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              Icon(Icons.lock_outline, size: 16, color: Colors.grey[500]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              hintText: hint,
              border: InputBorder.none,
              prefixIcon: Icon(icon, size: 20),
            ),
            onChanged: (value) {
              // Update controller value based on field
              if (label.toLowerCase().contains('name')) {
                profileCtrl.fullName.value = value;
              } else if (label.toLowerCase().contains('height')) {
                profileCtrl.height.value = value;
              } else if (label.toLowerCase().contains('language')) {
                profileCtrl.language.value = value;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> options,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down),
              items: options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: profileCtrl.dob.value ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != profileCtrl.dob.value) {
      profileCtrl.dob.value = picked;
      profileCtrl.calculateAge();
    }
  }

  // Update Profile Method
  Future<void> _updateProfile() async {
    LoadingOverlay.show();

    try {
      // Update controllers with latest values from text fields
      profileCtrl.fullName.value = fullNameController.text.trim();
      profileCtrl.bio.value = bioController.text.trim();
      profileCtrl.height.value = heightController.text.trim();
      profileCtrl.language.value = languageController.text.trim();

      // Get current user
      final auth = Get.find<AuthService>();
      final user = auth.currentUser;
      if (user == null) throw 'No user logged in';

      // Prepare updated data
      final updatedData = {
        'fullName': profileCtrl.fullName.value,
        'gender': profileCtrl.gender.value?.name ?? '',
        'age': profileCtrl.age.value,
        'sexuality': profileCtrl.sexuality.value,
        'height': profileCtrl.height.value,
        'language': profileCtrl.language.value,
        'relationshipStatus': profileCtrl.relationshipStatus.value,
        'location': profileCtrl.location.value,
        'bio': profileCtrl.bio.value,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(updatedData);

      LoadingOverlay.hide();

      Get.snackbar(
        'Success',
        'Profile updated successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate back
      Get.back();
    } catch (e) {
      LoadingOverlay.hide();
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

// JaggedEdgeClipper (same as before)
class JaggedEdgeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 5);
    int jaggedParts = 150;
    double step = size.width / jaggedParts;
    for (int i = 1; i <= jaggedParts; i++) {
      double x = step * i;
      double y = (i % 2 == 0) ? size.height - 3 : size.height - 7;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
