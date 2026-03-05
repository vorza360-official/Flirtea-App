// screens/chat_screen.dart
import 'package:dating_app/controller/chatController.dart';
import 'package:dating_app/screens/report_screen.dart';
import 'package:dating_app/services/report_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String partnerId;
  final String partnerName;
  final String? partnerPhoto;

  const ChatScreen({
    Key? key,
    required this.chatId,
    required this.partnerId,
    required this.partnerName,
    this.partnerPhoto,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final ChatController chatController = Get.find<ChatController>();
  final ReportService _reportService = ReportService();
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool isExpanded = false;
  final Color myPurple = const Color(0xFF8B5CF6);
  bool showWarning = false;
  static const platform = MethodChannel('com.example.screenshot_detection');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    chatController.loadMessages(widget.chatId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    _setupScreenshotDetection();
  }

  void _setupScreenshotDetection() {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'onScreenshot') {
        _handleScreenshotDetected();
      }
    });
  }

  void _handleScreenshotDetected() {
    setState(() => showWarning = true);
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) setState(() => showWarning = false);
    });
    chatController.saveScreenshotWarning(widget.chatId, widget.partnerId);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _handleScreenshotDetected();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    chatController.clearMessages();
    super.dispose();
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      await chatController.sendTextMessage(text, widget.partnerId);
      messageController.clear();
      _scrollToBottom();
    }
  }

  Future<void> _sendImage() async {
    await chatController.sendImageMessage(widget.partnerId);
    _scrollToBottom();
  }

  // ─────────────────────────────────────────────────────────────
  // Long-press bottom sheet for RECEIVED messages
  // ─────────────────────────────────────────────────────────────

  void _showMessageOptions(Map<String, dynamic> message) {
    final messageId = message['id'] as String? ?? '';
    final messageText = message['message'] ?? '';
    final messageType = message['type'] ?? 'text';

    // Build a readable preview for the report screen
    final previewContent =
        messageType == 'image' ? '[Image Message]' : messageText.toString();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Preview of the message
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Text(
                  previewContent,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ),

              const Divider(),

              // Report option
              ListTile(
                leading: Icon(Icons.flag_outlined, color: Colors.orange[700]),
                title: Text(
                  'Report Message',
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Get.back(); // close bottom sheet
                  Get.to(() => ReportScreen(
                        reportType: 'message',
                        referenceId: messageId,
                        reportedUserId: widget.partnerId,
                        previewContent: previewContent,
                      ));
                },
              ),

              // Delete option
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Delete Message',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Get.back(); // close bottom sheet
                  _confirmDeleteMessage(messageId);
                },
              ),

              // Cancel
              ListTile(
                leading:
                    Icon(Icons.close, color: Colors.grey[600]),
                title: Text('Cancel',
                    style: TextStyle(color: Colors.grey[600])),
                onTap: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Confirmation dialog before deleting
  void _confirmDeleteMessage(String messageId) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Message',
            style: TextStyle(fontWeight: FontWeight.w600)),
        content: const Text(
            'This message will be deleted from your chat. The other person will still see it.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child:
                Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              try {
                await _reportService.deleteMessageForMe(
                  chatId: widget.chatId,
                  messageId: messageId,
                );
                // Reload messages to reflect deletion
                chatController.loadMessages(widget.chatId);
              } catch (e) {
                Get.snackbar('Error', 'Could not delete message.',
                    backgroundColor: Colors.red[100],
                    colorText: Colors.red[900],
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(16));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Delete',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Chat-level report (3-dot menu)
  // ─────────────────────────────────────────────────────────────

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Icon(Icons.flag_outlined, color: Colors.orange[700]),
                title: Text(
                  'Report Chat',
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                subtitle: Text(
                  'Report this conversation to our team',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                onTap: () {
                  Get.back();
                  Get.to(() => ReportScreen(
                        reportType: 'chat',
                        referenceId: widget.chatId,
                        reportedUserId: widget.partnerId,
                        previewContent:
                            'Chat with ${widget.partnerName}',
                      ));
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.close, color: Colors.grey[600]),
                title: Text('Cancel',
                    style: TextStyle(color: Colors.grey[600])),
                onTap: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Message bubble
  // ─────────────────────────────────────────────────────────────

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final currentUserId = chatController.chatService.getCurrentUserId();
    final isMe = message['senderId'] == currentUserId;
    final messageText = message['message'] ?? '';
    final messageType = message['type'] ?? 'text';
    final timestamp = message['timestamp'] as DateTime?;

    // Respect per-user soft-delete
    final deletedFor = message['deletedFor'];
    if (deletedFor != null &&
        (deletedFor as List).contains(currentUserId)) {
      return const SizedBox.shrink();
    }

    String formattedTime = '';
    if (timestamp != null) {
      formattedTime = DateFormat('HH:mm').format(timestamp);
    }

    // Warning message type
    if (messageType == 'warning') {
      return _buildWarningMessagePersistent(messageText, isMe);
    }

    final bubble = Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.black : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: messageType == 'image'
                      ? GestureDetector(
                          onTap: () {
                            Get.dialog(
                              Dialog(
                                child: InteractiveViewer(
                                  child: Image.network(
                                    messageText,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            constraints: const BoxConstraints(
                              maxHeight: 200,
                              maxWidth: 200,
                            ),
                            child: Image.network(
                              messageText,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: myPurple,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: Icon(Icons.broken_image,
                                        color: Colors.grey),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : Text(
                          messageText,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black87,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    // Only received messages get the long-press handler
    if (!isMe) {
      return GestureDetector(
        onLongPress: () => _showMessageOptions(message),
        child: bubble,
      );
    }
    return bubble;
  }

  Widget _buildDateDivider(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          date,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildWarningMessagePersistent(String message, bool isMe) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFD4C4A8),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
          Positioned(
            left: -30,
            top: 10,
            child: Image.asset(
              'assets/devil_left.png',
              width: 50,
              height: 50,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red[900],
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.warning, color: Colors.white, size: 25),
              ),
            ),
          ),
          Positioned(
            right: -30,
            top: 10,
            child: Image.asset(
              'assets/devil_right.png',
              width: 50,
              height: 50,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red[900],
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.warning, color: Colors.white, size: 25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningMessage() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFD4C4A8),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              "Those who take screenshots will be punished.\nWe're not playing!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
          Positioned(
            left: -30,
            top: 10,
            child: Image.asset(
              'assets/devil_left.png',
              width: 50,
              height: 50,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red[900],
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.warning, color: Colors.white, size: 25),
              ),
            ),
          ),
          Positioned(
            right: -30,
            top: 10,
            child: Image.asset(
              'assets/devil_right.png',
              width: 50,
              height: 50,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red[900],
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.warning, color: Colors.white, size: 25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: widget.partnerPhoto != null
                  ? NetworkImage(widget.partnerPhoto!)
                  : null,
              backgroundColor:
                  widget.partnerPhoto == null ? myPurple : null,
              child: widget.partnerPhoto == null
                  ? Text(
                      widget.partnerName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.partnerName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Obx(() {
                    final chat = chatController.chats.firstWhereOrNull(
                      (c) => c['chatId'] == widget.chatId,
                    );
                    final isOnline = chat?['isOnline'] ?? false;
                    return Text(
                      isOnline ? 'Online' : 'Offline',
                      style: TextStyle(
                        fontSize: 11,
                        color: isOnline ? Colors.green : Colors.grey[500],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_outlined,
                color: Colors.black, size: 22),
            onPressed: () {
              // Implement voice call
            },
          ),
          // ── Three-dot menu ────────────────────────────────
          IconButton(
            icon: const Icon(Icons.more_vert,
                color: Colors.black, size: 22),
            onPressed: _showChatOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (chatController.messages.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No messages yet',
                        style: TextStyle(
                            color: Colors.grey[600], fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Send a message to start chatting!',
                        style: TextStyle(
                            color: Colors.grey[400], fontSize: 14),
                      ),
                    ],
                  ),
                );
              }

              return Stack(
                children: [
                  ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    itemCount: chatController.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatController.messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
                  if (showWarning)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 20,
                      child: _buildWarningMessage(),
                    ),
                ],
              );
            }),
          ),

          // ── Input bar ──────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add, color: Colors.grey[600], size: 24),
                  onPressed: _sendImage,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            decoration: InputDecoration(
                              hintText: "Message...",
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        Obx(() {
                          if (chatController.isSending.value) {
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: myPurple,
                                ),
                              ),
                            );
                          }
                          return IconButton(
                            icon: Icon(
                              Icons.insert_emoticon_outlined,
                              color: Colors.grey[600],
                              size: 22,
                            ),
                            onPressed: () {
                              // Show emoji picker
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.mic_none,
                      color: Colors.grey[600], size: 24),
                  onPressed: () {
                    // Implement voice message
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}