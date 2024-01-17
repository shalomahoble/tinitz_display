// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:borne_flutter/components/components.dart';
import 'package:borne_flutter/models/Slide.dart';
import 'package:flutter/material.dart';

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
          Image.network(
            backgroundUrlImage(),
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset('assets/images/emppty_slide.png');
            },
          ),
          // CachedNetworkImage(
          //   height: double.infinity,
          //   width: double.infinity,
          //   fit: BoxFit.cover,
          //   imageUrl: backgroundUrlImage(),
          //   errorWidget: (context, url, error) =>
          //       LoadingAnimationWidget.fourRotatingDots(
          //     color: KOrange,
          //     size: 200,
          //   ),
          //   placeholder: (context, url) => Center(
          //     child: LoadingAnimationWidget.fourRotatingDots(
          //       color: KOrange,
          //       size: 60,
          //     ),
          //   ),
          // ),
          BodyCard(
            slide: slide,
          ),
        ],
      );
    }
  }
}
