// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:borne_flutter/components/components.dart';
import 'package:borne_flutter/config/app_style.dart';
import 'package:borne_flutter/config/size_config.dart';
import 'package:borne_flutter/controllers/BorneController.dart';
import 'package:borne_flutter/models/Artcile.dart';
import 'package:borne_flutter/utils/utils.dart';

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
              const TicketingCard(),
            ],
          ),
        );
      } else {
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/emppty_slide.png'),
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
      decoration: BoxDecoration(
        color: Colors.red.shade400,
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
                    color: Colors.white,
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
                      color: Colors.white,
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
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(width: SizeConfig.blockHorizontal! * 1),
        Text(
          source,
          style: const TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.normal,
            fontSize: 10,
          ),
        ),
        SizedBox(width: SizeConfig.blockHorizontal! * 1),
        const Text(
          "Sponsor :",
          style: TextStyle(
            color: Colors.black,
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
              color: Colors.white,
              fontStyle: FontStyle.normal,
              fontSize: 10,
            )),
      ],
    );
  }
}
