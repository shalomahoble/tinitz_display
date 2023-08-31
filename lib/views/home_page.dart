import 'package:borne_flutter/components/v_1_components/caroussel_widget.dart';
import 'package:borne_flutter/controllers/AlertVideoController.dart';
import 'package:borne_flutter/controllers/BorneController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../components/v_1_components/header.dart';
import '../config/app_style.dart';

class HomePage extends GetView<BorneController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final alertVideoController = Get.put(AlertVideoController());

    return Obx(() {
      if (controller.borneLoading.value == true) {
        return Scaffold(
          body: Column(
            children: [
              //L'entête de la page
              Header(
                time: controller.currentDate.value,
                imagePath: controller.site.value.direction.image,
              ),

              //Carousselle
              CarousselWidget(
                articles: controller.articles,
              ),

              //Flash info Widget
              /*   FlashInfoWidget(alertText: controller.getAlerteText()), */
            ],
          ),
        );
      } else {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingAnimationWidget.newtonCradle(
                  color: KOrange,
                  size: 200,
                ),
                Text(
                  "En cours de chargement ...",
                  style: loadingText,
                  textAlign: TextAlign.justify,
                )
              ],
            ),
          ),
        );
      }
    });
  }
}
