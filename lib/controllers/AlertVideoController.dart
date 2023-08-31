import 'dart:async';

import 'package:borne_flutter/controllers/BorneController.dart';
import 'package:borne_flutter/models/Alerte.dart';
import 'package:borne_flutter/utils/utils.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:video_player/video_player.dart';

class AlertVideoController extends GetxController {
  /* final LoginController loginController = Get.find<LoginController>(); */
  BorneController? _borneController; // Utilisez le type BorneController?

  // Méthode pour obtenir le BorneController seulement lorsque vous en avez besoin
  BorneController get borneController {
    _borneController ??= Get.find<BorneController>();
    return _borneController!;
  }

  final videoUrl = ''.obs;
  RxString videoTitle = ''.obs;
  final shouldShowModal = false.obs;
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

  void loadVideo() {
    final videoAlerts = borneController.getAlerteVideo();

    if (videoAlerts.isNotEmpty &&
        currentVideoIndex.value < videoAlerts.length) {
      currentVideoUrl.value = videoAlerts[currentVideoIndex.value].fileUrl;
      videoTitle.value = videoAlerts[currentVideoIndex.value].libelle;
      dureeAvantAffichage.value =
          videoAlerts[currentVideoIndex.value].randomVideo;
      print("BDVIDEO l'index de la video ${currentVideoIndex.value}");
      update();

      final subscription =
          InternetConnectivity() //verifiier si on a la connexion
              .observeInternetConnection
              .listen((bool hasInternetAccess) {
        if (!hasInternetAccess) {
          Future.delayed(const Duration(seconds: 20), () {
            showMessageError(message: "Pas de connexion internet");
          });
        } else {
          _playVideo(currentVideoUrl.value);
        }
      });
      Future.delayed(const Duration(seconds: 15), () async {
        await subscription.cancel();
      });

      /*   subscription.cancel(); */

      //Si la video est deja passe on recommence un autre video
      /*  if (shouldSkipPermanentArticle(videoAlerts[currentVideoIndex.value])) {
        loadVideo();
      } else {
        _playVideo(currentVideoUrl.value);
      } */
    }
  }

  void _playVideo(String videoUrl) async {
    try {
      Future.delayed(Duration(seconds: dureeAvantAffichage.value), () async {
        videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse(videoUrl));
        await videoPlayerController.initialize();

        if (videoPlayerController.value.isInitialized) {
          chewieController = ChewieController(
            videoPlayerController: videoPlayerController,
            autoPlay: true,
            looping: false,
            allowFullScreen: true,
            allowMuting: false,
            showControlsOnInitialize: false,
            showControls: false,
          );

          print("BDVIDEO lance ");

          //Temps d'affichage de la video
          Get.defaultDialog(
            title: videoTitle.value,
            titlePadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            contentPadding: EdgeInsets.zero,
            content: AspectRatio(
              aspectRatio: videoPlayerController.value.aspectRatio,
              child: Chewie(
                controller: chewieController,
              ),
            ),
          );

          videoPlayerController.addListener(() {
            if (videoPlayerController.value.position >=
                videoPlayerController.value.duration) {
              Get.back();
              print("BDVIDEO fermer ${videoPlayerController.value.duration}");
              /*  isPermanenteVideo(
                  borneController.getAlerteVideo()[currentVideoIndex.value]); */
              _onVideoFinished();
            }
          });

          /*Timer(videoPlayerController.value.duration, () {
          chewieController.pause(); // Arrêter la lecture
          Get.back();
          _onVideoFinished();
        }); */
        }
      });
    } catch (e) {
      print('Erreur lors de la lecture de la vidéo : $e');
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

  void cancelVideo() {
    if (videoPlayerController.value.isInitialized == true) {
      videoPlayerController.dispose();
    }
  }

  @override
  void onInit() {
    //TODO: implement onInit
    super.onInit();
    /*  Future.delayed(const Duration(seconds: 25), () {
      currentVideoIndex.value = 0;
      loadVideo();
      print("je demarrer la video");
    }); */

    ever(borneController.alertes, (callback) {
      videoTimer.cancel();
      currentVideoIndex.value = 0;
      update();
      loadVideo();
      print("j'ecouter les changement de la borne pour video");
    });

    /*  listenChangeArticle(); */
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    chewieController.dispose();
    videoPlayerController.dispose();

    videoTimer.cancel();
  }
}
