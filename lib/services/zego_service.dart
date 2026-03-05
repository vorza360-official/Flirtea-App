import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ZegoService {
  static const int appId = 1518308285;
  static const String appSign =
      'e941c7c0778c69f5cb62609c857317ea7e47ec29beb111af155e8dff79faa614';

  static ZegoService? _instance;
  ZegoExpressEngine? _engine;

  // Track camera state manually since Zego doesn't provide getter
  bool _isFrontCamera = true;

  // Track if audio/video is enabled
  bool _isAudioEnabled = true;
  bool _isVideoEnabled = false;

  // Track if we're in a room
  bool _isInRoom = false;
  String? _currentRoomId;
  String? _currentUserId;

  // Cache for video views
  final Map<String, Widget> _remoteVideoViewCache = {};
  Widget? _localVideoViewCache;

  // Audio level streams
  final StreamController<double> _localAudioLevelController =
      StreamController<double>.broadcast();
  final StreamController<double> _remoteAudioLevelController =
      StreamController<double>.broadcast();

  // Connection state
  final StreamController<bool> _remoteUserJoinedController =
      StreamController<bool>.broadcast();

  // Streams for identity reveal
  final StreamController<bool> _identityRevealedController =
      StreamController<bool>.broadcast();

  Stream<double> get localAudioLevel => _localAudioLevelController.stream;
  Stream<double> get remoteAudioLevel => _remoteAudioLevelController.stream;
  Stream<bool> get remoteUserJoined => _remoteUserJoinedController.stream;
  Stream<bool> get identityRevealed => _identityRevealedController.stream;

  // Getters for camera state
  bool get isFrontCamera => _isFrontCamera;
  bool get isAudioEnabled => _isAudioEnabled;
  bool get isVideoEnabled => _isVideoEnabled;
  bool get isInRoom => _isInRoom;

  factory ZegoService() {
    _instance ??= ZegoService._internal();
    return _instance!;
  }

  ZegoService._internal();

  Future<void> initEngine() async {
    if (_engine != null) {
      print('✅ Zego engine already initialized');
      return;
    }

    print('🔵 Initializing Zego engine...');

    await ZegoExpressEngine.createEngineWithProfile(
      ZegoEngineProfile(
        appId,
        ZegoScenario.StandardVideoCall, // Better for video/audio calls
        appSign: appSign,
      ),
    );

    _engine = ZegoExpressEngine.instance;

    // Set up event handlers
    _setupEventHandlers();

    print('✅ Zego engine initialized successfully');
  }

  void _setupEventHandlers() {
    print('🔵 Setting up Zego event handlers...');

    // Monitor remote user join/leave
    ZegoExpressEngine.onRoomUserUpdate = (roomID, updateType, userList) {
      print(
        '👥 Room user update - Room: $roomID, Type: $updateType, Users: ${userList.length}',
      );
      if (updateType == ZegoUpdateType.Add) {
        _remoteUserJoinedController.add(true);
        print('✅ Remote user joined');
      } else if (updateType == ZegoUpdateType.Delete) {
        _remoteUserJoinedController.add(false);
        print('❌ Remote user left');
      }
    };

    // Monitor audio level for local user
    ZegoExpressEngine.onCapturedSoundLevelUpdate = (soundLevel) {
      _localAudioLevelController.add(soundLevel.toDouble());
    };

    // Monitor audio level for remote users
    ZegoExpressEngine.onRemoteSoundLevelUpdate = (soundLevels) {
      if (soundLevels.isNotEmpty) {
        _remoteAudioLevelController.add(soundLevels.values.first.toDouble());
      }
    };

    // Monitor room state changes
    ZegoExpressEngine
        .onRoomStateUpdate = (roomID, state, errorCode, extendedData) {
      print(
        '🏠 Room state update - Room: $roomID, State: $state, Error: $errorCode',
      );
      if (errorCode != 0) {
        print('❌ Room error: $errorCode');
      }
    };

    // Monitor stream updates
    ZegoExpressEngine
        .onRoomStreamUpdate = (roomID, updateType, streamList, extendedData) {
      print(
        '🎥 Stream update - Room: $roomID, Type: $updateType, Streams: ${streamList.length}',
      );
      for (var stream in streamList) {
        print('   Stream ID: ${stream.streamID}, User: ${stream.user.userID}');
      }

      // Auto-play remote streams when they become available
      if (updateType == ZegoUpdateType.Add) {
        for (var stream in streamList) {
          // Don't play our own stream
          if (!stream.streamID.endsWith('_$_currentUserId')) {
            print('🔄 Auto-playing new stream: ${stream.streamID}');
            Future.delayed(const Duration(milliseconds: 500), () {
              startPlayingRemoteStream(stream.streamID);
            });
          }
        }
      }
    };

    // Monitor player state
    ZegoExpressEngine
        .onPlayerStateUpdate = (streamID, state, errorCode, extendedData) {
      print(
        '▶️ Player state - Stream: $streamID, State: $state, Error: $errorCode',
      );

      if (errorCode != 0) {
        print('❌ Player error detected, attempting recovery...');
        // Attempt to restart playback on error
        Future.delayed(const Duration(seconds: 1), () async {
          try {
            await _engine?.stopPlayingStream(streamID);
            await Future.delayed(const Duration(milliseconds: 500));
            await _engine?.startPlayingStream(streamID);
            print('🔄 Player recovery attempted');
          } catch (e) {
            print('❌ Player recovery failed: $e');
          }
        });
      }

      if (state == ZegoPlayerState.Playing) {
        print('✅ Remote stream is now playing');
      }
    };

    // Monitor publisher state
    ZegoExpressEngine
        .onPublisherStateUpdate = (streamID, state, errorCode, extendedData) {
      print(
        '📤 Publisher state - Stream: $streamID, State: $state, Error: $errorCode',
      );
    };
  }

  Future<void> joinRoom(String roomId, String userId, String userName) async {
    if (_isInRoom && _currentRoomId == roomId) {
      print('⚠️ Already in room $roomId');
      return;
    }

    print(
      '🔵 Joining room - RoomID: $roomId, UserID: $userId, UserName: $userName',
    );

    await initEngine();

    _currentRoomId = roomId;
    _currentUserId = userId;

    try {
      // Login to room
      await _engine?.loginRoom(roomId, ZegoUser(userId, userName));
      print('✅ Logged into room successfully');

      _isInRoom = true;

      // Start publishing stream
      String streamId = '${roomId}_$userId';
      await _engine?.startPublishingStream(streamId);
      print('✅ Started publishing stream: $streamId');

      // Start preview for local video
      await _engine?.startPreview();
      print('✅ Started preview');

      // Enable audio level monitoring
      await _engine?.startSoundLevelMonitor(); // Default monitoring interval
      print('✅ Started sound level monitor');

      // Enable audio by default (but not video)
      await enableAudio(true);
      await enableVideo(false);

      print('✅ Successfully joined room and started streaming');
    } catch (e) {
      print('❌ Error joining room: $e');
      _isInRoom = false;
      rethrow;
    }
  }

  Future<void> startPlayingRemoteStream(String streamId) async {
    if (!_isInRoom) {
      print('⚠️ Cannot play stream, not in room yet');
      return;
    }

    try {
      print('🔵 Starting to play remote stream: $streamId');

      // Stop any existing playback first
      await _engine?.stopPlayingStream(streamId);
      await Future.delayed(const Duration(milliseconds: 300));

      // Start playing the stream
      await _engine?.startPlayingStream(streamId);
      print('✅ Started playing remote stream successfully');
    } catch (e) {
      print('❌ Error starting remote stream: $e');

      // Retry once after a delay
      await Future.delayed(const Duration(seconds: 1));
      try {
        print('🔄 Retrying remote stream playback...');
        await _engine?.startPlayingStream(streamId);
        print('✅ Retry successful');
      } catch (retryError) {
        print('❌ Retry failed: $retryError');
      }
    }
  }

  Future<void> enableVideo(bool enable) async {
    try {
      print('🔵 ${enable ? 'Enabling' : 'Disabling'} video...');
      _isVideoEnabled = enable;

      if (enable) {
        // When enabling video, ensure camera is on and preview is running
        await _engine?.enableCamera(true);
        await _engine?.startPreview();
        await _engine?.mutePublishStreamVideo(false);
      } else {
        // When disabling video
        await _engine?.mutePublishStreamVideo(true);
        await _engine?.enableCamera(false);
      }

      print('✅ Video ${enable ? 'enabled' : 'disabled'}');
    } catch (e) {
      print('❌ Error enabling video: $e');
      rethrow;
    }
  }

  Future<void> enableAudio(bool enable) async {
    try {
      print('🔵 ${enable ? 'Enabling' : 'Disabling'} audio...');
      _isAudioEnabled = enable;
      await _engine?.muteMicrophone(!enable);
      await _engine?.mutePublishStreamAudio(!enable);
      print('✅ Audio ${enable ? 'enabled' : 'disabled'}');
    } catch (e) {
      print('❌ Error enabling audio: $e');
      rethrow;
    }
  }

  Future<void> switchCamera() async {
    try {
      print('🔵 Switching camera...');
      _isFrontCamera = !_isFrontCamera;
      await _engine?.useFrontCamera(_isFrontCamera);
      print('✅ Switched to ${_isFrontCamera ? 'front' : 'back'} camera');
    } catch (e) {
      print('❌ Error switching camera: $e');
    }
  }

  // Check available streams in room
  // Check available streams in room
  Future<List<String>> getAvailableStreams() async {
    try {
      if (!_isInRoom || _currentRoomId == null) {
        print('⚠️ Not in a room to check streams');
        return [];
      }

      // Zego doesn't have a direct method to query streams
      // Instead, streams are tracked via the onRoomStreamUpdate callback
      print('📋 Available streams monitoring is active');

      // We can't directly query streams, so we return empty and rely on onRoomStreamUpdate
      // The streams are already being auto-played in onRoomStreamUpdate handler
      return [];

      // Alternative: If you need to manually track streams, maintain a list
      // but Zego's callback-based approach is more reliable
    } catch (e) {
      print('❌ Error in stream monitoring: $e');
    }
    return [];
  }

  Future<Widget?> buildLocalVideoView() async {
    // Return cached view if available
    if (_localVideoViewCache != null) {
      print('📱 Returning cached local video view');
      return _localVideoViewCache;
    }

    print('🔵 Building local video view...');
    final view = await ZegoExpressEngine.instance.createCanvasView((viewID) {
      print('📱 Local video view created with ID: $viewID');
      _engine?.startPreview(canvas: ZegoCanvas(viewID));
    });

    _localVideoViewCache = view;
    print('✅ Local video view built successfully');
    return view;
  }

  Future<Widget?> buildRemoteVideoView(String streamId) async {
    // Return cached view if available
    if (_remoteVideoViewCache.containsKey(streamId)) {
      print('📱 Returning cached remote video view for: $streamId');
      return _remoteVideoViewCache[streamId];
    }

    print('🔵 Building remote video view for: $streamId');
    final view = await ZegoExpressEngine.instance.createCanvasView((viewID) {
      print(
        '📱 Remote video view created with ID: $viewID for stream: $streamId',
      );
      _engine?.startPlayingStream(streamId, canvas: ZegoCanvas(viewID));
    });

    _remoteVideoViewCache[streamId] = view!;
    print('✅ Remote video view built successfully');
    return view;
  }

  // Notify identity reveal
  void notifyIdentityRevealed() {
    print('🔵 Notifying identity revealed');
    _identityRevealedController.add(true);
  }

  // Cache management methods
  void clearLocalVideoCache() {
    print('🗑️ Clearing local video cache');
    _localVideoViewCache = null;
  }

  void clearRemoteVideoCache(String streamId) {
    print('🗑️ Clearing remote video cache for: $streamId');
    _remoteVideoViewCache.remove(streamId);
  }

  void clearAllVideoCaches() {
    print('🗑️ Clearing all video caches');
    _localVideoViewCache = null;
    _remoteVideoViewCache.clear();
  }

  Future<void> leaveRoom() async {
    if (!_isInRoom) {
      print('⚠️ Not in a room, nothing to leave');
      return;
    }

    print('🔵 Leaving room: $_currentRoomId');

    try {
      await _engine?.stopSoundLevelMonitor();
      print('✅ Stopped sound level monitor');

      await _engine?.stopPreview();
      print('✅ Stopped preview');

      await _engine?.stopPublishingStream();
      print('✅ Stopped publishing stream');

      await _engine?.logoutRoom();
      print('✅ Logged out of room');

      _isInRoom = false;
      _currentRoomId = null;
      _currentUserId = null;
    } catch (e) {
      print('❌ Error leaving room: $e');
    }

    // Clear video caches when leaving room
    clearAllVideoCaches();
  }

  Future<void> cleanUpAllResources() async {
    print('🔵 Cleaning up all Zego resources...');

    // Stop all streams first
    try {
      if (_isInRoom) {
        await leaveRoom();
      }
    } catch (e) {
      print('❌ Error cleaning resources: $e');
    }

    // Clear caches
    clearAllVideoCaches();

    print('✅ Resources cleaned up');
  }

  void dispose() {
    print('🔵 Disposing ZegoService...');
    _localAudioLevelController.close();
    _remoteAudioLevelController.close();
    _remoteUserJoinedController.close();
    _identityRevealedController.close();
    ZegoExpressEngine.destroyEngine();
    _engine = null;
    _instance = null;
    print('✅ ZegoService disposed');
  }
}
