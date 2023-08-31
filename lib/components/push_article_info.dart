// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:borne_flutter/config/app_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:borne_flutter/config/size_config.dart';
import 'package:borne_flutter/models/Artcile.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PushArticleInfo extends StatelessWidget {
  final Article article;
  const PushArticleInfo({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    if (article == null) {
      return const SizedBox.shrink();
    } else {
      return Container(
        height: SizeConfig.blockHorizontal! * 20,
        /*  margin: EdgeInsets.only(left: SizeConfig.blockHorizontal! * 10), */
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockHorizontal! * 2,
          vertical: SizeConfig.blockHorizontal! * 2,
        ),
        decoration: const BoxDecoration(
          color: Color(0xfff8f7fa),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(7),
                bottomLeft: Radius.circular(7),
              ),
              child: CachedNetworkImage(
                width: SizeConfig.blockHorizontal! * 20,
                height: double.infinity,
                imageUrl: article.image,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    Image.asset('assets/images/error.png'),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: SizeConfig.blockHorizontal! * 52,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: AutoSizeText(
                      article.title,
                      style: flashInfoTitleStyle.copyWith(
                        color: Colors.grey.shade800,
                        fontSize: 15,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      "Source : ",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      "${article.source} |",
                      style: const TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontSize: 10,
                      ),
                    ),
                    const Text(
                      " Sponsorisé par : ",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.blockHorizontal! * 1.5),
                      width: SizeConfig.blockHorizontal! * 7,
                      height: SizeConfig.blockHorizontal! * 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            article.logoSponsor!,
                          ),
                          onError: (exception, stackTrace) =>
                              const SizedBox.shrink(),
                        ),
                      ),
                    ),
                    SizedBox(width: SizeConfig.blockHorizontal! * 2),
                    Text(
                      article.nomSponsor ?? "",
                      style: const TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: SizeConfig.blockHorizontal! * 10,
                  child: QrImageView(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.white,
                    data: article.url,
                  ),
                ),
                SizedBox(height: SizeConfig.blockHorizontal! * 1),
                SizedBox(
                  width: SizeConfig.blockHorizontal! * 10,
                  child: Text(
                    "Scanner le code Qr pour lire plus.",
                    style: scannerSubTitleStyle.copyWith(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 4,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}



      /*  return Container(
      height: SizeConfig.blockHorizontal! * 15,
      margin: const EdgeInsets.symmetric(),
      child: Row(
        children: [
          const SizedBox(
            width: 120,
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(7), bottomLeft: Radius.circular(7)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.white,
                  // width: 5.0,
                ),
              ),
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(7)),
                child: CachedNetworkImage(
                  imageUrl: article.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: SizeConfig.blockHorizontal! * 15,
              padding: EdgeInsets.symmetric(
                /*  vertical: SizeConfig.blockHorizontal! * 1.2, */
                horizontal: SizeConfig.blockHorizontal! * 2,
              ),
              decoration: const BoxDecoration(
                color: Color(0xfff8f7fa),
                gradient: LinearGradient(
                  colors: [
                    //KOrange,
                    Color(0xfff8f7fa),
                    Color(0xfff8f7fa)
                    // Colors.white,
                  ], // Couleurs du dégradé
                  begin: Alignment.centerLeft, // Début du dégradé (gauche)
                  end: Alignment.centerRight, // Fin du dégradé (droite)
                ),
              ),
              child: Text(
                article.title,
                style: flashInfoTitleStyle.copyWith(
                  color: Colors.grey.shade800,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          Container(
            // width: Get.width / 7,
            height: SizeConfig.blockHorizontal! * 15,
            decoration: const BoxDecoration(
              color: Color(0xfff8f7fa),
              gradient: LinearGradient(
                colors: [
                  //KOrange,
                  Color(0xfff8f7fa),
                  Color(0xfff8f7fa),

                  // Colors.white,
                ], // Couleurs du dégradé
                begin: Alignment.centerLeft, // Début du dégradé (gauche)
                end: Alignment.centerRight, // Fin du dégradé (droite)
              ),
              // border: Border.all(
              //   color: Colors.orange.shade100,
              //   // width: 7.0,
              // ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: SizeConfig.blockHorizontal! * 30,
                  child: Text(
                    textAlign: TextAlign.justify,
                    "Scanner pour lire plus.",
                    style: scannerSubTitleStyle.copyWith(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: Get.width / 10,
            height: SizeConfig.blockHorizontal! * 15,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  //KOrange,
                  Color(0xfff8f7fa),
                  Color(0xfff8f7fa),

                  // Colors.white,
                ], // Couleurs du dégradé
                begin: Alignment.centerLeft, // Début du dégradé (gauche)
                end: Alignment.centerRight, // Fin du dégradé (droite)
              ),
              // border: Border.all(
              //   color: Colors.white,
              //   // width: 7.0,
              // ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: SizeConfig.blockHorizontal! * 10,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.blueGrey.shade50,
                    // width: 7.0,
                  )),
                  child: QrImageView(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.white,
                    data: article.url,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ); */

