import 'package:dating_app/screens/chatListScreen.dart';
import 'package:dating_app/screens/chatScreen.dart';
import 'package:dating_app/screens/feedScreen.dart';
import 'package:dating_app/screens/feedShowingScreen.dart';
import 'package:dating_app/screens/gameScreen.dart';
import 'package:dating_app/screens/profileScreen.dart';
import 'package:dating_app/screens/startingGameScreen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    FeedShowingScreen(),
    ChatListScreen(),
    StatingGameScreen(),
    FeedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],

      // custom jagged nav bar
      bottomNavigationBar: Stack(
        children: [
          Container(height: 30, color: Colors.black),
          ClipPath(
            clipper: JaggedEdgeClipper(), // same jagged style
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.black, width: 2)),
              ),
              child: BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent, // let container color show
                elevation: 0,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.black54,
                currentIndex: _currentIndex,
                onTap: (index) => setState(() => _currentIndex = index),
                items: [
                  BottomNavigationBarItem(
                    icon: Container(
                      height: 40,
                      width: 40,
                      child: Image.asset(
                        _currentIndex == 0
                            ? 'assets/icons/BottomNavIcons/1_filled.png'
                            : 'assets/icons/BottomNavIcons/1.png',
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      height: 40,
                      width: 40,
                      child: Image.asset(
                        _currentIndex == 1
                            ? 'assets/icons/BottomNavIcons/2_filled.png'
                            : 'assets/icons/BottomNavIcons/2.png',
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      height: 40,
                      width: 40,
                      child: Image.asset(
                        _currentIndex == 2
                            ? 'assets/icons/BottomNavIcons/3_filled.png'
                            : 'assets/icons/BottomNavIcons/3.png',
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      height: 40,
                      width: 40,
                      child: Image.asset(
                        _currentIndex == 3
                            ? 'assets/icons/BottomNavIcons/4_filled.png'
                            : 'assets/icons/BottomNavIcons/4.png',
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    label: '',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class JaggedEdgeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);

    // jagged top edge
    int jaggedParts = 150; // adjust density
    double step = size.width / jaggedParts;

    for (int i = 0; i <= jaggedParts; i++) {
      double x = step * i;
      double y = (i % 2 == 0) ? 0 : 6; // height of zigzag
      path.lineTo(x, y);
    }

    // down to bottom edges
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
