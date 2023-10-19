// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:borne_flutter/config/app_style.dart';
import 'package:borne_flutter/config/size_config.dart';
import 'package:flutter/material.dart';

import 'package:borne_flutter/models/ticket.dart';

class TicketingDisplay extends StatelessWidget {
  const TicketingDisplay({
    Key? key,
    required this.ticket,
    required this.animation,
  }) : super(key: key);
  final Ticket ticket;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizeTransition(
      sizeFactor: animation,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Text(
                ticket.caisse.libelle,
                style: flashInfoTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    ticket.caisse.image,
                    width: SizeConfig.blockHorizontal! * 5,
                    height: SizeConfig.blockHorizontal! * 5,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: SizeConfig.blockHorizontal! * 10),
                Text(
                  ticket.numClient,
                  style: flashInfoTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
