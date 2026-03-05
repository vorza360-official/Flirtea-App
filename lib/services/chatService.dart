// services/chat_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get current user ID
  String getCurrentUserId() {
    return _auth.currentUser?.uid ?? '';
  }

  // Generate chat ID for two users
  String _generateChatId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort(); // Sort to ensure same chat ID regardless of order
    return '${ids[0]}_${ids[1]}';
  }

  // Create or get chat room
  Future<String> createOrGetChatRoom({
    required String otherUserId,
    required String lastMessage,
    required bool isVideoCall,
    required bool isVoiceCall,
  }) async {
    final currentUserId = getCurrentUserId();
    if (currentUserId.isEmpty) throw Exception('User not authenticated');

    final chatId = _generateChatId(currentUserId, otherUserId);

    try {
      final chatRef = _firestore.collection('chats').doc(chatId);
      final chatDoc = await chatRef.get();

      if (!chatDoc.exists) {
        await chatRef.set({
          'chatId': chatId,
          'participants': [currentUserId, otherUserId],
          'lastMessage': lastMessage,
          'lastMessageTime': FieldValue.serverTimestamp(),
          'isVideoCallOngoing': isVideoCall,
          'isVoiceCallOngoing': isVoiceCall,
          'createdAt': FieldValue.serverTimestamp(),
          'participantNames': {},
          'unreadCount': {currentUserId: 0, otherUserId: 0},
        });
      }

      return chatId;
    } catch (e) {
      print('Error creating chat room: $e');
      rethrow;
    }
  }

  // Send text message
  Future<void> sendTextMessage({
    required String chatId,
    required String receiverId,
    required String message,
  }) async {
    final currentUserId = getCurrentUserId();
    if (currentUserId.isEmpty) throw Exception('User not authenticated');

    try {
      // Add message to subcollection
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
            'senderId': currentUserId,
            'receiverId': receiverId,
            'message': message,
            'timestamp': FieldValue.serverTimestamp(),
            'type': 'text',
            'status': 'sent',
          });

      // Update chat document
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': message,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'isVideoCallOngoing': false,
        'isVoiceCallOngoing': false,
        'unreadCount.$receiverId': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }

  // Send image message
  Future<void> sendImageMessage({
    required String chatId,
    required String receiverId,
    required File imageFile,
  }) async {
    final currentUserId = getCurrentUserId();
    if (currentUserId.isEmpty) throw Exception('User not authenticated');

    try {
      // Upload image to storage
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = _storage
          .ref()
          .child('chat_images')
          .child(chatId)
          .child(fileName);

      final uploadTask = await storageRef.putFile(imageFile);
      final imageUrl = await uploadTask.ref.getDownloadURL();

      // Add message to subcollection
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
            'senderId': currentUserId,
            'receiverId': receiverId,
            'message': imageUrl,
            'timestamp': FieldValue.serverTimestamp(),
            'type': 'image',
            'status': 'sent',
          });

      // Update chat document
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': '📷 Image',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'isVideoCallOngoing': false,
        'isVoiceCallOngoing': false,
        'unreadCount.$receiverId': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error sending image: $e');
      rethrow;
    }
  }

  // Save screenshot warning to chat
  Future<void> saveScreenshotWarning({
    required String chatId,
    required String receiverId,
  }) async {
    final currentUserId = getCurrentUserId();
    if (currentUserId.isEmpty) return;

    try {
      // Add warning message to subcollection
      await _firestore.collection('chats').doc(chatId).collection('messages').add({
        'senderId': currentUserId,
        'receiverId': receiverId,
        'message':
            "Those who take screenshots will be punished.\nWe're not playing!",
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'warning',
        'status': 'sent',
      });

      // Update chat document
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': '⚠️ Screenshot detected',
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving screenshot warning: $e');
    }
  }

  // Get chat stream for list screen
  Stream<QuerySnapshot> getChatsStream() {
    final currentUserId = getCurrentUserId();
    if (currentUserId.isEmpty) {
      return const Stream.empty();
    }

    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  // Get messages stream for specific chat
  Stream<QuerySnapshot> getMessagesStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String chatId) async {
    final currentUserId = getCurrentUserId();
    if (currentUserId.isEmpty) return;

    try {
      // Update unread count
      await _firestore.collection('chats').doc(chatId).update({
        'unreadCount.$currentUserId': 0,
      });

      // Update message status
      final messages = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('receiverId', isEqualTo: currentUserId)
          .where('status', whereIn: ['sent', 'delivered'])
          .get();

      for (var doc in messages.docs) {
        await doc.reference.update({'status': 'seen'});
      }
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  // Update message status
  Future<void> updateMessageStatus(
    String chatId,
    String messageId,
    String status,
  ) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({'status': status});
    } catch (e) {
      print('Error updating message status: $e');
    }
  }

  // Get user profile
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data() ?? {};
    } catch (e) {
      print('Error getting user profile: $e');
      return {};
    }
  }

  // Delete chat
  Future<void> deleteChat(String chatId) async {
    try {
      await _firestore.collection('chats').doc(chatId).delete();
    } catch (e) {
      print('Error deleting chat: $e');
      rethrow;
    }
  }

  // Save call to chat (from CallScreen)
  Future<void> saveCallToChat({
    required String otherUserId,
    required Map<String, dynamic> callData,
  }) async {
    final currentUserId = getCurrentUserId();
    if (currentUserId.isEmpty) return;

    try {
      final chatId = _generateChatId(currentUserId, otherUserId);
      final callDuration =
          callData['endTime'] != null && callData['startTime'] != null
          ? _calculateCallDuration(callData['startTime'], callData['endTime'])
          : 'Unknown duration';

      final callMessage = callData['callType'] == 'video'
          ? '🎥 Video call ($callDuration)'
          : '📞 Voice call ($callDuration)';

      // Create or update chat room
      await createOrGetChatRoom(
        otherUserId: otherUserId,
        lastMessage: callMessage,
        isVideoCall: false,
        isVoiceCall: false,
      );

      // Add call as a message
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
            'senderId': currentUserId,
            'receiverId': otherUserId,
            'message': callMessage,
            'timestamp': FieldValue.serverTimestamp(),
            'type': 'system',
            'status': 'sent',
            'callData': callData,
          });
    } catch (e) {
      print('Error saving call to chat: $e');
    }
  }

  String _calculateCallDuration(Timestamp start, Timestamp end) {
    final duration = end.toDate().difference(start.toDate());
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    if (minutes > 0) {
      return '$minutes min ${seconds > 0 ? '$seconds sec' : ''}';
    }
    return '$seconds sec';
  }

  // Pick image from gallery
  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}
