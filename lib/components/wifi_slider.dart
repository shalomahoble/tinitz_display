import 'package:borne_flutter/config/size_config.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WifiSlider extends StatelessWidget {
  WifiSlider({super.key});

  String urlImage =
      'https://images.pexels.com/photos/935979/pexels-photo-935979.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';

  String srcImage =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/Orange_logo.svg/langfr-150px-Orange_logo.svg.png';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height: SizeConfig.screenheigth,
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(urlImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: SizeConfig.screenWidth! / 3),
            child: const Column(
              children: [
                Text(
                  'WIFI',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 5.0,
                  ),
                ),
                Text(
                  'GRATUIT',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Text(
                'Offert par',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Image.network(
                srcImage,
                width: SizeConfig.screenWidth! / 3,
              ),
            ],
          ),
         // QRcode()
        ],
      ),
    );
  }
}
