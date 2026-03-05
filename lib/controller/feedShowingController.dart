// Controller/feed_showing_controller.dart
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FeedShowingController extends GetxController {
  final RxList<Map<String, dynamic>> allFeeds = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredFeeds =
      <Map<String, dynamic>>[].obs;
  final RxString selectedFilter = 'Nearby'.obs;
  final RxBool isLoading = true.obs;
  final RxBool canShowFeed = false.obs;

  // Store liked users UIDs
  final RxSet<String> likedUsers = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    checkUserProfileCompletion();
  }

  Future<void> checkUserProfileCompletion() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        canShowFeed.value = false;
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        canShowFeed.value = false;
        return;
      }

      final data = doc.data()!;

      // Check if profile is complete
      final hasBio = data['bio'] != null && data['bio'].toString().isNotEmpty;
      final hasImages =
          data['images'] != null && (data['images'] as List).isNotEmpty;

      canShowFeed.value = hasBio && hasImages;

      if (canShowFeed.value) {
        await loadLikedUsers();
        await loadFeeds();
      }
    } catch (e) {
      print('Error checking profile completion: $e');
      canShowFeed.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadLikedUsers() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final likes = (data['likedUsers'] as List?)?.cast<String>() ?? [];
        likedUsers.value = likes.toSet();
      }
    } catch (e) {
      print('Error loading liked users: $e');
    }
  }

  Future<void> toggleLike(String targetUserId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);

      final targetUserRef = FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserId);

      if (likedUsers.contains(targetUserId)) {
        // Unlike
        likedUsers.remove(targetUserId);

        await userRef.update({
          'likedUsers': FieldValue.arrayRemove([targetUserId]),
        });

        // Decrease like count for target user
        await targetUserRef.update({'likeCount': FieldValue.increment(-1)});
      } else {
        // Like
        likedUsers.add(targetUserId);

        await userRef.update({
          'likedUsers': FieldValue.arrayUnion([targetUserId]),
        });

        // Increase like count for target user
        await targetUserRef.update({'likeCount': FieldValue.increment(1)});
      }
    } catch (e) {
      print('Error toggling like: $e');
      // Revert the local state if database update fails
      if (likedUsers.contains(targetUserId)) {
        likedUsers.remove(targetUserId);
      } else {
        likedUsers.add(targetUserId);
      }
    }
  }

  bool isLiked(String userId) {
    return likedUsers.contains(userId);
  }

  Future<void> loadFeeds() async {
    try {
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Get current user data
      final currentUserDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!currentUserDoc.exists) return;

      final currentUserData = currentUserDoc.data()!;
      final currentUserLocation =
          currentUserData['location'] as Map<String, dynamic>?;

      // Get all users except current user
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isNotEqualTo: user.uid)
          .get();

      allFeeds.clear();

      for (var doc in querySnapshot.docs) {
        final data = doc.data();

        // Only include users with complete profiles
        final hasBio = data['bio'] != null && data['bio'].toString().isNotEmpty;
        final hasImages =
            data['images'] != null && (data['images'] as List).isNotEmpty;

        if (hasBio && hasImages) {
          // Calculate distance if locations exist
          double? distance;
          if (currentUserLocation != null && data['location'] != null) {
            final userLocation = data['location'] as Map<String, dynamic>;
            distance = _calculateDistance(
              currentUserLocation['lat'],
              currentUserLocation['lng'],
              userLocation['lat'],
              userLocation['lng'],
            );
          }

          allFeeds.add({...data, 'distance': distance});
        }
      }

      // Apply initial filter
      applyFilter(selectedFilter.value);
    } catch (e) {
      print('Error loading feeds: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilter(String filter) {
    selectedFilter.value = filter;

    switch (filter) {
      case 'Nearby':
        _filterByNearby();
        break;
      case 'Looking For':
        _filterByLookingFor();
        break;
      case 'Turn-Ons':
        _filterByTurnOns();
        break;
      default:
        filteredFeeds.value = List.from(allFeeds);
    }
  }

  void _filterByNearby() {
    // Sort by distance (closest first)
    final sortedFeeds = List<Map<String, dynamic>>.from(allFeeds);
    sortedFeeds.sort((a, b) {
      final distanceA = a['distance'] as double? ?? double.infinity;
      final distanceB = b['distance'] as double? ?? double.infinity;
      return distanceA.compareTo(distanceB);
    });
    filteredFeeds.value = sortedFeeds;
  }

  Future<void> _filterByLookingFor() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final currentUserDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!currentUserDoc.exists) return;

      final currentUserData = currentUserDoc.data()!;
      final myLookingFor =
          (currentUserData['LookingFor'] as List?)?.cast<String>() ?? [];

      if (myLookingFor.isEmpty) {
        filteredFeeds.value = List.from(allFeeds);
        return;
      }

      // Filter users whose LookingFor matches any of mine
      final matchedFeeds = allFeeds.where((feed) {
        final theirLookingFor =
            (feed['LookingFor'] as List?)?.cast<String>() ?? [];
        return theirLookingFor.any((item) => myLookingFor.contains(item));
      }).toList();

      filteredFeeds.value = matchedFeeds;
    } catch (e) {
      print('Error filtering by Looking For: $e');
      filteredFeeds.value = List.from(allFeeds);
    }
  }

  Future<void> _filterByTurnOns() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final currentUserDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!currentUserDoc.exists) return;

      final currentUserData = currentUserDoc.data()!;
      final myTurnOns =
          (currentUserData['turnOns'] as List?)?.cast<String>() ?? [];

      if (myTurnOns.isEmpty) {
        filteredFeeds.value = List.from(allFeeds);
        return;
      }

      // Filter users whose turnOns match any of mine
      final matchedFeeds = allFeeds.where((feed) {
        final theirTurnOns = (feed['turnOns'] as List?)?.cast<String>() ?? [];
        return theirTurnOns.any((item) => myTurnOns.contains(item));
      }).toList();

      filteredFeeds.value = matchedFeeds;
    } catch (e) {
      print('Error filtering by Turn-Ons: $e');
      filteredFeeds.value = List.from(allFeeds);
    }
  }

  // Calculate distance between two coordinates using Haversine formula
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadiusKm = 6371.0;

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  String getDistanceText(double? distance) {
    if (distance == null) return 'Unknown distance';
    if (distance < 1) return '${(distance * 1000).round()}m away';
    return '${distance.round()}km away';
  }

  String getCountryFlag(String country) {
    final flags = {
      'France': '🇫🇷',
      'USA': '🇺🇸',
      'UK': '🇬🇧',
      'Japan': '🇯🇵',
      'Germany': '🇩🇪',
      'Italy': '🇮🇹',
      'Spain': '🇪🇸',
      'Netherlands': '🇳🇱',
      'Australia': '🇦🇺',
      'Canada': '🇨🇦',
      'UAE': '🇦🇪',
      'Singapore': '🇸🇬',
      'India': '🇮🇳',
      'Thailand': '🇹🇭',
      'Turkey': '🇹🇷',
      'Russia': '🇷🇺',
      'Argentina': '🇦🇷',
      'Egypt': '🇪🇬',
      'Sweden': '🇸🇪',
      'Austria': '🇦🇹',
    };
    return flags[country] ?? '🌍';
  }
}
