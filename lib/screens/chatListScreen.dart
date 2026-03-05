import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/controller/chatController.dart';
import 'package:dating_app/controller/gender_controller.dart';
import 'package:dating_app/models/gender.dart';
import 'package:dating_app/const/colors.dart';
import 'package:dating_app/screens/chatScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatListScreen extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());
  final GenderController genderController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(),

            // Community Announcements Section
            _buildCommunitySection(context),

            // Divider
            Container(
              height: 1,
              color: Colors.grey[200],
              margin: EdgeInsets.symmetric(horizontal: 16),
            ),

            // Chat List
            Expanded(
              child: Obx(() {
                if (chatController.chats.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No conversations yet',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Start chatting with your matches!',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  itemCount: chatController.chats.length,
                  itemBuilder: (context, index) {
                    final chat = chatController.chats[index];
                    return FutureBuilder<Map<String, dynamic>>(
                      future: chatController.getOtherParticipant(chat),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return _buildChatSkeleton();
                        }

                        final partner = snapshot.data ?? {};
                        final lastMessageTime =
                            (chat['lastMessageTime'] as Timestamp?)?.toDate();
                        final unreadCount = chatController.getUnreadCount(chat);

                        return _buildChatItem(
                          chatId: chat['chatId'],
                          partner: partner,
                          lastMessage: chat['lastMessage'] ?? '',
                          lastMessageTime: lastMessageTime,
                          unreadCount: unreadCount,
                          context: context,
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'CHATS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
              letterSpacing: 1.5,
            ),
          ),
          Row(
            children: [
              Text(
                'OFF',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.notifications_off_outlined,
                size: 20,
                color: Colors.grey[400],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Fetches the current user's createdAt timestamp from Firestore,
  /// then taps into the community section widget.
  Widget _buildCommunitySection(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return SizedBox.shrink();

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState != ConnectionState.done) {
          return _buildCommunitySkeleton();
        }

        final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
        final userCreatedAt =
            (userData?['createdAt'] as Timestamp?)?.toDate() ?? DateTime(2000);

        return _buildAnnouncementRow(context, userCreatedAt);
      },
    );
  }

  Widget _buildAnnouncementRow(BuildContext context, DateTime userCreatedAt) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('announcements')
          .where('createdAt',
              isGreaterThan: Timestamp.fromDate(userCreatedAt))
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        final announcements = snapshot.data?.docs ?? [];
        final unreadCount = announcements.length;

        return GestureDetector(
          onTap: () {
            if (announcements.isNotEmpty) {
              _showAnnouncementsSheet(context, announcements);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Community icon avatar
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        genderController.selectedGender.value == Gender.male
                            ? myPurple
                            : genderController.selectedGender.value ==
                                    Gender.female
                                ? myBrown
                                : myYellow,
                        genderController.selectedGender.value == Gender.male
                            ? myPurple.withOpacity(0.6)
                            : genderController.selectedGender.value ==
                                    Gender.female
                                ? myBrown.withOpacity(0.6)
                                : myYellow.withOpacity(0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(
                    Icons.campaign_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),

                SizedBox(width: 12),

                // Community info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Community',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        announcements.isNotEmpty
                            ? (announcements.first.data()
                                    as Map<String, dynamic>)['title'] ??
                                'New announcement'
                            : 'No announcements yet',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Unread badge
                if (unreadCount > 0)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          genderController.selectedGender.value == Gender.male
                              ? myPurple
                              : genderController.selectedGender.value ==
                                      Gender.female
                                  ? myBrown
                                  : myYellow,
                    ),
                  ),

                SizedBox(width: 4),
                Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAnnouncementsSheet(
      BuildContext context, List<QueryDocumentSnapshot> announcements) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Title
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.campaign_outlined,
                            size: 22, color: Colors.black87),
                        SizedBox(width: 8),
                        Text(
                          'Announcements',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '${announcements.length} total',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(height: 1, color: Colors.grey[200]),

                  // Announcements list
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      padding: EdgeInsets.all(16),
                      itemCount: announcements.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final data = announcements[index].data()
                            as Map<String, dynamic>;
                        return _buildAnnouncementCard(data);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAnnouncementCard(Map<String, dynamic> data) {
    final title = data['title'] ?? '';
    final message = data['message'] ?? '';
    final imageUrl = data['imageUrl'] ?? '';
    final createdAt = (data['createdAt'] as Timestamp?)?.toDate();

    String formattedDate = '';
    if (createdAt != null) {
      formattedDate = DateFormat('MMM d, yyyy · HH:mm').format(createdAt);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image (if present)
          if (imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => SizedBox.shrink(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 180,
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.grey[400]!,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // Content
          Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                if (title.isNotEmpty)
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),

                if (title.isNotEmpty && message.isNotEmpty)
                  SizedBox(height: 6),

                // Message
                if (message.isNotEmpty)
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.45,
                    ),
                  ),

                SizedBox(height: 10),

                // Date and sent by
                Row(
                  children: [
                    Icon(Icons.access_time,
                        size: 13, color: Colors.grey[400]),
                    SizedBox(width: 4),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunitySkeleton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 14,
                  color: Colors.grey[200],
                  margin: EdgeInsets.only(bottom: 6),
                ),
                Container(width: 160, height: 12, color: Colors.grey[200]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatSkeleton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 14,
                  color: Colors.grey[200],
                  margin: EdgeInsets.only(bottom: 6),
                ),
                Container(width: 200, height: 12, color: Colors.grey[200]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem({
    required String chatId,
    required Map<String, dynamic> partner,
    required String lastMessage,
    required DateTime? lastMessageTime,
    required int unreadCount,
    required BuildContext context,
  }) {
    final String? partnerName =
        partner['name'] ?? partner['username'] ?? 'Unknown';
    final String? partnerPhoto = partner['photoUrl'];

    String formattedTime = '';
    if (lastMessageTime != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(Duration(days: 1));

      if (lastMessageTime.isAfter(today)) {
        formattedTime = DateFormat('HH:mm').format(lastMessageTime);
      } else if (lastMessageTime.isAfter(yesterday)) {
        formattedTime = 'Yesterday';
      } else {
        formattedTime = DateFormat('MMM d').format(lastMessageTime);
      }
    }

    return GestureDetector(
      onTap: () {
        Get.to(
          () => ChatScreen(
            chatId: chatId,
            partnerId: partner['id'],
            partnerName: partnerName!,
            partnerPhoto: partnerPhoto,
          ),
        );
      },
      onLongPress: () {
        _showChatOptions(context, chatId);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.white,
        child: Row(
          children: [
            // Profile Image with online indicator
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: partnerPhoto != null
                        ? DecorationImage(
                            image: NetworkImage(partnerPhoto),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: partnerPhoto == null
                        ? (genderController.selectedGender.value == Gender.male
                            ? myPurple
                            : genderController.selectedGender.value ==
                                    Gender.female
                                ? myBrown
                                : myYellow)
                        : null,
                  ),
                  child: partnerPhoto == null
                      ? Center(
                          child: Text(
                            partnerName![0].toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : null,
                ),
                // Online indicator (small dot on bottom left)
                if (partner['isOnline'] == true)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green[600],
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(width: 12),

            // Chat info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    partnerName!,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (partner['location'] != null)
                        Row(
                          children: [
                            SizedBox(width: 4),
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Time and unread indicator
            if (formattedTime.isNotEmpty || unreadCount > 0) SizedBox(width: 8),

            if (unreadCount > 0)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      genderController.selectedGender.value == Gender.male
                          ? myPurple
                          : genderController.selectedGender.value ==
                                  Gender.female
                              ? myBrown
                              : myYellow,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showChatOptions(BuildContext context, String chatId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                ListTile(
                  leading: Icon(Icons.delete_outline, color: Colors.red),
                  title: Text(
                    'Delete Chat',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteConfirmation(chatId);
                  },
                ),

                Divider(height: 1),

                ListTile(
                  leading: Icon(Icons.block_outlined, color: Colors.black87),
                  title: Text(
                    'Block User',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Implement block functionality
                  },
                ),

                Divider(height: 1),

                ListTile(
                  leading: Icon(Icons.report_outlined, color: Colors.black87),
                  title: Text(
                    'Report',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Implement report functionality
                  },
                ),

                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(String chatId) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'Delete Chat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete this conversation? This action cannot be undone.',
          style: TextStyle(color: Colors.grey[700]),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              chatController.deleteChat(chatId);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}