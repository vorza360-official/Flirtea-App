import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final GenderController genderController = Get.find();

  // Notification toggles
  bool pushNotifications = true;
  bool newMatches = true;
  bool messages = true;
  bool likes = true;
  bool superLikes = false;
  bool profileVisits = true;
  bool promotionsOffers = false;
  bool appUpdates = true;
  bool vibration = true;
  bool sound = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom Torn AppBar
          ClipPath(
            clipper: JaggedEdgeClipper(),
            child: Container(
              color: genderController.selectedGender.value == Gender.male
                  ? Colors.black
                  : genderController.selectedGender.value == Gender.female
                  ? Colors.black
                  : myPurple,
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
                        "Notifications",
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

          // Notifications Content
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                // Master Toggle
                _buildMasterToggle(),

                SizedBox(height: 25),

                // Activity Notifications Section
                _buildSectionHeader("Activity Notifications"),
                SizedBox(height: 15),
                _buildNotificationToggle(
                  "New Matches",
                  "Get notified when you have a new match",
                  newMatches,
                  (value) => setState(() => newMatches = value),
                ),
                SizedBox(height: 15),
                _buildNotificationToggle(
                  "Messages",
                  "Get notified about new messages",
                  messages,
                  (value) => setState(() => messages = value),
                ),
                SizedBox(height: 15),
                _buildNotificationToggle(
                  "Likes",
                  "Get notified when someone likes you",
                  likes,
                  (value) => setState(() => likes = value),
                ),
                SizedBox(height: 15),
                _buildNotificationToggle(
                  "Super Likes",
                  "Get notified when someone super likes you",
                  superLikes,
                  (value) => setState(() => superLikes = value),
                ),
                SizedBox(height: 15),
                _buildNotificationToggle(
                  "Profile Visits",
                  "Get notified when someone visits your profile",
                  profileVisits,
                  (value) => setState(() => profileVisits = value),
                ),

                SizedBox(height: 30),

                // App Notifications Section
                _buildSectionHeader("App Notifications"),
                SizedBox(height: 15),
                _buildNotificationToggle(
                  "Promotions & Offers",
                  "Receive special offers and promotions",
                  promotionsOffers,
                  (value) => setState(() => promotionsOffers = value),
                ),
                SizedBox(height: 15),
                _buildNotificationToggle(
                  "App Updates",
                  "Get notified about new features and updates",
                  appUpdates,
                  (value) => setState(() => appUpdates = value),
                ),

                SizedBox(height: 30),

                // Notification Settings Section
                _buildSectionHeader("Notification Settings"),
                SizedBox(height: 15),
                _buildNotificationToggle(
                  "Vibration",
                  "Vibrate when receiving notifications",
                  vibration,
                  (value) => setState(() => vibration = value),
                ),
                SizedBox(height: 15),
                _buildNotificationToggle(
                  "Sound",
                  "Play sound when receiving notifications",
                  sound,
                  (value) => setState(() => sound = value),
                ),

                SizedBox(height: 30),

                // Info Box
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.grey[700],
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "You can also manage notification settings from your device settings",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMasterToggle() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: pushNotifications
            ? Colors.black.withOpacity(0.05)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: pushNotifications
              ? Colors.black.withOpacity(0.2)
              : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            pushNotifications
                ? Icons.notifications_active
                : Icons.notifications_off,
            color: pushNotifications ? Colors.black : Colors.grey[600],
            size: 28,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Push Notifications",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  pushNotifications ? "Enabled" : "Disabled",
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Switch(
            value: pushNotifications,
            onChanged: (value) => setState(() => pushNotifications = value),
            activeColor: genderController.selectedGender.value == Gender.male
                ? myPurple
                : genderController.selectedGender.value == Gender.female
                ? myBrown
                : myYellow,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey[600],
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildNotificationToggle(
    String title,
    String description,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: pushNotifications ? onChanged : null,
          activeColor: genderController.selectedGender.value == Gender.male
              ? myPurple
              : genderController.selectedGender.value == Gender.female
              ? myBrown
              : myYellow,
        ),
      ],
    );
  }
}

// Jagged Edge Clipper
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
