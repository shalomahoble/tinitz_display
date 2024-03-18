// ignore_for_file: dead_code

import 'package:borne_flutter/components/v_1_components/caroussel_widget.dart';
import 'package:borne_flutter/components/v_1_components/video_widget_section.dart';
import 'package:borne_flutter/controllers/AlertVideoController.dart';
import 'package:borne_flutter/controllers/BorneController.dart';
import 'package:borne_flutter/views/home_page_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/v_1_components/flash_info_widget.dart';
import '../components/v_1_components/header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BorneController controller = Get.put(BorneController());
  final AlertVideoController videoController = Get.put(AlertVideoController());

  @override
  void initState() {
    super.initState();
    controller.getBorne(); // Initialisation de la borne
  }

  @override
  void dispose() {
    super.dispose();
    //videoController.stopVideo();
  }

  void deconnexion() {
    controller.deconnexion();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.borneLoading.value == true) {
        return Scaffold(
          body: Column(
            children: [
              //L'entête de la page
              Obx(() => Header(
                    time: controller.currentDate.value,
                    imagePath: controller.setting.value.logoborne,
                    onPress: () {
                      deconnexion();
                    },
                  )),

              //Affichage de la video
              if (videoController.isVideoPlaying.isTrue) ...[
                VideoWidgetSection(videoController: videoController)
              ]
              //Carousselle
              else
                const CarousselWidget(),
              //Flash info Widget
              FlashInfoWidget(alertText: controller.getAlerteText()),
            ],
          ),
        );
        //Shimmer Loading App
      } else {
        return const HomePageLoading();
      }
    });
  }
}
