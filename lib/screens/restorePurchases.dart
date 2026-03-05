import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestorePurchaseScreen extends StatefulWidget {
  @override
  _RestorePurchaseScreenState createState() => _RestorePurchaseScreenState();
}

class _RestorePurchaseScreenState extends State<RestorePurchaseScreen> {
  final GenderController genderController = Get.find();

  bool isRestoring = false;
  bool hasRestored = false;
  List<RestoredItem> restoredItems = [];

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
                        "Restore Purchase",
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

          // Content
          Expanded(
            child: hasRestored ? _buildRestoredView() : _buildInitialView(),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialView() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 20),

          // Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.restore,
              size: 50,
              color: genderController.selectedGender.value == Gender.male
                  ? myPurple
                  : genderController.selectedGender.value == Gender.female
                  ? myBrown
                  : myYellow,
            ),
          ),

          SizedBox(height: 30),

          // Title
          Text(
            "Restore Your Purchases",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 15),

          // Description
          Text(
            "If you've previously purchased premium features, subscriptions, or in-app items, you can restore them here.",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 30),

          // Info boxes
          _buildInfoBox(
            Icons.check_circle_outline,
            "What gets restored?",
            "Premium subscriptions, purchased chips, gifts, hats, and other in-app purchases linked to your account.",
          ),

          SizedBox(height: 15),

          _buildInfoBox(
            Icons.info_outline,
            "When to restore?",
            "Restore your purchases if you reinstalled the app, switched devices, or your purchases are not showing.",
          ),

          SizedBox(height: 15),

          _buildInfoBox(
            Icons.security_outlined,
            "Safe & Secure",
            "Your purchases are securely linked to your Apple ID or Google Play account.",
          ),

          Spacer(),

          // Restore Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isRestoring ? null : _restorePurchases,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    genderController.selectedGender.value == Gender.male
                    ? myPurple
                    : genderController.selectedGender.value == Gender.female
                    ? myBrown
                    : myYellow,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: isRestoring
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      "Restore Purchases",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),

          SizedBox(height: 15),

          // Help text
          TextButton(
            onPressed: () {
              // Navigate to FAQ or support
            },
            child: Text(
              "Need help? Contact Support",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),

          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildRestoredView() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 20),

          // Success Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green[50],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle, size: 60, color: Colors.green[600]),
          ),

          SizedBox(height: 25),

          // Success Title
          Text(
            restoredItems.isEmpty
                ? "No Purchases Found"
                : "Purchases Restored!",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 12),

          // Success Description
          Text(
            restoredItems.isEmpty
                ? "We couldn't find any previous purchases associated with your account."
                : "Your purchases have been successfully restored to your account.",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 30),

          // Restored Items List
          if (restoredItems.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "RESTORED ITEMS",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                  letterSpacing: 1,
                ),
              ),
            ),
            SizedBox(height: 15),
            ...restoredItems.map((item) => _buildRestoredItem(item)).toList(),
          ],

          Spacer(),

          // Done Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    genderController.selectedGender.value == Gender.male
                    ? myPurple
                    : genderController.selectedGender.value == Gender.female
                    ? myBrown
                    : myYellow,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                "Done",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildInfoBox(IconData icon, String title, String description) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: genderController.selectedGender.value == Gender.male
                ? myPurple
                : genderController.selectedGender.value == Gender.female
                ? myBrown
                : myYellow,
            size: 24,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestoredItem(RestoredItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green[50],
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: Colors.green[600], size: 20),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  item.description,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: Colors.green[600], size: 22),
        ],
      ),
    );
  }

  void _restorePurchases() async {
    setState(() {
      isRestoring = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    // Mock restored items (replace with actual restore logic)
    setState(() {
      isRestoring = false;
      hasRestored = true;
      // Example: Add restored items or leave empty if none found
      restoredItems = [
        RestoredItem(
          name: "Premium Subscription",
          description: "Active until Dec 31, 2026",
          icon: Icons.star,
        ),
        RestoredItem(
          name: "500 Chips Pack",
          description: "In-app currency",
          icon: Icons.monetization_on,
        ),
        RestoredItem(
          name: "Special Gifts Bundle",
          description: "5 premium gifts",
          icon: Icons.card_giftcard,
        ),
      ];
      // For no purchases found, use: restoredItems = [];
    });
  }
}

// Model for restored items
class RestoredItem {
  final String name;
  final String description;
  final IconData icon;

  RestoredItem({
    required this.name,
    required this.description,
    required this.icon,
  });
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
