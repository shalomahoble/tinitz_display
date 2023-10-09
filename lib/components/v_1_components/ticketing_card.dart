import 'dart:developer';

import 'package:borne_flutter/components/components.dart';
import 'package:borne_flutter/config/app_style.dart';
import 'package:borne_flutter/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/BorneController.dart';

class TicketingCard extends StatelessWidget {
  const TicketingCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final borneController = Get.find<BorneController>();

    double heightCard() {
      if (borneController.tickets.length == 1) {
        return (SizeConfig.blockHorizontal! * 20) *
            borneController.tickets.length;
      } else if (borneController.tickets.length == 2 ||
          borneController.tickets.length == 3) {
        return (SizeConfig.blockHorizontal! * 14) *
            borneController.tickets.length;
      }
      return SizeConfig.blockHorizontal! * 42;
    }


    /*  borneController.tickets.length <= 3
                ? (SizeConfig.blockHorizontal! * 20) *
                    borneController.tickets.length
                : SizeConfig.blockHorizontal! * 40, */

    return Obx(() {
      if (borneController.tickets.isEmpty) {
        return const SizedBox.shrink();
      } else {
        return Positioned(
          left: 0,
          right: 0,
          bottom: 15,
          child: Container(
            height: heightCard(),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  "Liste de Tickets en cours",
                  style: titleWelcome.copyWith(fontSize: 17),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: AnimatedList(
                    key: borneController.listKey,
                    initialItemCount: borneController.tickets.length,
                    itemBuilder: (context, index, animation) {
                      final ticket = borneController.tickets[index];
                      return TicketingDisplay(
                        ticket: ticket,
                        animation: animation,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}
