// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:marqueer/marqueer.dart';

import 'package:borne_flutter/config/app_style.dart';
import 'package:borne_flutter/config/size_config.dart';

class FlashInfoWidget extends StatelessWidget {
  final String alertText;
  FlashInfoWidget({
    Key? key,
    required this.alertText,
  }) : super(key: key);
  final controller = MarqueerController();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    if (alertText.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return Expanded(
        flex: 0,
        child: Container(
          height: SizeConfig.blockHorizontal! * 15,
          color: Colors.white,
          child: Row(
            children: [
              Container(
                height: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockHorizontal! * 4,
                ),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                  ),
                ),
                alignment: AlignmentDirectional.center,
                child: Text(
                  'Flash Infos',
                  style: flashInfoTitleStyle,
                ),
              ),
              Expanded(
                child: Container(
                  child: Marquee(
                    text: '$alertText | ',
                    style: flashInfoTextStyle.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
