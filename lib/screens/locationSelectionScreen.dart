import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/controller/profile_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/screens/bioSelectionScreen.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationSelectionScreen extends StatefulWidget {
  @override
  _LocationSelectionScreenState createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  String? selectedLocation;

  final List<String> locations = [
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
  final GenderController genderController = Get.find();
  final ProfileController profileCtrl = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (profileCtrl.location.value.isNotEmpty) {
      selectedLocation =
          '${profileCtrl.location['city']}, ${profileCtrl.location['country']}';
    }
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
                          "Chose Your Location",
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
                    "Tell Us About Yourself",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    "Open, honest dating without shame",
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 25),

                  Text(
                    "Location",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),

                  SizedBox(height: 15),

                  // Location Selection Label
                  Text(
                    "Please set your location to get your post publish",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),

                  // Location Dropdown
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedLocation,
                        hint: Text(
                          "Paris, France",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                        ),
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey[600],
                        ),
                        items: locations.map((String location) {
                          return DropdownMenuItem<String>(
                            value: location,
                            child: Text(
                              location,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLocation = newValue;
                            if (newValue != null)
                              profileCtrl.setLocation(newValue);
                          });
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Selected Location Display (optional)
                  if (selectedLocation != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: myPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: myPurple.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on, color: myPurple, size: 16),
                          SizedBox(width: 4),
                          Text(
                            selectedLocation!,
                            style: TextStyle(
                              color: myPurple,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 40),

                  // Location Image
                  Center(
                    child: Image.asset(
                      genderController.selectedGender.value == Gender.male
                          ? "assets/images/location_image.png"
                          : genderController.selectedGender.value ==
                                Gender.female
                          ? "assets/images/female/location_image.png"
                          : "assets/images/nonBinary/location_image.png",
                      fit: BoxFit.contain,
                      height: 400,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback if image doesn't load
                        return Container(
                          height: 400,
                          child: Icon(
                            Icons.location_on,
                            size: 200,
                            color: myPurple.withOpacity(0.3),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 40),

                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            genderController.selectedGender.value == Gender.male
                            ? myPurple
                            : genderController.selectedGender.value ==
                                  Gender.female
                            ? myBrown
                            : myYellow,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: selectedLocation != null
                          ? () {
                              // Navigate to next screen
                              Get.to(() => BioSelectionScreen());
                              //print("Selected Location: $selectedLocation");
                            }
                          : null,
                      child: Text(
                        "Next",
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

// Jagged Edge Clipper for AppBar (same as your language screen)
class JaggedEdgeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 5);

    int jaggedParts = 150; // jaggle count
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
