import 'package:borne_flutter/components/components.dart';
import 'package:borne_flutter/config/app_style.dart';
import 'package:borne_flutter/config/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../models/Slide.dart';

class SectionWifi extends StatelessWidget {
  const SectionWifi({
    super.key,
    required this.slide,
  });

  final Slide slide;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //height: SizeConfig.screenheigth! / 1.5,
      //alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Ce wifi vous est offert par',
              style: timeStyle.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: Colors.white,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          QRcode(
            slide: slide,
          ),
          CachedNetworkImage(
            imageUrl: slide.partenaire!.logo!,
            height: SizeConfig.screenWidth! * 0.2,
            width: SizeConfig.screenWidth! * 0.3,
            fit: BoxFit.contain,
            placeholder: (context, url) =>
                LoadingAnimationWidget.discreteCircle(
              color: Colors.green,
              size: 10,
            ),
          ),
        ],
      ),
    );
  }
}
