import 'package:borne_flutter/components/v_1_components/caroussel_widget.dart';
import 'package:borne_flutter/controllers/AlertVideoController.dart';
import 'package:borne_flutter/controllers/BorneController.dart';
import 'package:borne_flutter/views/home_page_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/v_1_components/flash_info_widget.dart';
import '../components/v_1_components/header.dart';

class HomePage extends GetView<BorneController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final alertVideoController = Get.put(AlertVideoController());

    controller.getBorne();

    return Obx(() {
      if (controller.borneLoading.isTrue) {
        return Scaffold(
          body: Column(
            children: [
              //L'entête de la page
              Obx(
                () => Header(
                  time: controller.currentDate.value,
                  imagePath: controller.site.value.direction.image,
                ),
              ),

              //Carousselle
              const CarousselWidget(),

              //Flash info Widget
              FlashInfoWidget(alertText: controller.getAlerteText()),
            ],
          ),
        );
      } else {
        return const HomePageLoading();
      }
    });

    // return GetBuilder<BorneController>(
    //   builder: (controller) {
    //   },
    // );
  }
}
