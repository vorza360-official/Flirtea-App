// Screens/feedItemScreen.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedItemScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const FeedItemScreen({super.key, required this.userData});

  @override
  State<FeedItemScreen> createState() => _FeedItemScreenState();
}

class _FeedItemScreenState extends State<FeedItemScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GenderController genderCtrl = Get.find();

  // Header data
  String city = '';
  String genderSexuality = '';
  String age = '';
  String fullName = '';
  List<String> imageUrls = [];
  String bio = '';
  List<String> turnOns = [];
  List<String> lookingFor = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadUserData();
  }

  void _loadUserData() {
    final data = widget.userData;

    setState(() {
      fullName = data['fullName'] ?? 'Unknown';
      city = data['location']?['city']?.toString() ?? 'Unknown';
      final g = data['gender']?.toString() ?? 'male';
      final s = data['sexuality']?.toString() ?? 'Queer';
      genderSexuality = '${g.capitalizeFirst}, $s';
      age = '${data['age'] ?? 0} Years';
      imageUrls = (data['images'] as List?)?.cast<String>() ?? [];
      bio = data['bio']?.toString() ?? '';
      turnOns = (data['turnOns'] as List?)?.cast<String>() ?? [];
      lookingFor = (data['LookingFor'] as List?)?.cast<String>() ?? [];
    });
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
                _buildTurnOnsTab(),
                _buildLookingForTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomHeader() {
    // Determine user's gender for theme
    final userGender = widget.userData['gender']?.toString() ?? 'male';
    Gender displayGender = Gender.male;
    if (userGender.toLowerCase() == 'female') {
      displayGender = Gender.female;
    } else if (userGender.toLowerCase() == 'nonbinary' ||
        userGender.toLowerCase() == 'non-binary') {
      displayGender = Gender.nonBinary;
    }

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
                  displayGender == Gender.male
                      ? "assets/images/headerMainBg.png"
                      : displayGender == Gender.female
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
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.share, color: Colors.white, size: 24),
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
                    Text(
                      fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
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
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 50,
            child: Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: ClipOval(
                  child: imageUrls.isNotEmpty
                      ? Image.network(
                          imageUrls[0],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: Colors.grey.shade300,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/images/headerProfile.png",
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          "assets/images/headerProfile.png",
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final userGender = widget.userData['gender']?.toString() ?? 'male';
    Gender displayGender = Gender.male;
    if (userGender.toLowerCase() == 'female') {
      displayGender = Gender.female;
    } else if (userGender.toLowerCase() == 'nonbinary' ||
        userGender.toLowerCase() == 'non-binary') {
      displayGender = Gender.nonBinary;
    }

    final color = displayGender == Gender.male
        ? myPurple
        : displayGender == Gender.female
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
    final userGender = widget.userData['gender']?.toString() ?? 'male';
    Gender displayGender = Gender.male;
    if (userGender.toLowerCase() == 'female') {
      displayGender = Gender.female;
    } else if (userGender.toLowerCase() == 'nonbinary' ||
        userGender.toLowerCase() == 'non-binary') {
      displayGender = Gender.nonBinary;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bio",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              bio.isEmpty ? 'No bio available' : bio,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade800,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Image.asset(
              displayGender == Gender.male
                  ? "assets/images/bio_image2.png"
                  : displayGender == Gender.female
                  ? "assets/images/female/bio_image2.png"
                  : "assets/images/nonBinary/bio_image2.png",
              height: 300,
              fit: BoxFit.contain,
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
            "Photos",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          imageUrls.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      'No photos available',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _showImageViewer(index),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrls[index],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: Colors.grey.shade300,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  value: progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                            progress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade300,
                              child: const Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }

  Widget _buildTurnOnsTab() {
    // Determine user's gender for assets
    final userGender = widget.userData['gender']?.toString() ?? 'male';
    Gender displayGender = Gender.male;
    if (userGender.toLowerCase() == 'female') {
      displayGender = Gender.female;
    } else if (userGender.toLowerCase() == 'nonbinary' ||
        userGender.toLowerCase() == 'non-binary') {
      displayGender = Gender.nonBinary;
    }

    // Get all categories based on gender
    final allCategories = displayGender == Gender.male
        ? _getTurnOnCategories()
        : displayGender == Gender.female
        ? _getTurnOnCategoriesF()
        : _getTurnOnCategoriesNB();

    // Filter to show only selected ones
    final selectedCategories = allCategories.where((category) {
      return turnOns.contains(category['title']);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: turnOns.isEmpty
          ? _buildTurnOnsEmptyState()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: selectedCategories.length,
                itemBuilder: (context, index) {
                  final category = selectedCategories[index];
                  return _CategoryCard(
                    imagePath: category['image']!,
                    title: category['title']!,
                    description: category['description']!,
                    isSelected: true,
                    showDeleteIcon: false,
                  );
                },
              ),
            ),
    );
  }

  Widget _buildTurnOnsEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_emotions_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No Turn-Ons Selected',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'This user hasn\'t added their interests yet',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLookingForTab() {
    // Determine user's gender for assets
    final userGender = widget.userData['gender']?.toString() ?? 'male';
    Gender displayGender = Gender.male;
    if (userGender.toLowerCase() == 'female') {
      displayGender = Gender.female;
    } else if (userGender.toLowerCase() == 'nonbinary' ||
        userGender.toLowerCase() == 'non-binary') {
      displayGender = Gender.nonBinary;
    }

    // Get all categories based on gender
    final allCategories = displayGender == Gender.male
        ? _getLookingForCategories()
        : displayGender == Gender.female
        ? _getLookingForCategoriesF()
        : _getLookingForCategoriesNB();

    // Filter to show only selected ones
    final selectedCategories = allCategories.where((category) {
      return lookingFor.contains(category['title']);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: lookingFor.isEmpty
          ? _buildLookingForEmptyState()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: selectedCategories.length,
                itemBuilder: (context, index) {
                  final category = selectedCategories[index];
                  return _CategoryCard(
                    imagePath: category['image']!,
                    title: category['title']!,
                    description: category['description']!,
                    isSelected: true,
                    showDeleteIcon: false,
                  );
                },
              ),
            ),
    );
  }

  Widget _buildLookingForEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No Preferences Set',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'This user hasn\'t set their preferences yet',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageViewer(int initialIndex) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            PageView.builder(
              controller: PageController(initialPage: initialIndex),
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Image.network(imageUrls[index], fit: BoxFit.contain),
                );
              },
            ),
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Category data for Turn-Ons (Male)
  List<Map<String, String>> _getTurnOnCategories() {
    return const [
      {
        'image': 'assets/images/to/to1.png',
        'title': 'Active Dance',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to2.png',
        'title': 'Let\'s Dance',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to3.png',
        'title': 'Gaming',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to4.png',
        'title': 'Cosplay',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to5.png',
        'title': 'Joking',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to6.png',
        'title': 'Board Games',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to7.png',
        'title': 'Mindful',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to8.png',
        'title': 'Hiking & Picnics',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to9.png',
        'title': 'Outdoor Games',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to10.png',
        'title': 'Active',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to11.png',
        'title': 'Couple',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to12.png',
        'title': 'Artisan',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to13.png',
        'title': 'Massage',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to14.png',
        'title': 'Music',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to15.png',
        'title': 'Being Worshipped',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to16.png',
        'title': 'Literature',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to17.png',
        'title': 'DIY Hub',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to18.png',
        'title': 'Vice Free',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to19.png',
        'title': 'Drug Magic',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to20.png',
        'title': 'Wonder Woman',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to21.png',
        'title': 'Stand up Comedy',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to22.png',
        'title': 'Never Misadventure',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to23.png',
        'title': 'Summertime Spirit',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to24.png',
        'title': 'Day Dating',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to25.png',
        'title': 'Feminism',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to26.png',
        'title': 'Love of Love',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to27.png',
        'title': 'Spirituality',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to28.png',
        'title': 'Plant Medicine',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to29.png',
        'title': 'Stay Safe',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to30.png',
        'title': 'Seeking Safe',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to31.png',
        'title': 'Sweet',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to32.png',
        'title': 'Elementary',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to33.png',
        'title': 'Biking',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to34.png',
        'title': 'Fantasies',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to35.png',
        'title': 'Wholesome Vibes',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to36.png',
        'title': 'Being in Therapy',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to37.png',
        'title': 'Slow',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/to/to38.png',
        'title': 'Coffee Dates',
        'description': 'Let\'s make sense of the world through art?',
      },
    ];
  }

  // Category data for Turn-Ons (Female)
  List<Map<String, String>> _getTurnOnCategoriesF() {
    return const [
      {
        'image': 'assets/images/female/to/to1.png',
        'title': 'Active Dance',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to2.png',
        'title': 'Let\'s Dance',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to3.png',
        'title': 'Gaming',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to304.png',
        'title': 'Cosplay',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to305.png',
        'title': 'Joking',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to4.png',
        'title': 'Board Games',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to5.png',
        'title': 'Mindful',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to6.png',
        'title': 'Hiking & Picnics',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to7.png',
        'title': 'Outdoor Games',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to8.png',
        'title': 'Active',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to9.png',
        'title': 'Couple',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to10.png',
        'title': 'Artisan',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to11.png',
        'title': 'Massage',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to12.png',
        'title': 'Music',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to13.png',
        'title': 'Being Worshipped',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to14.png',
        'title': 'Literature',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to15.png',
        'title': 'DIY Hub',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to16.png',
        'title': 'Vice Free',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to17.png',
        'title': 'Drug Magic',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to18.png',
        'title': 'Drug Magic',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to19.png',
        'title': 'Drug Magic',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to1920.png',
        'title': 'Wonder Woman',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to1921.png',
        'title': 'Stand up Comedy',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to20.png',
        'title': 'Never Misadventure',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to21.png',
        'title': 'Summertime Spirit',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to22.png',
        'title': 'Day Dating',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to23.png',
        'title': 'Feminism',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to24.png',
        'title': 'Love of Love',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to25.png',
        'title': 'Spirituality',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to26.png',
        'title': 'Plant Medicine',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to27.png',
        'title': 'Stay Safe',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to28.png',
        'title': 'Seeking Safe',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to29.png',
        'title': 'Sweet',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to30.png',
        'title': 'Elementary',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to31.png',
        'title': 'Biking',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to32.png',
        'title': 'Fantasies',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to33.png',
        'title': 'Wholesome Vibes',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to34.png',
        'title': 'Being in Therapy',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to35.png',
        'title': 'Slow',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/to/to36.png',
        'title': 'Coffee Dates',
        'description': 'Let\'s make sense of the world through art?',
      },
    ];
  }

  // Category data for Turn-Ons (Non-Binary)
  List<Map<String, String>> _getTurnOnCategoriesNB() {
    return const [
      {
        'image': 'assets/images/nonBinary/to/to1.png',
        'title': 'Active Dance',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to2.png',
        'title': 'Let\'s Dance',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to3.png',
        'title': 'Gaming',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to4.png',
        'title': 'Cosplay',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to5.png',
        'title': 'Joking',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to6.png',
        'title': 'Board Games',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to7.png',
        'title': 'Mindful',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to8.png',
        'title': 'Hiking & Picnics',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to9.png',
        'title': 'Outdoor Games',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to10.png',
        'title': 'Active',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to11.png',
        'title': 'Couple',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to12.png',
        'title': 'Artisan',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to13.png',
        'title': 'Massage',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to14.png',
        'title': 'Music',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to15.png',
        'title': 'Being Worshipped',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to16.png',
        'title': 'Literature',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to17.png',
        'title': 'DIY Hub',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to18.png',
        'title': 'Vice Free',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to19.png',
        'title': 'Drug Magic',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to1920.png',
        'title': 'Drug Magic',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to1921.png',
        'title': 'Drug Magic',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to20.png',
        'title': 'Wonder Woman',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to21.png',
        'title': 'Stand up Comedy',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to22.png',
        'title': 'Never Misadventure',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to23.png',
        'title': 'Summertime Spirit',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to24.png',
        'title': 'Day Dating',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to25.png',
        'title': 'Feminism',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to26.png',
        'title': 'Love of Love',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to27.png',
        'title': 'Spirituality',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to28.png',
        'title': 'Plant Medicine',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to29.png',
        'title': 'Stay Safe',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to30.png',
        'title': 'Seeking Safe',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to31.png',
        'title': 'Sweet',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to32.png',
        'title': 'Elementary',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to33.png',
        'title': 'Biking',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to34.png',
        'title': 'Fantasies',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to35.png',
        'title': 'Wholesome Vibes',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to36.png',
        'title': 'Being in Therapy',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to37.png',
        'title': 'Slow',
        'description': 'Let\'s make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/to/to38.png',
        'title': 'Coffee Dates',
        'description': 'Let\'s make sense of the world through art?',
      },
    ];
  }

  // Category data for Looking For (Male)
  List<Map<String, String>> _getLookingForCategories() {
    return const [
      {
        'image': 'assets/images/LookingFor/lf1.png',
        'title': 'Casual',
        'description': 'Lets make sense of the world through art?',
      },
      {
        'image': 'assets/images/LookingFor/lf2.png',
        'title': 'Long Term',
        'description': 'Lets make sense of the world through art?',
      },
      {
        'image': 'assets/images/LookingFor/lf3.png',
        'title': 'Virtual',
        'description': 'Lets make sense of the world through art?',
      },
      {
        'image': 'assets/images/LookingFor/lf4.png',
        'title': 'Non-Monogamy',
        'description': 'Lets make sense of the world through art?',
      },
      {
        'image': 'assets/images/LookingFor/lf5.png',
        'title': 'Anything But Boring',
        'description': 'Lets make sense of the world through art?',
      },
    ];
  }

  // Category data for Looking For (Female)
  List<Map<String, String>> _getLookingForCategoriesF() {
    return const [
      {
        'image': 'assets/images/female/LookingFor/lf1.png',
        'title': 'Casual',
        'description': 'Lets make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/LookingFor/lf2.png',
        'title': 'Long Term',
        'description': 'Lets make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/LookingFor/lf3.png',
        'title': 'Virtual',
        'description': 'Lets make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/LookingFor/lf4.png',
        'title': 'Non-Monogamy',
        'description': 'Lets make sense of the world through art?',
      },
      {
        'image': 'assets/images/female/LookingFor/lf5.png',
        'title': 'Anything But Boring',
        'description': 'Lets make sense of the world through art?',
      },
    ];
  }

  // Category data for Looking For (Non-Binary)
  List<Map<String, String>> _getLookingForCategoriesNB() {
    return const [
      {
        'image': 'assets/images/nonBinary/LookingFor/lf1.png',
        'title': 'Casual',
        'description': 'Lets make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/LookingFor/lf2.png',
        'title': 'Long Term',
        'description': 'Lets make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/LookingFor/lf3.png',
        'title': 'Virtual',
        'description': 'Lets make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/LookingFor/lf4.png',
        'title': 'Non-Monogamy',
        'description': 'Lets make sense of the world through art?',
      },
      {
        'image': 'assets/images/nonBinary/LookingFor/lf5.png',
        'title': 'Anything But Boring',
        'description': 'Lets make sense of the world through art?',
      },
    ];
  }
}

// Category Card Widget (same as in FeedScreen widgets)
class _CategoryCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final bool isSelected;
  final bool showDeleteIcon;

  const _CategoryCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
    this.isSelected = false,
    this.showDeleteIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // the grey box (text container)
        Container(
          margin: const EdgeInsets.only(top: 50),
          padding: const EdgeInsets.only(
            top: 60,
            left: 8,
            right: 8,
            bottom: 12,
          ),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[50] : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: Colors.blue, width: 2)
                : null,
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.blue[800] : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.blue[600] : Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        // image overlaps box
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Image.asset(imagePath, fit: BoxFit.contain),
                  if (isSelected && showDeleteIcon)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  // if (isSelected && !showDeleteIcon)
                  //   Positioned(
                  //     top: 0,
                  //     right: 0,
                  //     child: Container(
                  //       padding: const EdgeInsets.all(4),
                  //       decoration: const BoxDecoration(
                  //         color: Colors.blue,
                  //         shape: BoxShape.circle,
                  //       ),
                  //       child: const Icon(
                  //         Icons.check,
                  //         color: Colors.white,
                  //         size: 16,
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
