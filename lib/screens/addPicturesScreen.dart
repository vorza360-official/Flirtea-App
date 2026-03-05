// Screens/addPicturesScreen.dart
import 'package:dating_app/controller/profile_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/screens/kycVerificationscreen.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UploadPicturesScreen extends StatefulWidget {
  @override
  _UploadPicturesScreenState createState() => _UploadPicturesScreenState();
}

class _UploadPicturesScreenState extends State<UploadPicturesScreen> {
  final ProfileController profileCtrl = Get.find();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(int index) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      maxHeight: 1000,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      profileCtrl.images[index].value = File(pickedFile.path);
      setState(() {});
    }
  }

  Widget _buildImageUploadCard(int imageNumber, File? image) {
    return Container(
      width: (MediaQuery.of(context).size.width - 60) / 3,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black38, width: 1),
      ),
      child: Column(
        children: [
          // Image number indicator
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text(
                  "  $imageNumber/3",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
              ],
            ),
          ),

          // Image or upload area
          Expanded(
            child: Container(
              width: double.infinity,
              child: image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(12),
                      ),
                      child: Image.file(
                        image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 32, color: Colors.grey[400]),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            "Upload +",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Custom Torn AppBar
            ClipPath(
              clipper: JaggedEdgeClipper(),
              child: Container(
                color: profileCtrl.gender.value == Gender.nonBinary
                    ? myPurple
                    : Colors.black,
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
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Upload Your Pictures",
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Photos",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    "Please upload your Photos for post",
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 25),

                  // Image Upload Cards Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 10,
                      children: [
                        GestureDetector(
                          onTap: () => _pickImage(0),
                          child: Obx(
                            () => _buildImageUploadCard(
                              1,
                              profileCtrl.images[0].value,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _pickImage(1),
                          child: Obx(
                            () => _buildImageUploadCard(
                              2,
                              profileCtrl.images[1].value,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _pickImage(2),
                          child: Obx(
                            () => _buildImageUploadCard(
                              3,
                              profileCtrl.images[2].value,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40),

                  // Upload Illustration
                  Center(
                    child: Image.asset(
                      profileCtrl.gender.value == Gender.male
                          ? "assets256/images/upload_image.png"
                          : profileCtrl.gender.value == Gender.female
                          ? "assets/images/female/upload_image.png"
                          : "assets/images/nonBinary/upload_image.png",
                      fit: BoxFit.contain,
                      height: 300,
                    ),
                  ),

                  SizedBox(height: 60),

                  // Publish Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            profileCtrl.gender.value == Gender.nonBinary
                            ? myPurple
                            : myPurple,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        await profileCtrl.saveProfile();
                        Get.to(() => KYCVerificationScreen());
                      },
                      child: Text(
                        "Publish In Feed",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),

                  // Bottom safe area
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Jagged Edge Clipper for AppBar
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
