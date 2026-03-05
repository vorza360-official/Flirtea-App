// screens/report_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../services/report_service.dart';

/// [reportType]    → "message" or "chat"
/// [referenceId]   → messageId or chatId
/// [reportedUserId]→ the other user's UID
/// [previewContent]→ text/image-url shown as "what's being reported"
class ReportScreen extends StatefulWidget {
  final String reportType;
  final String referenceId;
  final String reportedUserId;
  final String previewContent;

  const ReportScreen({
    Key? key,
    required this.reportType,
    required this.referenceId,
    required this.reportedUserId,
    required this.previewContent,
  }) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final ReportService _reportService = ReportService();
  final ImagePicker _picker = ImagePicker();

  String? _selectedReason;
  String _selectedPriority = 'medium';
  List<XFile> _evidenceImages = [];
  bool _isSubmitting = false;

  final Color myPurple = const Color(0xFF8B5CF6);

  static const List<Map<String, String>> _reasons = [
    {'value': 'sexual_content',   'label': 'Sexual Content'},
    {'value': 'harassment',       'label': 'Harassment / Bullying'},
    {'value': 'hate_speech',      'label': 'Hate Speech'},
    {'value': 'spam',             'label': 'Spam'},
    {'value': 'violence',         'label': 'Violence or Threats'},
    {'value': 'fake_profile',     'label': 'Fake Profile'},
    {'value': 'scam',             'label': 'Scam / Fraud'},
    {'value': 'other',            'label': 'Other'},
  ];

  static const List<Map<String, String>> _priorities = [
    {'value': 'low',    'label': 'Low'},
    {'value': 'medium', 'label': 'Medium'},
    {'value': 'high',   'label': 'High'},
  ];

  Future<void> _pickImages() async {
    final images = await _picker.pickMultiImage(imageQuality: 80);
    if (images.isNotEmpty) {
      setState(() {
        _evidenceImages.addAll(images);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _evidenceImages.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedReason == null) {
      _showSnack('Please select a reason for the report.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Upload evidence images first
      List<String> evidenceUrls = [];
      if (_evidenceImages.isNotEmpty) {
        evidenceUrls =
            await _reportService.uploadEvidenceImages(_evidenceImages);
      }

      await _reportService.submitReport(
        reportType: widget.reportType,
        referenceId: widget.referenceId,
        reportedUserId: widget.reportedUserId,
        reason: _selectedReason!,
        description: _descriptionController.text.trim(),
        priority: _selectedPriority,
        evidenceUrls: evidenceUrls,
      );

      Get.back();
      _showSnack('Report submitted successfully. We will review it shortly.',
          isError: false);
    } catch (e) {
      _showSnack('Failed to submit report. Please try again.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSnack(String msg, {bool isError = true}) {
    Get.snackbar(
      isError ? 'Error' : 'Reported',
      msg,
      backgroundColor: isError ? Colors.red[100] : Colors.green[100],
      colorText: isError ? Colors.red[900] : Colors.green[900],
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isMessage = widget.reportType == 'message';

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
        title: Text(
          isMessage ? 'Report Message' : 'Report Chat',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Report type badge ──────────────────────────
              _SectionLabel(
                  label: isMessage ? 'Reporting a Message' : 'Reporting a Chat'),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      isMessage ? Icons.message_outlined : Icons.chat_outlined,
                      color: myPurple,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.previewContent,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Reason ────────────────────────────────────
              const _SectionLabel(label: 'Reason *'),
              const SizedBox(height: 10),
              ..._reasons.map((r) => _ReasonTile(
                    label: r['label']!,
                    value: r['value']!,
                    groupValue: _selectedReason,
                    accentColor: myPurple,
                    onChanged: (val) =>
                        setState(() => _selectedReason = val),
                  )),

              const SizedBox(height: 24),

              // ── Priority ──────────────────────────────────
              const _SectionLabel(label: 'Priority'),
              const SizedBox(height: 10),
              Row(
                children: _priorities
                    .map((p) => Expanded(
                          child: _PriorityChip(
                            label: p['label']!,
                            value: p['value']!,
                            selected: _selectedPriority == p['value'],
                            accentColor: _priorityColor(p['value']!),
                            onTap: () =>
                                setState(() => _selectedPriority = p['value']!),
                          ),
                        ))
                    .toList(),
              ),

              const SizedBox(height: 24),

              // ── Description ───────────────────────────────
              const _SectionLabel(label: 'Description *'),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText:
                      'Describe the issue in detail so we can investigate...',
                  hintStyle:
                      TextStyle(color: Colors.grey[400], fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: myPurple),
                  ),
                  contentPadding: const EdgeInsets.all(14),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Please provide a description.';
                  }
                  if (v.trim().length < 10) {
                    return 'Description must be at least 10 characters.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // ── Evidence images ───────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _SectionLabel(label: 'Evidence (optional)'),
                  if (_evidenceImages.isNotEmpty)
                    Text(
                      '${_evidenceImages.length} selected',
                      style: TextStyle(color: myPurple, fontSize: 13),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: myPurple.withOpacity(0.5), width: 1.5),
                    color: myPurple.withOpacity(0.04),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_outlined, color: myPurple, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Upload Screenshots / Images',
                        style:
                            TextStyle(color: myPurple, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

              if (_evidenceImages.isNotEmpty) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _evidenceImages.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              _evidenceImages[index].path,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 90,
                                height: 90,
                                color: Colors.grey[200],
                                child: const Icon(Icons.image,
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black87,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close,
                                    color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],

              const SizedBox(height: 36),

              // ── Submit button ─────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myPurple,
                    disabledBackgroundColor: myPurple.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Submit Report',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }
}

// ─────────────────────────────────────────────
// Helper widgets
// ─────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }
}

class _ReasonTile extends StatelessWidget {
  final String label;
  final String value;
  final String? groupValue;
  final Color accentColor;
  final ValueChanged<String?> onChanged;

  const _ReasonTile({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.accentColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = groupValue == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? accentColor : Colors.grey[300]!,
            width: selected ? 1.5 : 1,
          ),
          color: selected ? accentColor.withOpacity(0.06) : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? accentColor : Colors.grey[400],
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.black87 : Colors.grey[700],
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final Color accentColor;
  final VoidCallback onTap;

  const _PriorityChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? accentColor : Colors.grey[300]!,
            width: selected ? 1.5 : 1,
          ),
          color: selected ? accentColor.withOpacity(0.1) : Colors.white,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? accentColor : Colors.grey[600],
              fontWeight:
                  selected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}