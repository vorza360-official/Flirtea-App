import 'package:flutter/material.dart';
import 'package:dating_app/services/zego_service.dart';

class ZegoVideoView extends StatefulWidget {
  final Future<Widget?> Function() createVideoView;
  final String? streamId;
  final ZegoService zegoService;
  final Widget? placeholder;

  const ZegoVideoView({
    super.key,
    required this.createVideoView,
    this.streamId,
    required this.zegoService,
    this.placeholder,
  });

  @override
  State<ZegoVideoView> createState() => _ZegoVideoViewState();
}

class _ZegoVideoViewState extends State<ZegoVideoView> {
  Widget? _videoView;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadVideoView();
  }

  Future<void> _loadVideoView() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      final view = await widget.createVideoView();

      if (mounted) {
        setState(() {
          _videoView = view;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading video view: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    // Clean up the video view cache when this widget is disposed
    if (widget.streamId != null) {
      widget.zegoService.clearRemoteVideoCache(widget.streamId!);
    } else {
      widget.zegoService.clearLocalVideoCache();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.placeholder ??
          const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return widget.placeholder ??
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: Icon(Icons.videocam_off, color: Colors.white, size: 50),
            ),
          );
    }

    if (_videoView != null) {
      return _videoView!;
    }

    return Container();
  }
}
