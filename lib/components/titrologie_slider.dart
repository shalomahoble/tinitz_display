// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:borne_flutter/components/components.dart';
import 'package:borne_flutter/config/app_style.dart';
import 'package:borne_flutter/models/Slide.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../config/size_config.dart';

// ignore: must_be_immutable
class TitrologieSlider extends StatelessWidget {
  final Slide slide;
  const TitrologieSlider({
    Key? key,
    required this.slide,
  }) : super(key: key);

  String backgroundUrlImage() {
    if (slide.bgType.toLowerCase() == 'image') {
      return slide.bg!;
    } else {
      return 'https://images.pexels.com/photos/2882552/pexels-photo-2882552.jpeg';
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    if (slide.bgType == 'url') {
      return SectionHtml(pageUrl: slide.cible);
    } else {
      return Stack(
        children: [
          CachedNetworkImage(
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
            imageUrl: backgroundUrlImage(),
            errorWidget: (context, url, error) =>
                LoadingAnimationWidget.fourRotatingDots(
              color: KOrange,
              size: 200,
            ),
            placeholder: (context, url) => Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: KOrange,
                size: 60,
              ),
            ),
          ),
          BodyCard(
            slide: slide,
          ),
        ],
      );
    }
  }
}
