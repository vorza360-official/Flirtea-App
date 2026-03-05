import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';

class PaymentPlansScreen extends StatefulWidget {
  const PaymentPlansScreen({super.key});

  @override
  State<PaymentPlansScreen> createState() => _PaymentPlansScreenState();
}

class _PaymentPlansScreenState extends State<PaymentPlansScreen> {
  int? selectedPlan;
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: SingleChildScrollView(
      child: Column(
        spacing: 3,
        children: [
          _buildCustomHeader(),
          Container(
                height: 200,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 0, right: 20),
                  child: Row(
                    children: [
                      _buildPlanCard(
                        title: "1 Week",
                        price: "p299",
                        subtitle: "p299/week",
                        index: 0,
                        isSelected: selectedPlan == 0,
                      ),
                      SizedBox(width: 15),
                      _buildPlanCard(
                        title: "1 Month",
                        price: "p699",
                        subtitle: "p699/month",
                        index: 1,
                        isSelected: selectedPlan == 1,
                      ),
                    ],
                  ),
                ),
              ),
          _buildOptionItem(
            icon: "assets/icons/fire_icon.png",
            title: "Personal Information",
            subtitle: "Lorem ipsum dolor sit amet.",
          ),
          SizedBox(height: 15),
          _buildOptionItem(
            icon: "assets/icons/fire_icon.png",
            title: "Payment & Subscription",
            subtitle: "Lorem ipsum dolor sit amet.",
          ),
          SizedBox(height: 15),
          _buildOptionItem(
            icon: "assets/icons/fire_icon.png",
            title: "Notification Setting",
            subtitle: "Lorem ipsum dolor sit amet.",
          ),
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.purpleAccent.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "All subscriptions renew automatically until you cancel them at least 24 hours before the end of the paid period.",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                SizedBox(height: 8),
                Text(
                  "Account will be charged for subscription renewal within 24 hours.",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          // Buy Button
          Container(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                print(
                  "Purchasing ${selectedPlan == 0 ? '1 Week' : '1 Month'} plan",
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: myPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Buy For ${selectedPlan == 0 ? '299' : '699'}\$",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 20), // Bottom padding
        ],
      ),
    ),
  );
}

  Widget _buildCustomHeader() {
    return Container(
      height: 260,
      child: Stack(
        children: [
          // Main Background Image
          Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/headerMainBg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Top Icons (Settings and Images)

          // Inner Header with Profile Info
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 250,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg2.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: -20,
            child: Container(
              child: Image.asset("assets/images/bg3.png", fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required String subtitle,
    required int index,
    required bool isSelected,
    String? saveText,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = index;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.78, // Show partial second card
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected? Colors.transparent : myPurple ,
            width: 4,
          ),
          borderRadius: BorderRadius.circular(15),
          color: Colors.black,
        ),
        child: Stack(
          children: [
            // Background image when selected
            if (isSelected)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Image.asset(
                    'assets/images/planSelected.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            
            // Check mark when selected
            if (isSelected)
              Positioned(
                top: 15,
                right: 15,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            
            // Save badge
            if (saveText != null)
              Positioned(
                top: 15,
                right: 15,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    saveText,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            
            // Plan content
            Positioned(
              bottom: 30,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    price,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required String icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: myPurple.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Image.asset(icon,),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
        ],
      ),
    );
  }
}

class FlamePainter extends CustomPainter {
  final Color color;

  FlamePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // Create flame-like shape starting from bottom right
    path.moveTo(size.width, size.height);
    path.lineTo(size.width * 0.6, size.height);

    // Create wavy flame pattern
    path.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.8,
      size.width * 0.65,
      size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.6,
      size.width * 0.7,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.4,
      size.width * 0.75,
      size.height * 0.3,
    );
    path.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.2,
      size.width * 0.8,
      size.height * 0.1,
    );
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.05, size.width, 0);

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
