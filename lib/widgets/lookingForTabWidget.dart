// Widgets/art_categories_grid.dart
import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/controller/lookingForController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/gender.dart';

class ArtCategoriesGrid extends StatelessWidget {
  ArtCategoriesGrid({Key? key}) : super(key: key);

  final LookingForController lookingForCtrl = Get.find();
  final GenderController genderController = Get.find();

  final List<Map<String, String>> artCategories = const [
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

  final List<Map<String, String>> artCategoriesF = const [
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

  final List<Map<String, String>> artCategoriesNB = const [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (lookingForCtrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Header showing selection status
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selected: ${lookingForCtrl.selectedLookingFor.length}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (lookingForCtrl.selectedLookingFor.isNotEmpty)
                        ElevatedButton(
                          onPressed: () async {
                            final success = await lookingForCtrl
                                .saveLookingFor();
                            if (success) {
                              Get.snackbar(
                                'Success',
                                'Looking For updated successfully!',
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                              Get.back();
                            } else {
                              Get.snackbar(
                                'Error',
                                'Failed to update Looking For',
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
                      itemCount: artCategories.length,
                      itemBuilder: (context, index) {
                        final category =
                            genderController.selectedGender.value == Gender.male
                            ? artCategories[index]
                            : genderController.selectedGender.value ==
                                  Gender.female
                            ? artCategoriesF[index]
                            : artCategoriesNB[index];

                        final isSelected = lookingForCtrl.isSelected(
                          category['title']!,
                        );

                        return GestureDetector(
                          onTap: () {
                            lookingForCtrl.toggleLookingFor(category['title']!);
                          },
                          child: ArtCategoryCard(
                            imagePath: category['image']!,
                            title: category['title']!,
                            description: category['description']!,
                            isSelected: isSelected,
                          ),
                        );
                      },
                    ),
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

class ArtCategoryCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final bool isSelected;
  final bool showDeleteIcon;

  const ArtCategoryCard({
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
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
              ),
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

// Widgets/lookingForTabWidget.dart

class LookingForTabWidget extends StatelessWidget {
  LookingForTabWidget({Key? key}) : super(key: key);

  final LookingForController lookingForCtrl = Get.find();
  final GenderController genderController = Get.find();

  final List<Map<String, String>> artCategories = const [
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

  final List<Map<String, String>> artCategoriesF = const [
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

  final List<Map<String, String>> artCategoriesNB = const [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (lookingForCtrl.isLoading.value) {
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
                    'Looking For: ${lookingForCtrl.selectedLookingFor.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => ArtCategoriesGrid());
                    },
                    child: const Text('Edit Looking For'),
                  ),
                ],
              ),
            ),

            // Content
            if (lookingForCtrl.selectedLookingFor.isEmpty)
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
                          lookingForCtrl.toggleLookingFor(category['title']!);
                          final success = await lookingForCtrl.saveLookingFor();
                          if (success) {
                            Get.snackbar(
                              'Removed',
                              '${category['title']} removed from Looking For',
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
                            lookingForCtrl.toggleLookingFor(category['title']!);
                          }
                        },
                        child: ArtCategoryCard(
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
        ? artCategories
        : genderController.selectedGender.value == Gender.female
        ? artCategoriesF
        : artCategoriesNB;

    return allCategories.where((category) {
      return lookingForCtrl.selectedLookingFor.contains(category['title']);
    }).toList();
  }

  Widget _buildEmptyState() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No Preferences Set',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Let others know what you\'re looking for to find better matches',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Get.to(() => ArtCategoriesGrid());
            },
            child: Text('Set Preferences'),
          ),
        ],
      ),
    );
  }
}
