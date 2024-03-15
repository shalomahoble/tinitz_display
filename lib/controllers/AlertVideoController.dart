// ignore_for_file: file_names

import 'dart:async';
import 'dart:developer';

import 'package:borne_flutter/controllers/BorneController.dart';
import 'package:borne_flutter/models/Alerte.dart';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class AlertVideoController extends GetxController {
  /* final LoginController loginController = Get.find<LoginController>(); */
  BorneController? _borneController; // Utilisez le type BorneController?

  // Méthode pour obtenir le BorneController seulement lorsque vous en avez besoin
  BorneController get borneController {
    _borneController ??= Get.find<BorneController>();
    return _borneController!;
  }

  RxString videoUrl = ''.obs;
  RxString videoTitle = ''.obs;
  RxBool isVideoPlaying = false.obs;
  RxBool videoIsInitialized = false.obs;
  RxInt currentVideoIndex = 0.obs;
  RxInt alertVideochanger = 0.obs;
  RxString currentVideoUrl = ''.obs;
  RxInt dureeAvantAffichage = 10.obs;

  Duration showModalDuration = const Duration(seconds: 45);
  late ChewieController chewieController;
  late VideoPlayerController videoPlayerController;
  List<Alert> alertepermanent = [];
  Timer videoTimer = Timer(Duration.zero, () {});
  Set<int> permanentVideoIdsDisplayed = {};

/*http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4
 https://media.w3.org/2010/05/sintel/trailer.mp4
 https://media.w3.org/2010/05/sintel/trailer.mp4 */

  void loadVideo() {
    final videoAlerts = borneController.getAlerteVideo();
    if (videoAlerts.isNotEmpty) {
      currentVideoUrl.value = videoAlerts[currentVideoIndex.value].fileUrl;
      videoTitle.value = videoAlerts[currentVideoIndex.value].libelle;
      dureeAvantAffichage.value =
          videoAlerts[currentVideoIndex.value].randomVideo;
      log("BDVIDEO l'index de la video ${currentVideoIndex.value}");
      update();
      if (isVideoPlaying.isFalse) {
        _playVideo(currentVideoUrl.value);
      }
    }
  }

  void _playVideo(String videoUrl) async {
    try {
      Future.delayed(Duration(seconds: dureeAvantAffichage.value), () async {
        log("BDVIDEO lance titre $videoUrl");
        videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse(videoUrl));
        await videoPlayerController.initialize();

        if (videoPlayerController.value.isInitialized &&
            videoPlayerController.value.duration.inMilliseconds > 0) {
          chewieController = ChewieController(
            videoPlayerController: videoPlayerController,
            autoPlay: true,
            looping: false,
            allowFullScreen: true,
            allowMuting: false,
            showControlsOnInitialize: false,
            showControls: false,
          );
          isVideoPlaying(true);
          videoIsInitialized(true);
          // Temps d'affichage de la video
          // Get.defaultDialog(
          //   title: videoTitle.value,
          //   titlePadding:
          //       const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          //   contentPadding: EdgeInsets.zero,
          //   content: AspectRatio(
          //     aspectRatio: videoPlayerController.value.aspectRatio,
          //     child: Chewie(
          //       controller: chewieController,
          //     ),
          //   ),
          // );

          videoPlayerController.addListener(() {
            if (!videoPlayerController.value.isPlaying &&
                videoPlayerController.value.duration ==
                    videoPlayerController.value.position) {
              chewieController.pause(); // Arrêter la lecture
              videoPlayerController.pause();
              isVideoPlaying(false);
              _onVideoFinished();
            }
          });

          // Timer(videoPlayerController.value.duration, () {
          //   chewieController.pause(); // Arrêter la lecture
          //   videoPlayerController.pause();
          //   Get.back();
          //   isVideoPlaying(false);
          //   _onVideoFinished();
          // });
        }
      });
    } catch (e) {
      log('Erreur lors de la lecture de la vidéo : $e');
      skipToNextArticle(); // Passez a la video suivante
      loadVideo();
    }
  }

  //Cette fonction vérifie si l'article permanent a déjà été affiché.
  bool shouldSkipPermanentArticle(Alert alert) {
    return permanentVideoIdsDisplayed.contains(alert.id!);
  }

  //Cette fonction passe à la video suivante si la video actuel doit être sauté.
  void skipToNextArticle() {
    currentVideoIndex.value =
        (currentVideoIndex.value + 1) % borneController.getAlerteVideo().length;
    update();
  }

  // Si la vidéo actuelle est non permanente, supprimer des alertes videos
  void isPermanenteVideo(Alert alert) {
    if (alert.permanent == 0) {
      permanentVideoIdsDisplayed.add(alert.id!);
      borneController.getAlerteVideo().removeWhere((el) => el.id == alert.id);
      update();
    }
  }

  void _onVideoFinished() {
    final videoAlert = borneController.getAlerteVideo();
    if (videoAlert.isNotEmpty) {
      currentVideoIndex.value =
          (currentVideoIndex.value + 1) % videoAlert.length;
      update();
      log("BDVIDEO nouvelle ${currentVideoIndex.value}");
      loadVideo();
    }
  }

//Ecouter les changements les mises a jours de la video
  void listenChangeArticle() {
    ever(borneController.alertes, (callback) {
      videoTimer.cancel();
      currentVideoIndex.value = 0;
      loadVideo();
    });
  }

  @override
  void onInit() {
    super.onInit();

    ever(borneController.alertes, (callback) {
      if (!videoTimer.isActive) {
        videoTimer.cancel();
      }
      currentVideoIndex.value = 0;
      update();
      if (!isVideoPlaying.value) {
        loadVideo();
      }
      log("j'ecouter les changement de la borne pour video");
    });
  }

  void stopVideo() {
    if (videoIsInitialized.isTrue &&
        videoPlayerController.value.isInitialized) {
      videoPlayerController.pause();
      chewieController.pause();
    }
  }

  @override
  void onClose() {
    super.onClose();
    if (videoPlayerController.value.isInitialized) {
      videoPlayerController.dispose();
      chewieController.dispose();
    }

    videoTimer.cancel();
  }
}
