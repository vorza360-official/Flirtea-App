import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

class JitsiService {
  final _jitsiMeet = JitsiMeet();

  // This holds the listener to prevent it from being garbage collected
  JitsiMeetEventListener? _currentListener;

  // Join a conference (this will open Jitsi in full screen/overlay)
  Future<void> joinConference({
    required String roomName,
    required String userName,
    required bool isAudioOnly,
    required bool isVideoMuted,
    required Function(String) onConferenceJoined,
    required Function(String, dynamic) onConferenceTerminated,
    required Function() onReadyToClose,
  }) async {
    var options = JitsiMeetConferenceOptions(
      room: roomName,
      configOverrides: {
        "startWithAudioMuted": false,
        "startWithVideoMuted": isVideoMuted,
        "audioOnly": isAudioOnly,
      },
      featureFlags: {
        "unwelcome_page_enabled": false,
        "resolution": 360,
        "recording.enabled": false,
        "toolbox.enabled": false,
        "filmstrip.enabled": false,
        "preJoinPageEnabled": false, // Skip pre-join page
        "welcomePageEnabled": false, // Skip welcome page
      },
      userInfo: JitsiMeetUserInfo(displayName: userName),
    );

    _currentListener = JitsiMeetEventListener(
      conferenceJoined: (url) {
        debugPrint("conferenceJoined: url: $url");
        onConferenceJoined(url);
      },
      conferenceTerminated: (url, error) {
        debugPrint("conferenceTerminated: url: $url, error: $error");
        onConferenceTerminated(url, error);
      },
      conferenceWillJoin: (url) {
        debugPrint("conferenceWillJoin: url: $url");
      },
      participantJoined: (email, name, role, participantId) {
        debugPrint(
          "participantJoined: email: $email, name: $name, role: $role, "
          "participantId: $participantId",
        );
      },
      participantLeft: (participantId) {
        debugPrint("participantLeft: participantId: $participantId");
      },
      audioMutedChanged: (muted) {
        debugPrint("audioMutedChanged: isMuted: $muted");
      },
      videoMutedChanged: (muted) {
        debugPrint("videoMutedChanged: isMuted: $muted");
      },
      endpointTextMessageReceived: (senderId, message) {
        debugPrint(
          "endpointTextMessageReceived: senderId: $senderId, message: $message",
        );
      },
      screenShareToggled: (participantId, sharing) {
        debugPrint(
          "screenShareToggled: participantId: $participantId, "
          "isSharing: $sharing",
        );
      },
      chatMessageReceived: (senderId, message, isPrivate, timestamp) {
        debugPrint(
          "chatMessageReceived: senderId: $senderId, message: $message, "
          "isPrivate: $isPrivate, timestamp: $timestamp",
        );
      },
      chatToggled: (isOpen) => debugPrint("chatToggled: isOpen: $isOpen"),
      participantsInfoRetrieved: (participantsInfo) {
        debugPrint(
          "participantsInfoRetrieved: participantsInfo: $participantsInfo",
        );
      },
      readyToClose: () {
        debugPrint("readyToClose");
        onReadyToClose();
      },
    );

    await _jitsiMeet.join(options, _currentListener!);
  }

  Future<void> setAudioMuted(bool muted) async {
    await _jitsiMeet.setAudioMuted(muted);
  }

  Future<void> setVideoMuted(bool muted) async {
    await _jitsiMeet.setVideoMuted(muted);
  }

  Future<void> hangUp() async {
    await _jitsiMeet.hangUp();
  }

  void dispose() {
    _currentListener = null;
  }
}
