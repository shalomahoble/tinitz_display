import 'package:borne_flutter/components/components.dart';
import 'package:borne_flutter/config/app_style.dart';
import 'package:borne_flutter/config/size_config.dart';
import 'package:borne_flutter/controllers/AlertVideoController.dart';
import 'package:borne_flutter/controllers/LoginController.dart';
import 'package:borne_flutter/controllers/TimerController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    AlertVideoController alertVideoController = Get.put(AlertVideoController());

    TimerController timerController = Get.put(TimerController());
    Get.find<LoginController>().load();

    /* print(Get.find<LoginController>().getVideoAlerts()); */

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: SizeConfig.blockHorizontal! * 15,
        elevation: 10,
        backgroundColor: Colors.white,
        bottomOpacity: 0,
        title: Container(
          margin: EdgeInsets.symmetric(
            vertical: SizeConfig.blockHorizontal! * 15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => CachedNetworkImage(
                    /*  fit: BoxFit.cover, */
                    width: Get.width / 5,
                    height: Get.width / 3,
                    imageUrl: Get.find<LoginController>().borne.value.site !=
                            null
                        ? Get.find<LoginController>()
                            .borne
                            .value
                            .site!
                            .direction
                            .image
                        : 'https://www.tinitz.com/img/tinitz-logo-150x74.png',
                    placeholder: (context, url) {
                      return LoadingAnimationWidget.fourRotatingDots(
                        color: KOrange,
                        size: 20,
                      );
                    },
                    errorWidget: (context, url, error) {
                      return const Text('Error');
                    },
                  )),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.blockHorizontal! * 15,
                    horizontal: SizeConfig.blockHorizontal! * 2),
                child: Obx(() => Text(
                      timerController.currentDate.value,
                      style: timeStyle.copyWith(color: Colors.black),
                    )),
              ),
            ],
          ),
        ),
      ),
      body: Obx(
        () => Get.find<LoginController>().loadingView.isFalse
            ? Center(
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
              ))
            : Stack(
                children: [
                  Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topCenter,
                        children: [
                          Get.find<LoginController>()
                                  .borne
                                  .value
                                  .slides!
                                  .isNotEmpty
                              ? CarouselSlider(
                                  options: CarouselOptions(
                                    height: Get.find<LoginController>()
                                            .alertIsEmpty
                                            .value
                                        ? SizeConfig.screenheigth! * 0.995
                                        : SizeConfig.screenheigth! * 0.925,
                                    scrollDirection: Axis.horizontal,
                                    viewportFraction: 1.0,
                                    autoPlay: true,
                                    /*  enableInfiniteScroll:
                                        Get.find<LoginController>()
                                            .enableInfiniteScroll(), */
                                    scrollPhysics:
                                        const NeverScrollableScrollPhysics(),
                                    autoPlayInterval: Duration(
                                        seconds: Get.find<LoginController>()
                                            .duree
                                            .value),
                                    onPageChanged: (index, reason) {
                                      final slide = Get.find<LoginController>()
                                          .borne
                                          .value
                                          .slides;
                                      if (slide!.isNotEmpty) {
                                        Get.find<LoginController>()
                                            .onChangeSlide(slide[index].duree);
                                      }
                                      /*  Get.find<LoginController>().generateToken(); */
                                      // duree = slide![index].duree;
                                    },
                                  ),

                                  // ignore: invalid_use_of_protected_member
                                  items: Get.find<LoginController>()
                                      .borne
                                      .value
                                      .slides!
                                      .map<Widget>((item) {
                                    return TitrologieSlider(slide: item);
                                  }).toList(),
                                )
                              : Container(
                                  height: SizeConfig.screenheigth! * 0.925,
                                  alignment: AlignmentDirectional.center,
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/no-element.png'),
                                      const Text(
                                        "Aucun slide disponible",
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                          /*  Flash Message */

//Flash Infon Widget
                          Get.find<LoginController>().articleIsEmpty.value ==
                                  false
                              ? FlashPushArticle()
                              : const SizedBox.shrink(),
                          //Flash Video
                        ],
                      ),
                      Expanded(
                        child: FlashInfoCard(
                          alertText:
                              Get.find<LoginController>().getAlertesText(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
