import 'package:dating_app/auth/auth_services.dart';
import 'package:dating_app/controller/feed_controller.dart';
import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/controller/kyc_controller.dart';
import 'package:dating_app/controller/lookingForController.dart';
import 'package:dating_app/controller/profile_controller.dart';
import 'package:dating_app/controller/turnOnsController.dart';
import 'package:dating_app/screens/HomeScreen.dart';
import 'package:dating_app/screens/SplashScreen.dart';
import 'package:dating_app/screens/feedShowingScreen.dart';
import 'package:dating_app/screens/paymentScreen.dart';
import 'package:dating_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthService());
  Get.put(ProfileController());
  Get.put(KYCController());
  Get.put(GenderController());
  Get.put(FeedController());
  Get.put(TurnOnsController());
  Get.put(LookingForController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(GenderController());
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashScreen(),
    );
  }
}
