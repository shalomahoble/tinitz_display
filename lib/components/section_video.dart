import 'package:borne_flutter/config/size_config.dart';
import 'package:borne_flutter/controllers/VideoController.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:video_player/video_player.dart';

class SectionVideo extends StatelessWidget {
  final String urlvideo;
  const SectionVideo({
    Key? key,
    required this.urlvideo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VideoController videoController = VideoController(urlvideo);

    return Container(
      width: double.infinity,
      height: SizeConfig.screenheigth! * 0.3,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: Center(
        child: Obx(
          () => videoController.isVideoInitialized.isTrue
              ? AspectRatio(
                  aspectRatio: videoController.controller.value.aspectRatio,
                  child: VideoPlayer(
                    videoController.controller,
                  ),
                )
              : LoadingAnimationWidget.flickr(
                  leftDotColor: Colors.orange,
                  rightDotColor: Colors.lightBlue,
                  size: 50,
                ),
        ),
      ),
    );
  }
}