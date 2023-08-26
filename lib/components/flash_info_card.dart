// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:borne_flutter/config/app_style.dart';
import 'package:borne_flutter/config/size_config.dart';
import 'package:marquee/marquee.dart';

class FlashInfoCard extends StatelessWidget {
  final String alertText;
  const FlashInfoCard({
    Key? key,
    required this.alertText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    /* String alerteLabel;
    List<String> labelsList = alert.map((item) => item.libelle).toList();
    alerteLabel = labelsList.join('  .'); */

    /* String type = 'text'; */

    /*  final alertLibelle = alert
        .where((item) => item.typealert?.libelle!.toLowerCase() == 'text')
        .toList(); */

    if (alertText.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.8), // Couleur et opacité de l'ombre
              spreadRadius: 5, // Étalement de l'ombre
              blurRadius: 7, // Flou de l'ombre
              offset: const Offset(
                0,
                3,
              ), // Décalage de l'ombre (horizontal, vertical)
            ),
          ],
          color: Colors.white,
          //shape: BoxShape.rectangle,
        ), // La couleur rouge s'appliquera à toute la Row
        child: Row(
          children: [
            Container(
              // La couleur rouge s'appliquera à ce Container
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.blockHorizontal! * 4.5,
                horizontal: SizeConfig.blockHorizontal! * 5,
              ),
              alignment: AlignmentDirectional.center,
              decoration: const BoxDecoration(
                color: Colors.red,
              ),
              child: Text(
                'Flash Infos',
                style: flashInfoTitleStyle,
              ),
            ),
            Expanded(
                child: SizedBox(
              height: SizeConfig.blockHorizontal! * 20,
              child: Marquee(
                text: "$alertText |",
                style: flashInfoTextStyle.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ))
            /*  Expanded(
              child: Container(
                color: Colors.white,
                height: SizeConfig.blockHorizontal! * 15.5,
                alignment: AlignmentDirectional.center,
                /*  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.blockHorizontal! * 1), */
                child: Marqueer.builder(
                  itemCount: alertLibelle.length,
                  pps: 60.0,
                  direction: MarqueerDirection.ltr,
                  autoStart: true,
                  interaction: true,
                  restartAfterInteractionDuration: const Duration(seconds: 1),
                  restartAfterInteraction: true,
                  autoStartAfter: const Duration(milliseconds: 20),
                  itemBuilder: (context, index) {
                    return Container(
                      alignment: AlignmentDirectional.center,
                      child: Text(
                        '${alertLibelle[index].libelle}.',
                        style: flashInfoTextStyle.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Padding(
                      padding: EdgeInsets.zero,
                      child: VerticalDivider(
                        color: KOrange,
                        width: 15.0,
                      ),
                    );
                  },
                ),
              ),
            ), */
          ],
        ),
      );

/*     switch (type) {
      case 'text':
        return Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.red,
                ),
                alignment: Alignment.center,
                child: Text(
                  'Flash Info',
                  style: flashInfoTitleStyle,
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20, left: 5),
                  child: Marqueer(
                    pps: 50,
                    direction: MarqueerDirection.rtl,
                    restartAfterInteractionDuration: const Duration(seconds: 6),
                    restartAfterInteraction: true,
                    autoStartAfter: const Duration(seconds: 5),
                    child: Text(
                      alerteLabel,
                      style: flashInfoTextStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      case 'image':
        return Expanded(
            child: Marqueer(
          pps: 50,
          direction: MarqueerDirection.rtl,
          restartAfterInteractionDuration: const Duration(seconds: 6),
          restartAfterInteraction: true,
          autoStartAfter: const Duration(seconds: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            margin: const EdgeInsets.symmetric(horizontal: 0),
            decoration: const BoxDecoration(
              color: Colors.amber,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                      'https://images.pexels.com/photos/6931425/pexels-photo-6931425.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                ),
                /*  Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: 100,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.pexels.com/photos/6931425/pexels-photo-6931425.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                      ),
                    ),
                  ),
                ), */
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(alerteLabel, style: flashInfoTextStyle),
                )
              ],
            ),
          ),
        ));
      default:
        return const SizedBox.shrink();
    } */
    }
  }
}
