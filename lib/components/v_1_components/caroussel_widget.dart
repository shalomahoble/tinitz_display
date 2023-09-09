// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:borne_flutter/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:borne_flutter/components/flash_push_article.dart';
import 'package:borne_flutter/components/titrologie_slider.dart';
import 'package:borne_flutter/config/app_style.dart';
import 'package:borne_flutter/config/size_config.dart';
import 'package:borne_flutter/controllers/BorneController.dart';
import 'package:borne_flutter/models/Artcile.dart';

class CarousselWidget extends StatelessWidget {
  const CarousselWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final borneController = Get.find<BorneController>();

    List<Widget> items = borneController.slides
        .map<Widget>((item) => TitrologieSlider(slide: item))
        .toList();

    return Obx(() {
      if (borneController.slides.isNotEmpty) {
        return Expanded(
          flex: 8,
          child: Stack(
            children: [
              CarouselSlider(
                items: items,
                options: CarouselOptions(
                  height: double.infinity,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  viewportFraction: 1.0,
                  // si on a 1 seul element on ne srolle pas
                  autoPlay: (items.length == 1) ? false : true,
                  //scrollPhysics: const NeverScrollableScrollPhysics(),
                  autoPlayInterval:
                      Duration(seconds: borneController.dureeDuSlide.value),
                  onPageChanged: (index, reason) {
                    borneController.slideChange(index);
                  },
                ),
              ),

              /*  const FlashArticle(), */
              FlashPushArticle(articles: borneController.articles),
              Positioned(
                left: 0,
                right: 0,
                bottom: 60,
                child: Container(
                  height: 250,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Caisse 02",
                            style: flashInfoTextStyle.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Divider(color: Colors.black, thickness: 2),
                          Text("00001 - Pierre", style: flashInfoTextStyle)
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("00001 - Pierre", style: flashInfoTextStyle),
                              Expanded(
                                  child: Container(
                                width: 10,
                                height: 2,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                ),
                              )),
                              Text(
                                "Caisse 02",
                                style: flashInfoTextStyle.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.black, thickness: 2),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Expanded(
          child: Column(
            children: [
              Image.asset('assets/images/no-element.png'),
              Text(
                "Aucun slide disponible",
                style: emptyTextForSlide,
              )
            ],
          ),
        );
      }
    });
  }
}

class FlashArticle extends StatelessWidget {
  const FlashArticle({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.blockHorizontal! * 1,
        horizontal: SizeConfig.blockHorizontal! * 1,
      ),
      height: SizeConfig.blockHorizontal! * 20,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: article.image,
              fit: BoxFit.cover,
              height: SizeConfig.blockHorizontal! * 20,
              width: SizeConfig.blockHorizontal! * 20,
              placeholder: (context, url) =>
                  LoadingAnimationWidget.fourRotatingDots(
                color: KOrange,
                size: 45,
              ),
              errorWidget: (context, url, error) => Image.asset(
                "assets/images/error.png",
                fit: BoxFit.cover,
                height: SizeConfig.blockHorizontal! * 20,
                width: SizeConfig.blockHorizontal! * 20,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: SizeConfig.blockHorizontal! * 55,
                child: Text(
                  article.title,
                  style: flashInfoTitleStyle.copyWith(
                    color: Colors.grey.shade800,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              ),
              SponsorWidget(
                source: article.source,
                sponsor: article.nomSponsor,
                nomSponsor: article.nomSponsor,
                logoSponsor: article.logoSponsor,
              )
            ],
          ),
          Container(
            width: SizeConfig.blockHorizontal! * 20,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                QrImageView(
                  size: SizeConfig.blockHorizontal! * 12,
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.white,
                  data: codeQr("article=${article.id}", article.pivot.borneId!),
                ),
                SizedBox(height: SizeConfig.blockHorizontal! * 1),
                SizedBox(
                  width: SizeConfig.blockHorizontal! * 15,
                  child: Text(
                    "Scanner le Qr Code pour lire plus l'article",
                    style: scannerSubTitleStyle.copyWith(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 4,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SponsorWidget extends StatelessWidget {
  const SponsorWidget({
    Key? key,
    required this.source,
    this.sponsor,
    this.nomSponsor,
    this.logoSponsor,
  }) : super(key: key);

  final String source;
  final String? sponsor;
  final String? nomSponsor;
  final String? logoSponsor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Source :",
          style: TextStyle(
            color: Colors.red,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(width: SizeConfig.blockHorizontal! * 1),
        Text(
          source,
          style: const TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.normal,
            fontSize: 10,
          ),
        ),
        SizedBox(width: SizeConfig.blockHorizontal! * 1),
        const Text(
          "Sponsor :",
          style: TextStyle(
            color: Colors.red,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(width: SizeConfig.blockHorizontal! * 1),
        CachedNetworkImage(
          imageUrl: logoSponsor!,
          width: SizeConfig.blockHorizontal! * 7,
          height: SizeConfig.blockHorizontal! * 7,
          placeholder: (context, url) =>
              LoadingAnimationWidget.fourRotatingDots(color: KOrange, size: 20),
          errorWidget: (context, url, error) => const SizedBox.shrink(),
        ),
        SizedBox(width: SizeConfig.blockHorizontal! * 1),
        Text(nomSponsor ?? '...',
            style: const TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.normal,
              fontSize: 10,
            )),
      ],
    );
  }
}
