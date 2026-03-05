import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/screens/CommunityGuidelinesScreen.dart';
import 'package:dating_app/screens/FAQScreen.dart';
import 'package:dating_app/screens/TermsConditionsScreen.dart';
import 'package:dating_app/screens/notificationScreen.dart';
import 'package:dating_app/screens/paymentScreen.dart';
import 'package:dating_app/screens/privacyPolicyScreen.dart';
import 'package:dating_app/screens/restorePurchases.dart';
import 'package:dating_app/screens/safetyPrivacyScreen.dart';
import 'package:dating_app/screens/senstiveContentScreen.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isNotifsEnabled = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final GenderController genderController = Get.find();

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
                        "Settings",
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

          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Colors.black,
              indicatorWeight: 2,
              tabs: [
                Tab(text: "Purchase"),
                Tab(text: "General"),
                Tab(text: "Info"),
              ],
            ),
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPurchaseTab(),
                _buildGeneralTab(),
                _buildInfoTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseTab() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSettingsItem("No Chips", "BUY", Colors.purple),
          SizedBox(height: 20),
          _buildSettingsItem("No Gifts", "BUY", Colors.purple),
          SizedBox(height: 20),
          _buildSettingsItem("No Hats", "SWITCH ON", Colors.purple),
          SizedBox(height: 30),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentPlansScreen()),
              );
            },
            child: _buildPlainSettingsItem("Subscription Management"),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RestorePurchaseScreen(),
                ),
              );
            },
            child: _buildPlainSettingsItem("Restore Purchase"),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralTab() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => AccountModal(),
              );
            },
            child: Text(
              "MY ACCOUNT/ID",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
                letterSpacing: 1,
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildGeneralSettingsItem("THEME", "AUTO", Colors.purple),
          SizedBox(height: 15),
          _buildGeneralSettingsItem("METRICS IN", "KM, CM", Colors.purple),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
            },
            child: _buildPlainSettingsItem("NOTIFICATIONS"),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SensitiveContentScreen(),
                ),
              );
            },
            child: _buildPlainSettingsItem("SENSITIVE CONTENT"),
          ),
          SizedBox(height: 20),
          _buildGeneralSettingsItem("BLOCKLIST", "EMPTY", Colors.purple),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),

          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FAQScreen()),
              );
            },
            child: _buildPlainSettingsItem("FAQ"),
          ),
          SizedBox(height: 20),

          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
              );
            },
            child: _buildPlainSettingsItem("PRIVACY POLICY"),
          ),
          SizedBox(height: 20),

          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TermsConditionsScreen(),
                ),
              );
            },
            child: _buildPlainSettingsItem("TERMS AND CONDITIONS"),
          ),
          SizedBox(height: 20),

          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SafetyPrivacyScreen()),
              );
            },
            child: _buildPlainSettingsItem("SAFETY AND PRIVACY"),
          ),
          SizedBox(height: 20),

          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommunityGuidelinesScreen(),
                ),
              );
            },
            child: _buildPlainSettingsItem("COMMUNITY GUIDELINES"),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    String title,
    String buttonText,
    Color buttonColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(title, style: TextStyle(fontSize: 16, color: Colors.black)),
        Text(
          buttonText,
          style: TextStyle(
            color: Colors.purpleAccent,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildGeneralSettingsItem(
    String title,
    String value,
    Color valueColor,
  ) {
    return Row(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPlainSettingsItem(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Modal Bottom Sheet for Account/ID
class AccountModal extends StatelessWidget {
  final GenderController genderController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 80,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 20),
          Divider(color: Colors.black, height: 0.5),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "MY ACCOUNT/ID",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "example@gmail.com",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  "Account ID",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(width: 10),
                Icon(Icons.copy, size: 16, color: Colors.grey[600]),
              ],
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => LeaveConfirmationModal(),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    side: BorderSide(color: Colors.grey[400]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Delete Account",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        genderController.selectedGender.value == Gender.male
                        ? myPurple
                        : genderController.selectedGender.value == Gender.female
                        ? myBrown
                        : myYellow,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "LOGOUT",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Leave Confirmation Modal
class LeaveConfirmationModal extends StatelessWidget {
  final GenderController genderController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 80,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 20),
          Divider(color: Colors.black, height: 0.5),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "ARE YOU SURE ABOUT LEAVING?",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "You will be missed. If you are certain you wanna leave, don't forget to CANCEL SUBSCRIPTION",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      genderController.selectedGender.value == Gender.male
                      ? myPurple
                      : genderController.selectedGender.value == Gender.female
                      ? myBrown
                      : myYellow,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Delete Account",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
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
