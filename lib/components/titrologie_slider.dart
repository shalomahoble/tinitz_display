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
    if (slide.bgType == 'image') {
      return slide.bg!;
    } else {
      return 'https://images.pexels.com/photos/270348/pexels-photo-270348.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    if (slide.bgType == 'url') {
      return SectionHtml(
        pageUrl: slide.cible!,
      );
    } else {
      return Stack(
        children: [
          /*  Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  'https://images.pexels.com/photos/18032304/pexels-photo-18032304/free-photo-of-au-milieu-des-arbres-du-jardin-botanique-hamma.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                ),
              ),
            ),
          ), */
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
            placeholder: (context, url) => const Text("Slide Insdiponible"),
          ),
          BodyCard(
            slide: slide,
          ),

          /*  SizedBox(
            height: double.infinity,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              imageUrl: backgroundUrlImage(),
              placeholder: (context, url) {
                return LoadingAnimationWidget.fourRotatingDots(
                  color: KOrange,
                  size: 200,
                );
              },
              errorWidget: (context, url, error) {
                return Image.asset('assets/images/error.png');
              },
            ),
          ), */
          /*  Container(
            width: SizeConfig.screenWidth,
            alignment: AlignmentDirectional.center,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BodyCard(
                  slide: slide,
                )
              ],
            ),
          ), */
        ],
      );
    }
  }
}
