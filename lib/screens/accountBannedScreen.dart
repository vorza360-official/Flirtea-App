import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AccountBannedScreen extends StatefulWidget {
  const AccountBannedScreen({super.key});

  @override
  State<AccountBannedScreen> createState() => _AccountBannedScreenState();
}

class _AccountBannedScreenState extends State<AccountBannedScreen> {
  @override
  void initState() {
    super.initState();
    // Show bottom sheet after the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showAccountBannedBottomSheet();
    });
  }

  void _showAccountBannedBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAccountBannedBottomSheet(),
    );
  }
  final GenderController genderController = Get.find();
  Widget _buildAccountBannedBottomSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            // Account banned image
            Container(
              height: 260,
              child: Image.asset(
                height: 300,
                width: 300,
                genderController.selectedGender.value == Gender.male?
                        "assets/images/bannedImage.png":
                        genderController.selectedGender.value == Gender.female ?
                        "assets/images/female/bannedImage.png":
                        "assets/images/nonBinary/bannedImage.png",
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback widget if image doesn't load
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple.shade400,
                          Colors.purple.shade600,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
            
            // Title
            const Text(
              'YOU\'VE BEEN BANNED',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            
            
            // Subtitle
            const Text(
              'We received a lot of reports on you, so we\'ve blocked your account forever!\n\nRead AURE COMMUNITY GUIDELINES.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            
            // User ID section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your User ID',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    // Copy functionality
                    Clipboard.setData(const ClipboardData(text: "Copy it"));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User ID copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text(
                    'Copy it',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            
            // Add bottom padding for safe area
            //SizedBox(height: MediaQuery.of(context).padding.bottom + 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg1.png"), // your image
            fit: BoxFit.cover, // cover whole screen
          ),
        ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(),
        ),
      ),
    );
  }
}