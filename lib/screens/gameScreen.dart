import 'package:dating_app/controller/calling_controller.dart';
import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/services/chatService.dart';
import 'package:dating_app/services/zego_service.dart';
import 'package:dating_app/widgets/zego_video_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> with TickerProviderStateMixin {
  final Color myPurple = const Color(0xFF8B5CF6);
  final CallingController callingController = Get.put(CallingController());
  final ZegoService zegoService = ZegoService();
  final GenderController genderController = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isVideoEnabled = false;
  bool isAudioEnabled = true;
  bool hasJoinedRoom = false;

  double localAudioLevel = 0.0;
  double remoteAudioLevel = 0.0;

  late AnimationController _audioAnimController;
  late AnimationController _remoteAudioAnimController;

  List<String> selectedGeoList = [];
  final List<String> locations = [
    'London',
    'German',
    'English',
    'Persian',
    'Italian',
    'Korean',
    'Chinese',
    'Spanish',
    'French',
    'Arabic',
    'Hindi',
    'British English',
    'Urdu',
  ];

  void _handleCallEnd() async {
    print('🔴 Handling call end...');

    // Leave Zego room if joined
    if (hasJoinedRoom) {
      await zegoService.leaveRoom();
      hasJoinedRoom = false;
    }

    // Reset states
    if (mounted) {
      setState(() {
        isVideoEnabled = false;
        isAudioEnabled = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _audioAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _remoteAudioAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    // Listen to audio levels
    zegoService.localAudioLevel.listen((level) {
      if (mounted) {
        setState(() => localAudioLevel = level);
      }
      if (level > 30) {
        _audioAnimController.forward();
      } else {
        _audioAnimController.reverse();
      }
    });

    zegoService.remoteAudioLevel.listen((level) {
      if (mounted) {
        setState(() => remoteAudioLevel = level);
      }
      if (level > 30) {
        _remoteAudioAnimController.forward();
      } else {
        _remoteAudioAnimController.reverse();
      }
    });

    zegoService.remoteUserJoined.listen((joined) {
      print('👥 Remote user joined status: $joined');
      if (mounted) {
        setState(() {});
      }
      if (joined) {
        // Give extra time for remote stream to be ready
        Future.delayed(const Duration(seconds: 2), () {
          _startPlayingRemoteStream();
        });
      }
    });

    // Listen for identity reveal
    zegoService.identityRevealed.listen((revealed) {
      if (mounted && revealed) {
        setState(() {});
      }
    });

    // Listen for partner identity reveal
    callingController.partnerIdentityRevealed.listen((revealed) {
      if (mounted && revealed) {
        Get.snackbar(
          'Partner Revealed Identity',
          'Your partner has revealed their identity',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    });

    // Listen for video enable from Firebase
    ever(callingController.activeCall, (call) async {
      if (call != null && mounted) {
        bool videoEnabled = call['videoEnabled'] ?? false;

        // If video is enabled but local state doesn't match
        if (videoEnabled && !isVideoEnabled) {
          print('🎥 Auto-enabling video after identity reveal...');

          // Enable video in Zego
          await zegoService.enableVideo(true);

          if (mounted) {
            setState(() {
              isVideoEnabled = true;
            });
          }

          // Clear video caches to force rebuild
          zegoService.clearAllVideoCaches();

          // Rebuild UI
          if (mounted) {
            setState(() {});
          }
        }
      }
    });

    // CRITICAL: Listen for active call changes to join Zego room
    ever(callingController.activeCall, (call) {
      if (call != null && mounted && !hasJoinedRoom) {
        _handleCallConnection();
      } else if (call == null && hasJoinedRoom) {
        // Call ended by other user, clean up
        print('🔴 Call ended remotely, cleaning up...');
        _handleCallEnd();
      }
    });
  }

  // NEW: Handle Zego room connection when call starts
  void _handleCallConnection() async {
    final call = callingController.activeCall.value;
    if (call == null || hasJoinedRoom) return;

    final myUid = _auth.currentUser?.uid;
    if (myUid == null) return;

    try {
      hasJoinedRoom = true;
      final roomId = call['roomId'];
      final userName = _auth.currentUser?.displayName ?? 'User';

      print('🔵 Joining Zego room: $roomId as $myUid');

      // Initialize and join the Zego room
      await zegoService.initEngine();
      await zegoService.joinRoom(roomId, myUid, userName);

      // Enable audio by default
      await zegoService.enableAudio(true);

      if (mounted) {
        setState(() {
          isAudioEnabled = true;
        });
      }

      print('✅ Successfully joined Zego room');

      // Wait for remote user and start playing their stream
      await Future.delayed(const Duration(seconds: 2));

      // Try to play remote stream (in case user already joined)
      _startPlayingRemoteStream();

      // Check for available streams periodically
      _startStreamCheck();
    } catch (e) {
      print('❌ Error joining Zego room: $e');
      hasJoinedRoom = false;
      Get.snackbar(
        'Connection Error',
        'Failed to connect to call: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // NEW: Periodically check for available streams
  void _startStreamCheck() {
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (!mounted || !hasJoinedRoom) {
        timer.cancel();
        return;
      }

      final streams = await zegoService.getAvailableStreams();
      final call = callingController.activeCall.value;

      if (call != null && streams.isNotEmpty) {
        final myUid = _auth.currentUser?.uid;
        final peerUid = myUid == call['hostUid']
            ? call['joinerUid']
            : call['hostUid'];
        final expectedStreamId = '${call['roomId']}_$peerUid';

        if (streams.contains(expectedStreamId)) {
          print('✅ Found expected remote stream, starting playback');
          _startPlayingRemoteStream();
          timer.cancel(); // Stop checking once found
        }
      }
    });
  }

  void _startPlayingRemoteStream() async {
    final call = callingController.activeCall.value;
    if (call == null) {
      print('⚠️ No active call for remote stream');
      return;
    }

    final myUid = _auth.currentUser?.uid;
    if (myUid == null) {
      print('⚠️ No current user for remote stream');
      return;
    }

    final peerUid = myUid == call['hostUid']
        ? call['joinerUid']
        : call['hostUid'];

    final streamId = '${call['roomId']}_$peerUid';
    print('🎵 Starting to play remote stream: $streamId');

    // Wait a bit to ensure remote user has started publishing
    await Future.delayed(const Duration(milliseconds: 1500));

    await zegoService.startPlayingRemoteStream(streamId);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    print('🔵 CallScreen disposing...');
    _audioAnimController.dispose();
    _remoteAudioAnimController.dispose();

    // Only cleanup if we're actually leaving the screen permanently
    // Don't cleanup on hot reload or temporary navigation
    if (hasJoinedRoom) {
      print('🔵 Cleaning up Zego resources...');
      zegoService.clearAllVideoCaches();
      zegoService.cleanUpAllResources();
      hasJoinedRoom = false;
    }

    // Only cancel matching if still searching
    if (callingController.isSearching.value) {
      callingController.cancelMatching();
    }

    super.dispose();
    print('✅ CallScreen disposed');
  }

  void _applyFilters() async {
    // Reset local state before starting
    selectedGeoList.isNotEmpty
        ? callingController.selectedRegion.value = selectedGeoList.first
        : callingController.selectedRegion.value = 'Global';

    // Close bottom sheet first
    if (mounted) Navigator.pop(context);

    // Start matching
    await callingController.startMatching();
  }

  void _showSettingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Set Up Your Game',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose your preferences to find the perfect match',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Target Location',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: locations
                      .map(
                        (loc) => Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setModalState(() {
                                if (selectedGeoList.contains(loc)) {
                                  selectedGeoList.remove(loc);
                                } else {
                                  selectedGeoList.clear();
                                  selectedGeoList.add(loc);
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: selectedGeoList.contains(loc)
                                    ? myPurple
                                    : Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: selectedGeoList.contains(loc)
                                      ? myPurple
                                      : Colors.white.withOpacity(0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                loc,
                                style: TextStyle(
                                  color: selectedGeoList.contains(loc)
                                      ? Colors.white
                                      : Colors.white70,
                                  fontWeight: selectedGeoList.contains(loc)
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [myPurple, myPurple.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: myPurple.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: selectedGeoList.isNotEmpty ? _applyFilters : null,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.search, color: Colors.white),
                            SizedBox(width: 12),
                            Text(
                              'Start Matching',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAudioIndicator(double level, bool isLocal) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      width: 60 + (level / 2),
      height: 60 + (level / 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            myPurple.withOpacity(0.6),
            myPurple.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(shape: BoxShape.circle, color: myPurple),
          child: Icon(
            isLocal ? Icons.person : Icons.person_outline,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final call = callingController.activeCall.value;
        bool isConnected = call != null;
        bool isSearching = callingController.isSearching.value;
        bool isAnonymous = call?['anonymous'] ?? true;
        bool videoEnabledInCall = call?['videoEnabled'] ?? false;
        bool partnerRevealed = callingController.partnerIdentityRevealed.value;
        bool userRevealed = callingController.identityRevealed.value;
        bool isHost = callingController.isHost.value;

        // Sync local video state with Firebase
        if (isConnected && videoEnabledInCall != isVideoEnabled) {
          isVideoEnabled = videoEnabledInCall;
        }

        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                genderController.selectedGender.value == Gender.male
                    ? "assets/images/gameBg.png"
                    : genderController.selectedGender.value == Gender.female
                    ? "assets/images/female/gameBg.png"
                    : "assets/images/nonBinary/gameBg.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                children: [
                  // Upper portion - Remote User
                  Expanded(
                    flex: 1,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: Stack(
                        children: [
                          // Video view when video is enabled
                          if (isConnected &&
                              videoEnabledInCall &&
                              isVideoEnabled)
                            ZegoVideoView(
                              key: ValueKey(
                                'remote_video_${call!['roomId']}_${_auth.currentUser?.uid == call['hostUid'] ? call['joinerUid'] : call['hostUid']}',
                              ),
                              createVideoView: () =>
                                  zegoService.buildRemoteVideoView(
                                    '${call['roomId']}_${_auth.currentUser?.uid == call['hostUid'] ? call['joinerUid'] : call['hostUid']}',
                                  ),
                              streamId:
                                  '${call['roomId']}_${_auth.currentUser?.uid == call['hostUid'] ? call['joinerUid'] : call['hostUid']}',
                              zegoService: zegoService,
                              placeholder: Container(
                                color: Colors.black.withOpacity(0.5),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: myPurple,
                                  ),
                                ),
                              ),
                            )
                          // Audio indicator when in audio mode
                          else if (isConnected)
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildAudioIndicator(remoteAudioLevel, false),
                                  const SizedBox(height: 20),
                                  Text(
                                    isAnonymous
                                        ? 'Anonymous'
                                        : (partnerRevealed
                                              ? 'Matched User'
                                              : 'Anonymous'),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black45,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          remoteAudioLevel > 30
                                              ? Icons.graphic_eq
                                              : Icons.mic,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          remoteAudioLevel > 30
                                              ? 'Speaking...'
                                              : 'Listening',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          // Searching UI
                          else if (isSearching)
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: myPurple,
                                    strokeWidth: 3,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    callingController.callStatus.value,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    isHost
                                        ? 'You are waiting for a match...'
                                        : 'Looking for compatible users...',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  if (isHost)
                                    ElevatedButton(
                                      onPressed: () {
                                        callingController.cancelMatching();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Cancel Search',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                ],
                              ),
                            )
                          else
                            Center(
                              child: Image.asset(
                                'assets/images/notConnected.png',
                                fit: BoxFit.contain,
                              ),
                            ),

                          // Anonymous badge or Revealed badge
                          if (isConnected)
                            Positioned(
                              top: 16,
                              left: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isAnonymous && !partnerRevealed
                                        ? myPurple
                                        : Colors.green,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isAnonymous && !partnerRevealed
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      isAnonymous && !partnerRevealed
                                          ? "Anonymous Mode"
                                          : "Identity Revealed",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (isConnected)
                            Positioned(
                              top: 16,
                              right: 16,
                              child: _buildSaveToChatButton(),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Center ball logo (when not connected)
                  if (!isConnected && !isSearching)
                    GestureDetector(
                      onTap: _showSettingsBottomSheet,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: myPurple.withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                          image: const DecorationImage(
                            image: AssetImage('assets/images/ball_logo.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Lower portion - Local User
                  Expanded(
                    flex: 1,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.black.withOpacity(0.3),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child:
                                isConnected &&
                                    videoEnabledInCall &&
                                    isVideoEnabled
                                ? ZegoVideoView(
                                    key: const ValueKey('local_video'),
                                    createVideoView: () =>
                                        zegoService.buildLocalVideoView(),
                                    zegoService: zegoService,
                                    placeholder: Container(
                                      color: Colors.black.withOpacity(0.5),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: myPurple,
                                        ),
                                      ),
                                    ),
                                  )
                                : isConnected
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        _buildAudioIndicator(
                                          localAudioLevel,
                                          true,
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          userRevealed
                                              ? 'You (Revealed)'
                                              : 'You',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black45,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                localAudioLevel > 30
                                                    ? Icons.graphic_eq
                                                    : Icons.mic,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                localAudioLevel > 30
                                                    ? 'Speaking...'
                                                    : 'Listening',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Image.asset(
                                    'assets/images/user_avatar.jpg',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),

                        // Bottom controls
                        if (isConnected)
                          Positioned(
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Microphone toggle
                                _buildControlButton(
                                  icon: isAudioEnabled
                                      ? Icons.mic
                                      : Icons.mic_off,
                                  onTap: () async {
                                    if (mounted) {
                                      setState(
                                        () => isAudioEnabled = !isAudioEnabled,
                                      );
                                    }
                                    await zegoService.enableAudio(
                                      isAudioEnabled,
                                    );
                                  },
                                  color: isAudioEnabled
                                      ? Colors.white24
                                      : Colors.red,
                                ),

                                // Reveal Identity (only in anonymous mode)
                                if (isAnonymous && !userRevealed)
                                  _buildControlButton(
                                    icon: Icons.visibility,
                                    label: 'Reveal',
                                    onTap: () {
                                      callingController.revealIdentity();
                                      zegoService.notifyIdentityRevealed();
                                    },
                                    color: myPurple,
                                  ),

                                // Video toggle (only after both revealed)
                                if (!isAnonymous ||
                                    (partnerRevealed && userRevealed))
                                  _buildControlButton(
                                    icon: isVideoEnabled
                                        ? Icons.videocam
                                        : Icons.videocam_off,
                                    onTap: () async {
                                      bool newVideoState = !isVideoEnabled;

                                      if (mounted) {
                                        setState(
                                          () => isVideoEnabled = newVideoState,
                                        );
                                      }

                                      await zegoService.enableVideo(
                                        newVideoState,
                                      );

                                      // Update Firebase
                                      if (call != null) {
                                        await _firestore
                                            .collection('calls')
                                            .doc(call['callId'])
                                            .update({
                                              'videoEnabled': newVideoState,
                                            });
                                      }
                                    },
                                    color: isVideoEnabled
                                        ? Colors.white24
                                        : Colors.red,
                                  ),

                                // Switch camera (only in video mode)
                                if (isVideoEnabled)
                                  _buildControlButton(
                                    icon: Icons.flip_camera_ios,
                                    onTap: () async {
                                      await zegoService.switchCamera();
                                      if (mounted) {
                                        setState(() {});
                                      }
                                    },
                                    color: Colors.white24,
                                  ),

                                // End call button
                                _buildControlButton(
                                  icon: Icons.call_end,
                                  onTap: () async {
                                    print('🔴 End call button pressed');

                                    // Leave Zego room first
                                    await zegoService.leaveRoom();

                                    // End call in Firebase (deletes document)
                                    await callingController.endCall();

                                    // Reset state
                                    hasJoinedRoom = false;

                                    if (mounted) {
                                      setState(() {
                                        isVideoEnabled = false;
                                        isAudioEnabled = true;
                                      });

                                      // Navigate back
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  color: Colors.red,
                                  size: 55,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // Add this to CallScreen class
  Widget _buildSaveToChatButton() {
    final call = callingController.activeCall.value;
    final partnerRevealed = callingController.partnerIdentityRevealed.value;
    final userRevealed = callingController.identityRevealed.value;

    // Show only when both identities are revealed
    if (call != null && partnerRevealed && userRevealed) {
      return Positioned(
        top: 16,
        right: 16,
        child: GestureDetector(
          onTap: () async {
            // Get the other user's ID
            final currentUserId = _auth.currentUser?.uid;
            if (currentUserId == null) return;

            final otherUserId = currentUserId == call['hostUid']
                ? call['joinerUid']
                : call['hostUid'];

            // Save call to chat
            final chatService = ChatService();
            await chatService.saveCallToChat(
              otherUserId: otherUserId,
              callData: call,
            );

            Get.snackbar(
              'Success',
              'Call saved to chat',
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: Duration(seconds: 2),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.4),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.chat, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text(
                  'Save to Chat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox.shrink();
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
    String? label,
    double size = 50,
  }) {
    if (label != null) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.5),
      ),
    );
  }
}
