import 'package:borne_flutter/components/v_1_components/caroussel_widget.dart';
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

  @override
  void initState() {
    super.initState();
    Get.put(AlertVideoController());
    controller.getBorne(); // Initialisation de la borne
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
                  )),

              //Carousselle
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
