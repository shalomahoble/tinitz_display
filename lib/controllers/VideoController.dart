import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  final String urlVideo;
  final RxBool isVideoInitialized = false.obs;

  late VideoPlayerController controller;

  VideoController(this.urlVideo);

//Retourne si la video est initialisez
  bool isInitialized() {
    return controller.value.isInitialized;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    controller = VideoPlayerController.networkUrl(Uri.parse(urlVideo))
      ..initialize().then(
        (value) {
          isVideoInitialized.value = true;
          update();
        },
      );

    controller.play();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
