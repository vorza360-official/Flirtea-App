import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class CallingController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxBool isSearching = false.obs;
  final RxString callStatus = 'Idle'.obs;
  final Rx<Map<String, dynamic>?> activeCall = Rx<Map<String, dynamic>?>(null);
  final RxBool identityRevealed = false.obs;
  final RxBool partnerIdentityRevealed = false.obs;
  final RxBool isHost = false.obs;
  final RxString selectedRegion = 'Global'.obs;

  @override
  void onInit() {
    super.onInit();
    print('🔵 CallingController initialized');
    _cleanupOldData();
    // CRITICAL: Must start listening for calls immediately
    _listenForCallStart();
  }

  Future<void> _cleanupOldData() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    print('🧹 Cleaning up old data for user: ${currentUser.uid}');

    try {
      // Remove from queue
      await _firestore.collection('callQueue').doc(currentUser.uid).delete();

      // Leave any ongoing calls
      QuerySnapshot ongoingCalls = await _firestore
          .collection('calls')
          .where('participants', arrayContains: currentUser.uid)
          .where('status', whereIn: ['waiting', 'ongoing'])
          .get();

      for (var doc in ongoingCalls.docs) {
        await doc.reference.update({
          'status': 'abandoned',
          'endTime': FieldValue.serverTimestamp(),
        });
      }

      print('✅ Cleanup completed');
    } catch (e) {
      print('❌ Cleanup error: $e');
    }
  }

  Future<Map<String, dynamic>?> _getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      print('❌ Error getting profile: $e');
      return null;
    }
  }

  double _calculateMatchScore(
    Map<String, dynamic> userA,
    Map<String, dynamic> userB,
  ) {
    try {
      // Get arrays
      List<dynamic> turnOnsA = userA['turnOns'] ?? [];
      List<dynamic> turnOnsB = userB['turnOns'] ?? [];
      List<dynamic> lookingForA = userA['LookingFor'] ?? [];
      List<dynamic> lookingForB = userB['LookingFor'] ?? [];

      // Convert to strings
      List<String> turnOnsAStr = turnOnsA.map((e) => e.toString()).toList();
      List<String> turnOnsBStr = turnOnsB.map((e) => e.toString()).toList();
      List<String> lookingForAStr = lookingForA
          .map((e) => e.toString())
          .toList();
      List<String> lookingForBStr = lookingForB
          .map((e) => e.toString())
          .toList();

      // Calculate matches
      int matchedTurnOns = turnOnsAStr
          .toSet()
          .intersection(turnOnsBStr.toSet())
          .length;
      int matchedLookingFor = lookingForAStr
          .toSet()
          .intersection(lookingForBStr.toSet())
          .length;

      // Total possible matches (union of both users' preferences)
      Set<String> allPreferences = {
        ...turnOnsAStr,
        ...turnOnsBStr,
        ...lookingForAStr,
        ...lookingForBStr,
      };
      int totalPreferences = allPreferences.length;

      if (totalPreferences == 0) return 0.0;

      double score =
          ((matchedTurnOns + matchedLookingFor) / totalPreferences) * 100;

      print('🎯 Match score calculated: ${score.toStringAsFixed(1)}%');
      return score;
    } catch (e) {
      print('❌ Match calculation error: $e');
      return 0.0;
    }
  }

  Future<void> startMatching() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      callStatus.value = 'Please login first';
      print('❌ No current user');
      return;
    }

    print('🔵 Starting matching for user: ${currentUser.uid}');

    // Reset state
    identityRevealed.value = false;
    partnerIdentityRevealed.value = false;
    activeCall.value = null;
    isSearching.value = true;
    callStatus.value = 'Searching for matches...';

    try {
      Map<String, dynamic>? myProfile = await _getUserProfile(currentUser.uid);
      if (myProfile == null) {
        callStatus.value = 'Profile not found';
        isSearching.value = false;
        print('❌ Profile not found');
        return;
      }

      print('✅ User profile loaded');

      // Try to join existing first
      bool foundMatch = await _tryJoinExistingCall(currentUser.uid, myProfile);

      if (!foundMatch) {
        // Create waiting entry if no match found
        print('🔵 Creating waiting call...');
        await _createWaitingCall(currentUser.uid, myProfile);
        isHost.value = true;
        _listenForJoiner(currentUser.uid);
        print('✅ Waiting for match as host');
      }
    } catch (e) {
      isSearching.value = false;
      callStatus.value = 'Error: $e';
      print('❌ Error starting match: $e');
    }
  }

  Future<bool> _tryJoinExistingCall(
    String myUid,
    Map<String, dynamic> myProfile,
  ) async {
    print('🔍 Looking for existing calls...');

    try {
      QuerySnapshot waitingCalls = await _firestore
          .collection('callQueue')
          .where('status', isEqualTo: 'waiting')
          .where('region', isEqualTo: selectedRegion.value)
          .orderBy('createdAt', descending: false)
          .limit(20)
          .get();

      print('📋 Found ${waitingCalls.docs.length} waiting calls');

      for (var doc in waitingCalls.docs) {
        var callData = doc.data() as Map<String, dynamic>;
        String hostUid = callData['hostUid'];

        if (hostUid == myUid) {
          print('⏭️ Skipping own call');
          continue;
        }

        print('🔍 Checking match with host: $hostUid');

        Map<String, dynamic>? hostProfile = await _getUserProfile(hostUid);
        if (hostProfile == null) {
          print('⏭️ Host profile not found');
          continue;
        }

        double matchScore = _calculateMatchScore(myProfile, hostProfile);

        if (matchScore >= 60.0) {
          print(
            '✅ Found compatible match! Score: ${matchScore.toStringAsFixed(1)}%',
          );
          await _joinExistingCall(myUid, hostUid, doc.id, matchScore);
          isHost.value = false;
          return true;
        } else {
          print('⏭️ Score too low: ${matchScore.toStringAsFixed(1)}%');
        }
      }

      print('❌ No compatible matches found');
    } catch (e) {
      print('❌ Join error: $e');
    }
    return false;
  }

  Future<void> _createWaitingCall(
    String myUid,
    Map<String, dynamic> myProfile,
  ) async {
    String roomId = _generateRoomId();
    String callId = 'waiting_${myUid}_${DateTime.now().millisecondsSinceEpoch}';

    print('🔵 Creating waiting call - RoomID: $roomId, CallID: $callId');

    await _firestore.collection('callQueue').doc(callId).set({
      'callId': callId,
      'hostUid': myUid,
      'hostProfile': {
        'turnOns': myProfile['turnOns'],
        'LookingFor': myProfile['LookingFor'],
      },
      'joinerUid': null,
      'roomId': roomId,
      'status': 'waiting',
      'region': selectedRegion.value,
      'createdAt': FieldValue.serverTimestamp(),
      'matchScore': null,
    });

    callStatus.value = 'Waiting for a match...';
    print('✅ Waiting call created');
  }

  Future<void> _joinExistingCall(
    String myUid,
    String hostUid,
    String callId,
    double matchScore,
  ) async {
    print('🔵 Joining existing call - CallID: $callId');

    try {
      DocumentSnapshot callDoc = await _firestore
          .collection('callQueue')
          .doc(callId)
          .get();
      if (!callDoc.exists) {
        print('❌ Call document not found');
        return;
      }

      var callData = callDoc.data() as Map<String, dynamic>;
      String roomId = callData['roomId'];

      print('🔵 Updating call with joiner info...');
      // Update call with joiner info
      await _firestore.collection('callQueue').doc(callId).update({
        'joinerUid': myUid,
        'status': 'matched',
        'matchScore': matchScore,
        'matchedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Call updated, creating final call...');
      // Create final call document
      await _createFinalCall(hostUid, myUid, roomId, matchScore, callId);
    } catch (e) {
      print('❌ Error joining call: $e');
    }
  }

  Future<void> _createFinalCall(
    String hostUid,
    String joinerUid,
    String roomId,
    double matchScore,
    String waitingCallId,
  ) async {
    String finalCallId = 'call_${hostUid}_$joinerUid';

    print('🔵 Creating final call - CallID: $finalCallId, RoomID: $roomId');

    await _firestore.collection('calls').doc(finalCallId).set({
      'callId': finalCallId,
      'hostUid': hostUid,
      'joinerUid': joinerUid,
      'participants': [hostUid, joinerUid],
      'roomId': roomId,
      'matchScore': matchScore,
      'status': 'ongoing',
      'anonymous': true,
      'videoEnabled': false,
      'consentHost': false,
      'consentJoiner': false,
      'startedAt': FieldValue.serverTimestamp(),
    });

    print('✅ Final call created');

    // Delete waiting call
    await _firestore.collection('callQueue').doc(waitingCallId).delete();
    print('✅ Waiting call deleted');
  }

  void _listenForJoiner(String myUid) {
    print('👂 Listening for joiner...');

    _firestore
        .collection('callQueue')
        .where('hostUid', isEqualTo: myUid)
        .where('status', isEqualTo: 'matched')
        .snapshots()
        .listen((snapshot) async {
          if (snapshot.docs.isNotEmpty) {
            print('✅ Joiner found!');
            var callData = snapshot.docs.first.data();
            String joinerUid = callData['joinerUid'];
            double matchScore = callData['matchScore'] ?? 60.0;

            // Get the room ID
            String roomId = callData['roomId'];
            String waitingCallId = snapshot.docs.first.id;

            print('🔵 Creating final call for host...');
            // Create final call
            await _createFinalCall(
              myUid,
              joinerUid,
              roomId,
              matchScore,
              waitingCallId,
            );
          }
        });
  }

  void _listenForCallStart() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    print('👂 Listening for call start...');

    _firestore
        .collection('calls')
        .where('participants', arrayContains: currentUser.uid)
        .where('status', isEqualTo: 'ongoing')
        .snapshots()
        .listen((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            print('🎉 Call started!');
            var callData = snapshot.docs.first.data();
            activeCall.value = {...callData, 'callId': snapshot.docs.first.id};
            callStatus.value = 'In Call';
            isSearching.value = false;

            print('📋 Call details:');
            print('   Room ID: ${callData['roomId']}');
            print('   Host: ${callData['hostUid']}');
            print('   Joiner: ${callData['joinerUid']}');
            print('   Match Score: ${callData['matchScore']}%');

            _listenForIdentityUpdates(snapshot.docs.first.id);
          }
        });
  }

  void _listenForIdentityUpdates(String callId) {
    print('👂 Listening for identity updates...');

    _firestore.collection('calls').doc(callId).snapshots().listen((doc) {
      if (doc.exists) {
        var data = doc.data()!;
        final currentUser = _auth.currentUser;

        if (currentUser != null) {
          bool isHostUser = data['hostUid'] == currentUser.uid;

          bool myConsent = isHostUser
              ? data['consentHost'] == true
              : data['consentJoiner'] == true;
          bool partnerConsent = isHostUser
              ? data['consentJoiner'] == true
              : data['consentHost'] == true;

          if (myConsent != identityRevealed.value) {
            identityRevealed.value = myConsent;
            print('🔓 My identity revealed: $myConsent');
          }

          if (partnerConsent != partnerIdentityRevealed.value) {
            partnerIdentityRevealed.value = partnerConsent;
            print('🔓 Partner identity revealed: $partnerConsent');
          }

          // Auto-enable video when both revealed
          if (data['consentHost'] == true && data['consentJoiner'] == true) {
            if (data['anonymous'] == true) {
              print('🎥 Both revealed, enabling video...');
              doc.reference.update({'anonymous': false, 'videoEnabled': true});
            }
          }
        }
      }
    });
  }

  String _generateRoomId() {
    var r = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(12, (index) => chars[r.nextInt(chars.length)]).join();
  }

  Future<void> endCall() async {
    if (activeCall.value != null) {
      String callId = activeCall.value!['callId'];
      print('🔵 Ending call: $callId');

      try {
        await _firestore.collection('calls').doc(callId).update({
          'status': 'ended',
          'endedAt': FieldValue.serverTimestamp(),
        });
        print('✅ Call ended');
      } catch (e) {
        print('❌ Error ending call: $e');
      }

      activeCall.value = null;
      callStatus.value = 'Idle';
      identityRevealed.value = false;
      partnerIdentityRevealed.value = false;
      isHost.value = false;
    }
  }

  Future<void> revealIdentity() async {
    if (activeCall.value == null) return;

    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    String callId = activeCall.value!['callId'];
    bool isHostUser = activeCall.value!['hostUid'] == currentUser.uid;
    String field = isHostUser ? 'consentHost' : 'consentJoiner';

    print('🔓 Revealing identity - Field: $field');

    try {
      await _firestore.collection('calls').doc(callId).update({field: true});

      Get.snackbar(
        'Identity Revealed',
        'Your identity has been revealed',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      print('✅ Identity revealed');
    } catch (e) {
      print('❌ Error revealing identity: $e');
    }
  }

  Future<void> cancelMatching() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    print('🔵 Canceling matching...');

    isSearching.value = false;
    callStatus.value = 'Idle';
    isHost.value = false;

    // Delete any waiting calls
    QuerySnapshot waitingCalls = await _firestore
        .collection('callQueue')
        .where('hostUid', isEqualTo: currentUser.uid)
        .where('status', isEqualTo: 'waiting')
        .get();

    for (var doc in waitingCalls.docs) {
      await doc.reference.delete();
    }

    print('✅ Matching canceled');
  }

  @override
  void onClose() {
    print('🔵 Closing CallingController...');
    endCall();
    cancelMatching();
    super.onClose();
  }
}
