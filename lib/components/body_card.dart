// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:borne_flutter/components/components.dart';
import 'package:borne_flutter/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:borne_flutter/models/Slide.dart';

// ignore: must_be_immutable
class BodyCard extends StatelessWidget {
  final Slide slide;
  const BodyCard({
    Key? key,
    required this.slide,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      padding: EdgeInsets.all(SizeConfig.blockHorizontal! * 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: QRcode(slide: slide),
    );
  }
}

class BodySection extends StatelessWidget {
  final Slide slide;
  const BodySection({
    Key? key,
    required this.slide,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var section = slide.sections?.firstWhere((el) => el.section == 'body');
    /* section.typecontenu!.libelle!.toLowerCase() */
    if (section != null) {
      switch (section.typecontenu!.libelle!.toLowerCase()) {
        case 'text':
        default:
          return LoadingAnimationWidget.fourRotatingDots(
            color: Colors.green,
            size: 35,
          );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}
