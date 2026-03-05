// controllers/chat_controller.dart
import 'package:dating_app/services/chatService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatController extends GetxController {
  final ChatService chatService = ChatService();

  final RxList<Map<String, dynamic>> chats = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final RxString currentChatId = ''.obs;
  final RxMap<String, dynamic> currentChatPartner = <String, dynamic>{}.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadChats();
  }

  // Load all chats for current user
  void loadChats() {
    chatService.getChatsStream().listen((snapshot) {
      chats.value = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {...data, 'id': doc.id, 'doc': doc};
      }).toList();
    });
  }

  // Load messages for specific chat
  void loadMessages(String chatId) {
    currentChatId.value = chatId;
    messages.clear();

    chatService.getMessagesStream(chatId).listen((snapshot) {
      messages.value = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          ...data,
          'id': doc.id,
          'timestamp': (data['timestamp'] as Timestamp?)?.toDate(),
        };
      }).toList();

      // Mark messages as read
      chatService.markMessagesAsRead(chatId);
    });
  }

  // Send text message
  Future<void> sendTextMessage(String text, String receiverId) async {
    if (text.trim().isEmpty) return;

    isSending.value = true;
    try {
      final chatId = await chatService.createOrGetChatRoom(
        otherUserId: receiverId,
        lastMessage: text,
        isVideoCall: false,
        isVoiceCall: false,
      );

      await chatService.sendTextMessage(
        chatId: chatId,
        receiverId: receiverId,
        message: text,
      );

      // Reload messages
      loadMessages(chatId);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send message: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSending.value = false;
    }
  }

  // Send image message
  Future<void> sendImageMessage(String receiverId) async {
    isSending.value = true;
    try {
      final imageFile = await chatService.pickImage();
      if (imageFile == null) return;

      final chatId = await chatService.createOrGetChatRoom(
        otherUserId: receiverId,
        lastMessage: '📷 Image',
        isVideoCall: false,
        isVoiceCall: false,
      );

      await chatService.sendImageMessage(
        chatId: chatId,
        receiverId: receiverId,
        imageFile: imageFile,
      );

      // Reload messages
      loadMessages(chatId);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSending.value = false;
    }
  }

  // Save screenshot warning
  Future<void> saveScreenshotWarning(String chatId, String receiverId) async {
    try {
      await chatService.saveScreenshotWarning(
        chatId: chatId,
        receiverId: receiverId,
      );
    } catch (e) {
      print('Error saving screenshot warning: $e');
    }
  }

  // Get other participant from chat
  Future<Map<String, dynamic>> getOtherParticipant(
    Map<String, dynamic> chat,
  ) async {
    final currentUserId = chatService.getCurrentUserId();
    final participants = List<String>.from(chat['participants'] ?? []);

    for (var participant in participants) {
      if (participant != currentUserId) {
        final profile = await chatService.getUserProfile(participant);
        return {'id': participant, ...profile};
      }
    }

    return {};
  }

  // Get unread count for chat
  int getUnreadCount(Map<String, dynamic> chat) {
    final currentUserId = chatService.getCurrentUserId();
    final unreadCount = chat['unreadCount'] as Map<String, dynamic>? ?? {};
    return (unreadCount[currentUserId] as int? ?? 0);
  }

  // Delete chat
  Future<void> deleteChat(String chatId) async {
    try {
      await chatService.deleteChat(chatId);
      chats.removeWhere((chat) => chat['chatId'] == chatId);
      Get.back();
      Get.snackbar(
        'Success',
        'Chat deleted',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete chat: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Clear all messages
  void clearMessages() {
    messages.clear();
    currentChatId.value = '';
    currentChatPartner.value = {};
  }
}
