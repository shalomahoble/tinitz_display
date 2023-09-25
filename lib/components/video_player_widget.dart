import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final VoidCallback onFinished;

  const VideoPlayerWidget(
      {super.key, required this.videoUrl, required this.onFinished});

  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.position ==
          _videoPlayerController.value.duration) {
        _videoPlayerController.pause();
        widget.onFinished();
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(_videoPlayerController);
  }
}
