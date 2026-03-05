// Widgets/turnOnTabWidget.dart
import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/controller/turnOnsController.dart';
import 'package:dating_app/models/gender.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TurnOnTabWidget extends StatelessWidget {
  TurnOnTabWidget({Key? key}) : super(key: key);

  final TurnOnsController turnOnsCtrl = Get.find();
  final GenderController genderController = Get.find();

  final List<Map<String, String>> categories = const [
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
      'image': 'assets/images/to/to1920.png',
      'title': 'Drug Magic',
      'description': 'Let\'s make sense of the world through art?',
    },
    {
      'image': 'assets/images/to/to1921.png',
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

  final List<Map<String, String>> categoriesF = const [
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

  final List<Map<String, String>> categoriesNB = const [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (turnOnsCtrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final selectedCategories = _getSelectedCategories();

        return Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selected Turn-Ons: ${turnOnsCtrl.selectedTurnOns.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => CategoriesGrid());
                    },
                    child: const Text('Edit Turn-Ons'),
                  ),
                ],
              ),
            ),

            // Content
            if (turnOnsCtrl.selectedTurnOns.isEmpty)
              _buildEmptyState()
            else
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: selectedCategories.length,
                    itemBuilder: (context, index) {
                      final category = selectedCategories[index];
                      return GestureDetector(
                        onTap: () async {
                          // Remove from selection and save to Firebase immediately
                          turnOnsCtrl.toggleTurnOn(category['title']!);
                          final success = await turnOnsCtrl.saveTurnOns();
                          if (success) {
                            Get.snackbar(
                              'Removed',
                              '${category['title']} removed from turn-ons',
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          } else {
                            Get.snackbar(
                              'Error',
                              'Failed to remove ${category['title']}',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            // Revert if failed
                            turnOnsCtrl.toggleTurnOn(category['title']!);
                          }
                        },
                        child: CategoryCard(
                          imagePath: category['image']!,
                          title: category['title']!,
                          description: category['description']!,
                          isSelected: true,
                          showDeleteIcon: true,
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  List<Map<String, String>> _getSelectedCategories() {
    final allCategories = genderController.selectedGender.value == Gender.male
        ? categories
        : genderController.selectedGender.value == Gender.female
        ? categoriesF
        : categoriesNB;

    return allCategories.where((category) {
      return turnOnsCtrl.selectedTurnOns.contains(category['title']);
    }).toList();
  }

  Widget _buildEmptyState() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_emotions_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No Turn-Ons Selected',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Add your interests and preferences to help us find better matches for you',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Get.to(() => CategoriesGrid());
            },
            child: Text('Add Turn-Ons'),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final bool isSelected;
  final bool showDeleteIcon;

  const CategoryCard({
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
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
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
              decoration: BoxDecoration(color: Colors.transparent),
              child: Stack(
                children: [
                  Image.asset(imagePath, fit: BoxFit.contain),
                  // if (isSelected && showDeleteIcon)
                  //   Positioned(
                  //     top: 0,
                  //     right: 0,
                  //     child: Container(
                  //       padding: const EdgeInsets.all(4),
                  //       decoration: const BoxDecoration(
                  //         color: Colors.red,
                  //         shape: BoxShape.circle,
                  //       ),
                  //       child: const Icon(
                  //         Icons.close,
                  //         color: Colors.white,
                  //         size: 16,
                  //       ),
                  //     ),
                  //   ),
                  if (isSelected && !showDeleteIcon)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Widgets/categories_grid.dart

class CategoriesGrid extends StatelessWidget {
  CategoriesGrid({Key? key}) : super(key: key);

  final TurnOnsController turnOnsCtrl = Get.find();
  final GenderController genderController = Get.find();

  final List<Map<String, String>> categories = const [
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
      'image': 'assets/images/to/to1920.png',
      'title': 'Drug Magic',
      'description': 'Let\'s make sense of the world through art?',
    },
    {
      'image': 'assets/images/to/to1921.png',
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

  final List<Map<String, String>> categoriesF = const [
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

  final List<Map<String, String>> categoriesNB = const [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (turnOnsCtrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Header showing selection status
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selected: ${turnOnsCtrl.selectedTurnOns.length}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (turnOnsCtrl.selectedTurnOns.isNotEmpty)
                        ElevatedButton(
                          onPressed: () async {
                            final success = await turnOnsCtrl.saveTurnOns();
                            if (success) {
                              Get.snackbar(
                                'Success',
                                'Turn-ons updated successfully!',
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                              Get.back();
                            } else {
                              Get.snackbar(
                                'Error',
                                'Failed to update turn-ons',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          },
                          child: const Text('Save Selection'),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category =
                          genderController.selectedGender.value == Gender.male
                          ? categories[index]
                          : genderController.selectedGender.value ==
                                Gender.female
                          ? categoriesF[index]
                          : categoriesNB[index];

                      final isSelected = turnOnsCtrl.isSelected(
                        category['title']!,
                      );

                      return GestureDetector(
                        onTap: () {
                          turnOnsCtrl.toggleTurnOn(category['title']!);
                        },
                        child: CategoryCard(
                          imagePath: category['image']!,
                          title: category['title']!,
                          description: category['description']!,
                          isSelected: isSelected,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
