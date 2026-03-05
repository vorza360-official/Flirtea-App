// Screens/feedScreen.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/controller/feed_controller.dart';
import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/screens/avatarSelectionScreen.dart';
import 'package:dating_app/screens/settingsScreen.dart';
import 'package:dating_app/widgets/lookingForTabWidget.dart';
import 'package:dating_app/widgets/turnOnTabWidget.dart';
import 'package:dating_app/const/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late FeedController feedCtrl = Get.find();
  final GenderController genderCtrl = Get.find();

  // Header data
  String city = '';
  String genderSexuality = '';
  String age = '';
  String? selectedAvatar;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadHeaderData();
    feedCtrl = Get.find<FeedController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      feedCtrl.loadUserData();
    });
  }

  Future<void> _loadHeaderData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (!doc.exists) return;

    final data = doc.data()!;
    setState(() {
      city = data['city']?.toString() ?? 'Unknown';
      final g = data['gender']?.toString() ?? 'male';
      final s = data['sexuality']?.toString() ?? 'Queer';
      genderSexuality = '${g.capitalizeFirst}, $s';
      age = '${data['age'] ?? 0} Years';
      selectedAvatar = data['selectedAvatar'];
    });
  }

  Future<void> _openAvatarSelection() async {
    final result = await Get.to(() => AvatarSelectionScreen());
    if (result != null) {
      setState(() {
        selectedAvatar = result;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildCustomHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBioTab(),
                _buildPhotosTab(),
                TurnOnTabWidget(),
                LookingForTabWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Container(
      height: 300,
      child: Stack(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  genderCtrl.selectedGender.value == Gender.male
                      ? "assets/images/headerMainBg.png"
                      : genderCtrl.selectedGender.value == Gender.female
                      ? "assets/images/female/headerMainBg.png"
                      : "assets/images/nonBinary/headerMainBg.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Get.to(() => SettingsScreen()),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                InkWell(
                  onTap: _openAvatarSelection,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            child: Container(
              height: 250,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/headerSecondBg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '1 day of joining Endating',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      city,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      genderSexuality,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      age,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Become a Aura Queen',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Avatar Display (now using selected avatar from assets)
          Positioned(
            left: 0,
            right: 0,
            top: 50,
            child: Center(
              child: GestureDetector(
                onTap: _openAvatarSelection,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    color: Colors.grey[200],
                  ),
                  child: ClipOval(
                    child: selectedAvatar != null
                        ? Image.asset(
                            selectedAvatar!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildDefaultAvatar();
                            },
                          )
                        : _buildDefaultAvatar(),
                  ),
                ),
              ),
            ),
          ),
          // Edit Avatar Icon
          Positioned(
            left: 0,
            right: 0,
            top: 110,
            child: Center(
              child: GestureDetector(
                onTap: _openAvatarSelection,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: genderCtrl.selectedGender.value == Gender.male
                        ? myPurple
                        : genderCtrl.selectedGender.value == Gender.female
                        ? myBrown
                        : myYellow,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(Icons.edit, color: Colors.white, size: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.grey[300],
      child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
    );
  }

  Widget _buildTabBar() {
    final color = genderCtrl.selectedGender.value == Gender.male
        ? myPurple
        : genderCtrl.selectedGender.value == Gender.female
        ? myBrown
        : myYellow;

    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: color,
        unselectedLabelColor: Colors.grey,
        indicatorColor: color,
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: 'Bio'),
          Tab(text: 'Photos'),
          Tab(text: 'Turn-Ons'),
          Tab(text: 'Looking For'),
        ],
      ),
    );
  }

  Widget _buildBioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Write a short bio or tagline",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Obx(
            () => TextField(
              controller: TextEditingController(text: feedCtrl.bio.value)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: feedCtrl.bio.value.length),
                ),
              onChanged: (v) {
                feedCtrl.bio.value = v;
                feedCtrl.hasChanges.value = true;
              },
              maxLines: 2,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: "Write here...",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 11),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: myPurple, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                counterStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ),
          ),
          Center(
            child: Image.asset(
              genderCtrl.selectedGender.value == Gender.male
                  ? "assets/images/bio_image2.png"
                  : genderCtrl.selectedGender.value == Gender.female
                  ? "assets/images/female/bio_image2.png"
                  : "assets/images/nonBinary/bio_image2.png",
              height: 300,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 40),
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      genderCtrl.selectedGender.value == Gender.male
                      ? myPurple
                      : genderCtrl.selectedGender.value == Gender.female
                      ? myBrown
                      : myYellow,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: feedCtrl.hasChanges.value
                    ? () async {
                        await feedCtrl.updateFeed();
                      }
                    : null,
                child: Text(
                  feedCtrl.hasChanges.value
                      ? "Update Your Feed"
                      : "Publish In Feed",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }

  Widget _buildPhotosTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Please upload your Photos for post",
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 8),
          Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(3, (i) {
                  final url = i < feedCtrl.imageUrls.length
                      ? feedCtrl.imageUrls[i]
                      : null;
                  final file = feedCtrl.localImages[i].value;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => feedCtrl.pickImage(i),
                      child: _buildImageCard(i + 1, file, url),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      genderCtrl.selectedGender.value == Gender.male
                      ? myPurple
                      : genderCtrl.selectedGender.value == Gender.female
                      ? myBrown
                      : myYellow,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: feedCtrl.hasChanges.value
                    ? () async {
                        await feedCtrl.updateFeed();
                      }
                    : null,
                child: Text(
                  feedCtrl.hasChanges.value
                      ? "Update Your Feed"
                      : "Publish In Feed",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }

  Widget _buildImageCard(int number, File? localFile, String? networkUrl) {
    return Container(
      width: (MediaQuery.of(context).size.width - 60) / 3,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black38, width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text(
                  "  $number/3",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          Expanded(
            child: localFile != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                    child: Image.file(
                      localFile,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                : networkUrl != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                    child: Image.network(
                      networkUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.error, color: Colors.red, size: 30),
                        );
                      },
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 32, color: Colors.grey[400]),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
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
        ],
      ),
    );
  }
}
