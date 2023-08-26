// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:borne_flutter/components/v_1_components/caroussel_widget.dart';
import 'package:borne_flutter/controllers/BorneController.dart';
import 'package:borne_flutter/controllers/LoginController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:borne_flutter/config/app_style.dart';
import 'package:borne_flutter/config/size_config.dart';
import 'package:borne_flutter/models/Artcile.dart';

class FlashPushArticle extends StatelessWidget {
  const FlashPushArticle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();
    final borneController = Get.find<BorneController>();

    if (borneController.articles.isEmpty) {
      return const SizedBox.shrink();
    } else if (borneController.articles.isNotEmpty) {
      return Obx(
        () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: const Offset(0, 0.1),
                ).animate(animation),
                child: child,
              );
            },
            child: FlashArticle(
              article: borneController
                  .articles[borneController.currentArticleIndex.value],
              key: ValueKey<int>(borneController.articleChangeAnimation.value),
            )

            /*  PushArticleInfo(
            article: loginController.borne.value
                    .articles![loginController.currentIndex.value] ??
                article,
            key: ValueKey<int>(loginController.changeArticle.value),
          ), */
            ),
      );
      /*  CardAnimatedArticle(); */
    } else {
      return const SizedBox.shrink();
    }
  }
}

class CardAnimatedArticle extends StatelessWidget {
  final Article article;
  const CardAnimatedArticle({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      height: SizeConfig.blockHorizontal! * 20,
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockHorizontal! * 2),
      padding: EdgeInsets.all(SizeConfig.blockHorizontal! * 2),
      /* color: Colors.grey.shade100, */
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CachedNetworkImage(
                width: SizeConfig.blockHorizontal! * 15,
                fit: BoxFit.cover,
                imageUrl: article.image,
                placeholder: (context, url) =>
                    LoadingAnimationWidget.bouncingBall(
                  color: Colors.green,
                  size: 30,
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: SizeConfig.blockHorizontal! * 2.0),
                child: SizedBox(
                  /*  width: SizeConfig.screenheigth! * 0.8, */
                  width: SizeConfig.blockHorizontal! * 30,
                  child: Text(
                    article.title,
                    style: flashInfoTitleStyle,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(SizeConfig.blockHorizontal! * 2),
            height: SizeConfig.blockHorizontal! * 15,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Row(
              children: [
                QrImageView(
                  padding: EdgeInsets.zero,
                  data: article.url,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockHorizontal! * 2.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Scannez Ce code Qr",
                          style: scannerTitleStyle,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Pour lire l'article",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: scannerSubTitleStyle,
                        ),
                      ],
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
