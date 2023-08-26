import 'dart:async';

import 'package:borne_flutter/controllers/LoginController.dart';
import 'package:borne_flutter/models/Alerte.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class AlertVideoController extends GetxController {
  final LoginController loginController = Get.find<LoginController>();

  final videoUrl = ''.obs;
  RxString videoTitle = ''.obs;
  final shouldShowModal = false.obs;
  RxInt currentVideoIndex = 0.obs;
  RxInt alertVideochanger = 0.obs;
  Duration showModalDuration = const Duration(seconds: 45);
  late ChewieController chewieController;
  late VideoPlayerController videoPlayerController;
  List<Alert> alertepermanent = [];
  Timer videoTimer = Timer(Duration.zero, () {});

  final List<String> videoUrls = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://www.shutterstock.com/shutterstock/videos/1105801847/preview/stock-footage-swiping-the-screen-that-says-lorem-ipsum-macro-view.webm',
    'https://www.shutterstock.com/shutterstock/videos/34123237/preview/stock-footage-coworkers-discussing-in-the-future-of-their-company-over-several-charts-and-graphs-business.webm',
    'https://www.shutterstock.com/shutterstock/videos/1083251290/preview/stock-footage-man-and-woman-signing-business-contract-with-lorem-ipsum-text-shaking-hands.webm'
    // Ajoutez d'autres URLs de vidéos ici
  ];

  void loadVideo() {
    final videoAlerts = loginController.getVideoAlerts();

    print("video des alerts ici $videoAlerts");

    if (videoAlerts.isNotEmpty &&
        currentVideoIndex.value < videoAlerts.length) {
      final String currentVideoUrl =
          videoAlerts[currentVideoIndex.value].fileUrl;
      videoTitle.value = videoAlerts[currentVideoIndex.value].libelle;

      update();

      _playVideo(currentVideoUrl);
    }
  }

  void _playVideo(String videoUrl) async {
    // Remplacez cette logique par celle pour charger et lire la vidéo à partir de l'URL donnée.
    // Vous pouvez utiliser des packages comme `chewie` et `video_player` pour la lecture de vidéos.

    try {
      videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await videoPlayerController.initialize();
    } catch (e) {
      print("current je suis venu voir l'erreur");
      print(
          '${videoPlayerController.dataSource} Une erreur cest produite ERROR');
      currentVideoIndex.value = 0;
      videoTimer.cancel();
      /*  loadVideo(); */
      rethrow;
    }

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
      allowMuting: false,
      showControlsOnInitialize: false,
      showControls: false,
    );

    Get.defaultDialog(
      title: videoTitle.value,
      titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        child: AspectRatio(
          aspectRatio: chewieController.videoPlayerController.value.aspectRatio,
          child: Chewie(
            controller: chewieController,
          ),
        ),
      ),
    );

    Timer(videoPlayerController.value.duration, () {
      Get.back();
      _onVideoFinished();
    });
  }

  void _onVideoFinished() {
    final videoAlert = loginController.getVideoAlerts();

    if (currentVideoIndex.value < videoAlert.length) {
      final currentVideoAlert = videoAlert[currentVideoIndex.value];
      if (currentVideoAlert.permanent == 0) {
        print("current permanant");
        //Si la video est permanent
        alertepermanent.add(currentVideoAlert);
        loginController.borne.value.alerts!.removeAt(currentVideoIndex.value);
        update();
        /* videoAlert.removeAt(currentVideoIndex.value); */
      }

      //---- si nous avons de nouvelle alertes -----------

      currentVideoIndex.value = (currentVideoIndex.value + 1) %
          loginController.getVideoAlerts().length;
      update();
      final nextAlert =
          loginController.getVideoAlerts()[currentVideoIndex.value];
      print("current nouvelle valeur ${currentVideoIndex.value} ");

      // est ce que cette alerte video est permanent si oui on lui fait passé
      if (alertepermanent.contains(
          loginController.getVideoAlerts()[currentVideoIndex.value])) {
        loginController.borne.value.alerts!.removeAt(currentVideoIndex.value);
        currentVideoIndex.value = (currentVideoIndex.value + 1) %
            loginController.getVideoAlerts().length;
      }
      if (currentVideoIndex.value >= 0 &&
          currentVideoIndex.value < loginController.getVideoAlerts().length) {
        videoTimer = Timer(nextAlert.alertDuration(), () {
          loadVideo();
        });
      }
    }
  }

//Ecouter les changements les mises a jours de la video
  void listenChangeArticle() {
    ever(loginController.changeAlerte, (callback) {
      print("Une alerte a changeee");
      videoTimer.cancel();
      loadVideo();
    });
  }

  @override
  void onInit() {
    //TODO: implement onInit
    super.onInit();
    Future.delayed(const Duration(seconds: 15), () {
      loadVideo();
      print("jai demarrer la video");
    });

    ever(loginController.borne, (callback) {
      videoTimer.cancel();
      loadVideo();
      print("jai ecouter les changement de la borne pour video");
    });

    listenChangeArticle();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    chewieController.dispose();
    videoPlayerController.dispose();
  }
}
