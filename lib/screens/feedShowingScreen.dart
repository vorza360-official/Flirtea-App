// Screens/feedShowingScreen.dart
import 'package:dating_app/controller/feedShowingController.dart';
import 'package:dating_app/screens/feedItemScreen.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/screens/feedScreen.dart';
import 'package:dating_app/const/colors.dart';

class FeedShowingScreen extends StatefulWidget {
  const FeedShowingScreen({Key? key}) : super(key: key);

  @override
  State<FeedShowingScreen> createState() => _FeedShowingScreenState();
}

class _FeedShowingScreenState extends State<FeedShowingScreen> {
  final FeedShowingController feedShowingCtrl = Get.put(
    FeedShowingController(),
  );
  final GenderController genderCtrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        if (feedShowingCtrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!feedShowingCtrl.canShowFeed.value) {
          return _buildProfileIncompleteView();
        }

        return SafeArea(
          child: Column(
            children: [
              // Filter buttons at the top
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterButton('Nearby'),
                      const SizedBox(width: 12),
                      _buildFilterButton('Looking For'),
                      const SizedBox(width: 12),
                      _buildFilterButton('Turn-Ons'),
                    ],
                  ),
                ),
              ),

              // Posts feed
              Expanded(
                child: feedShowingCtrl.filteredFeeds.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: feedShowingCtrl.filteredFeeds.length,
                        itemBuilder: (context, index) {
                          final post = feedShowingCtrl.filteredFeeds[index];
                          final isImageOnRight = index % 2 == 0;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: _buildPostCard(
                              post: post,
                              isImageOnRight: isImageOnRight,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileIncompleteView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              'Complete Your Profile First',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'You need to add your bio and profile pictures before you can view other profiles.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Get.to(() => const FeedScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: myPurple,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Complete Profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 24),
            Text(
              'No Matches Found',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Try changing your filter to see more profiles.',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String text) {
    return Obx(() {
      final isSelected = feedShowingCtrl.selectedFilter.value == text;
      return GestureDetector(
        onTap: () {
          feedShowingCtrl.applyFilter(text);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF8B4BA6) : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: isSelected ? null : Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPostCard({
    required Map<String, dynamic> post,
    required bool isImageOnRight,
  }) {
    final images = (post['images'] as List?)?.cast<String>() ?? [];
    final location = post['location'] as Map<String, dynamic>?;
    final city = location?['city'] ?? 'Unknown';
    final country = location?['country'] ?? '';
    final flag = feedShowingCtrl.getCountryFlag(country);

    return GestureDetector(
      onTap: () {
        Get.to(() => FeedItemScreen(userData: post));
      },
      child: Container(
        height: 320,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Row(
            children: [
              // Content side (text and controls)
              if (!isImageOnRight) _buildContentSide(post),

              // Image side with stacked cards
              _buildStackedImageSide(images),

              // Content side (text and controls)
              if (isImageOnRight) _buildContentSide(post),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentSide(Map<String, dynamic> post) {
    final turnOns = (post['turnOns'] as List?)?.cast<String>() ?? [];
    final lookingFor = (post['LookingFor'] as List?)?.cast<String>() ?? [];

    // Get first 2 items from each
    final displayTurnOns = turnOns.take(2).join(', ');
    final displayLookingFor = lookingFor.take(2).join(', ');

    final languages =
        '${displayTurnOns.isNotEmpty ? displayTurnOns : 'No Turn-Ons'}';
    final location = post['location'] as Map<String, dynamic>?;
    final city = location?['city'] ?? 'Unknown';
    final country = location?['country'] ?? '';
    final flag = feedShowingCtrl.getCountryFlag(country);
    final distance = post['distance'] as double?;
    final userId = post['uid'] as String;

    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(flex: 1),

            // Languages/Turn-ons
            Text(
              languages,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            // Description/Bio
            Text(
              post['bio'] ?? 'No bio available',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 16),

            // Location
            Text(
              '$city $flag ${distance != null ? feedShowingCtrl.getDistanceText(distance) : ''}',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),

            const Spacer(flex: 1),

            // Action buttons
            Row(
              children: [
                // More options button
                _buildActionButton(
                  icon: Icons.more_horiz,
                  color: Colors.black54,
                  backgroundColor: Colors.transparent,
                  onTap: () {
                    _showMoreOptions(post);
                  },
                ),

                const Spacer(),

                // Diamond/Premium button
                _buildActionButton(
                  icon: Icons.diamond_outlined,
                  color: Colors.black54,
                  backgroundColor: Colors.transparent,
                  onTap: () {
                    // Premium feature
                  },
                ),

                const SizedBox(width: 24),

                // Like/Heart button - now reactive with Obx
                Obx(() {
                  final isLiked = feedShowingCtrl.isLiked(userId);
                  return _buildActionButton(
                    icon: isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.black54,
                    backgroundColor: Colors.transparent,
                    onTap: () {
                      feedShowingCtrl.toggleLike(userId);
                    },
                  );
                }),
              ],
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildStackedImageSide(List<String> images) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          if (images.isNotEmpty) {
            _showImageSlider(images);
          }
        },
        child: Container(
          height: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Third card (bottom) - rotated +10 degrees
              if (images.length > 2)
                Transform.rotate(
                  angle: 10 * math.pi / 180,
                  child: _buildImageCard(imageUrl: images[2]),
                ),

              // Second card (middle) - rotated -10 degrees
              if (images.length > 1)
                Transform.rotate(
                  angle: -10 * math.pi / 180,
                  child: _buildImageCard(imageUrl: images[1]),
                ),

              // First card (top) - 0 degrees
              if (images.isNotEmpty)
                Transform.rotate(
                  angle: 0,
                  child: _buildImageCard(
                    imageUrl: images[0],
                    showContent: true,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard({required String imageUrl, bool showContent = false}) {
    return Container(
      width: 140,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: Colors.grey.shade300,
                    child: Center(
                      child: CircularProgressIndicator(
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
                      Icons.person,
                      size: 50,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),

            // Gradient overlay for better visibility (only on top card)
            if (showContent)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  void _showImageSlider(List<String> images) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            PageView.builder(
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Image.network(images[index], fit: BoxFit.contain),
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

  void _showMoreOptions(Map<String, dynamic> post) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('View Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => FeedItemScreen(userData: post));
                },
              ),
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('Block User'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement block functionality
                },
              ),
              ListTile(
                leading: const Icon(Icons.report),
                title: const Text('Report'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement report functionality
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
