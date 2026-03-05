// services/report_service.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get currentUserId => _auth.currentUser!.uid;

  // ─────────────────────────────────────────────
  // Submit a report (message OR chat)
  // ─────────────────────────────────────────────
  Future<void> submitReport({
    required String reportType,       // "message" | "chat"
    required String referenceId,      // messageId or chatId
    required String reportedUserId,
    required String reason,
    required String description,
    required String priority,
    required List<String> evidenceUrls,
  }) async {
    final now = FieldValue.serverTimestamp();

    await _firestore.collection('reports').add({
      'reportType': reportType,
      'referenceId': referenceId,
      'reportedUserId': reportedUserId,
      'reporterId': currentUserId,
      'reason': reason,
      'description': description,
      'priority': priority,
      'evidenceUrls': evidenceUrls,
      'status': 'pending',
      'adminAction': 'none',
      'createdAt': now,
      'updatedAt': now,
    });
  }

  // ─────────────────────────────────────────────
  // Delete a message (for the current user only)
  // Updates Firestore so the message is hidden
  // ─────────────────────────────────────────────
  Future<void> deleteMessageForMe({
    required String chatId,
    required String messageId,
  }) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({
      'deletedFor': FieldValue.arrayUnion([currentUserId]),
    });
  }

  // ─────────────────────────────────────────────
  // Upload evidence images and return their URLs
  // ─────────────────────────────────────────────
  Future<List<String>> uploadEvidenceImages(List<XFile> files) async {
    final List<String> urls = [];
    for (final file in files) {
      final ref = _storage
          .ref()
          .child('reports')
          .child(currentUserId)
          .child('${DateTime.now().millisecondsSinceEpoch}_${file.name}');
      await ref.putFile(File(file.path));
      final url = await ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }
}