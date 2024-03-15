import 'package:borne_flutter/config/app_style.dart';
import 'package:borne_flutter/controllers/AlertVideoController.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

class VideoWidgetSection extends StatelessWidget {
  const VideoWidgetSection({
    super.key,
    required this.videoController,
  });

  final AlertVideoController videoController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 8,
      child: Container(
        color: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              videoController.videoTitle.value,
              style: titleWelcome.copyWith(fontSize: 15, color: Colors.white),
            ),
            Card(
              shadowColor: Colors.white,
              child: AspectRatio(
                aspectRatio:
                    videoController.videoPlayerController.value.aspectRatio,
                child: Chewie(controller: videoController.chewieController),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
