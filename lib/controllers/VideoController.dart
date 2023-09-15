
import 'dart:developer';

import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  final String urlVideo;
  final RxBool isVideoInitialized = false.obs;

  late VideoPlayerController controller;

  VideoController(this.urlVideo);

//Retourne si la video est initialisez

  @override
  void onInit() async {
    super.onInit();
    try {
      log(" slide video debut initialisation");
      controller = VideoPlayerController.networkUrl(Uri.parse(urlVideo)); 

      await controller.initialize();
      if (controller.value.isInitialized) {
        isVideoInitialized.value = true;
        update();
        controller.play();
      }
      log("slide video fin initialisation");
    } catch (e) {
      rethrow;
    }
  }


}
