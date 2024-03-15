// ignore: duplicate_ignore
// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, unused_local_variable

import 'package:borne_flutter/config/app_style.dart';
import 'package:borne_flutter/controllers/BorneController.dart';
import 'package:borne_flutter/services/ShortUrlService.dart';
import 'package:borne_flutter/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:borne_flutter/config/size_config.dart';
import 'package:borne_flutter/models/Slide.dart';

class QRcode extends StatelessWidget {
  final Slide slide;
  const QRcode({
    Key? key,
    required this.slide,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borneController = Get.find<BorneController>();
    final ShortUrlService shortUrlService = ShortUrlService();
    final codeBorne = borneController.borne.value.code;
    final box = GetStorage();
    String url = '';
    String codeQrUrl() {
      final token = box.read('token');
      return "https://devmarket.egaz.shop/reading?q=$codeBorne&tk=$token";
    }

    Widget displayCodeQr() {
      if (slide.typeslide != null && slide.typeslide!.libelle != null) {
        switch (slide.typeslide!.libelle!.toLowerCase()) {
          case 'titrologie':
            return QrImageView(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(8.0),
              version: QrVersions.auto,
              data: codeQrUrl(),
            );
          case 'wifi':
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                    width: 7,
                  )),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: slide.qrcode.toString(),
                placeholder: (context, url) =>
                    LoadingAnimationWidget.bouncingBall(
                  color: KOrange,
                  size: 20,
                ),
              ),
            );
          case 'evenements':
            return QrImageView(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(8.0),
              version: QrVersions.auto,
              data: codeQr("slide=${slide.id}", slide.pivot!.borneId!),
            );
          case 'autres':
            if (slide.qrcode != null) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                      width: 7,
                    )),
                child: CachedNetworkImage(
                  imageUrl: slide.qrcode ??
                      'https://images.pexels.com/photos/7289721/pexels-photo-7289721.jpeg?auto=compress&cs=tinysrgb&w=600',
                  placeholder: (context, url) =>
                      LoadingAnimationWidget.bouncingBall(
                    color: KOrange,
                    size: 20,
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          default:
            return const SizedBox.shrink();
        }
      }
      return const SizedBox.shrink();
    }

    return Container(
      width: SizeConfig.screenheigth! * 0.3,
      height: SizeConfig.blockVertical! * 25,
      alignment: AlignmentDirectional.center,
      child: displayCodeQr(),
    );
  }
}

class QrCodeSecond extends StatelessWidget {
  final Slide slide;
  final String codeBorne;
  QrCodeSecond({
    Key? key,
    required this.slide,
    required this.codeBorne,
  }) : super(key: key);

  String url = "http://devmarket.egaz.shop/titrologie/";

  String codeQr() {
    if (slide.typeslide!.libelle!.toLowerCase() == 'wifi') {
      return 'wifi';
    } else if (slide.typeslide!.libelle!.toLowerCase() == 'titrologie') {
      return url + codeBorne;
    } else if (slide.typeslide!.libelle!.toLowerCase() == 'evenements') {
      return slide.event!.url;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unrelated_type_equality_checks
    if (slide.qrcode == 1) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.all(10),
        width: SizeConfig.screenWidth! * 0.3,
        height: SizeConfig.screenWidth! * 0.4,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(
          children: [
            QrImageView(
              padding: EdgeInsets.zero,
              size: 90,
              data: codeQr(),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Text(slide.descQrcodeFirst ?? 'Scanner le Qr code '),
            )
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class QrCodeForSecond extends StatelessWidget {
  final Slide slide;
  final String codeBorne;
  QrCodeForSecond({
    Key? key,
    required this.slide,
    required this.codeBorne,
  }) : super(key: key);

  String url = "http://devmarket.egaz.shop/titrologie/";

  String codeQr() {
    if (slide.typeqrcode!.libelle!.toLowerCase() == 'wifi') {
      return 'wifi';
    } else if (slide.typeslide!.libelle!.toLowerCase() == 'titrologie') {
      return url + codeBorne;
    } else if (slide.typeslide!.libelle!.toLowerCase() == 'evenements') {
      return slide.event!.url;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    if (slide.qrcodeSecond == 1) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.all(10),
        width: SizeConfig.screenWidth! * 0.3,
        height: SizeConfig.screenWidth! * 0.4,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            QrImageView(
              backgroundColor: Colors.white,
              padding: EdgeInsets.zero,
              size: 80,
              data: codeQr(),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                slide.descQrcodeSecond ?? ' Scanner le code Qr',
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
