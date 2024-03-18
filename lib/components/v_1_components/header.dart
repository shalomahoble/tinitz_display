// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:borne_flutter/config/app_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:borne_flutter/config/size_config.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.time,
    this.imagePath,
    this.onPress,
  }) : super(key: key);

  final String time;
  final String? imagePath;
  final void Function()? onPress;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Expanded(
      flex: 0,
      child: GestureDetector(
        onTap: onPress,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockHorizontal! * 2,
            vertical: SizeConfig.blockHorizontal! * 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CachedNetworkImage(
                imageUrl: imagePath!,
                fit: BoxFit.cover,
                height: SizeConfig.blockHorizontal! * 15,
                errorWidget: (context, url, error) => const Text(
                  "Image du site insdisponible...",
                ),
                placeholder: (context, url) =>
                    LoadingAnimationWidget.fourRotatingDots(
                  color: KOrange,
                  size: 20,
                ),
              ),
              Text(
                time,
                style: timeStyle.copyWith(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
