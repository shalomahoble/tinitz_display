import 'package:borne_flutter/components/components.dart';
import 'package:borne_flutter/config/app_style.dart';
import 'package:borne_flutter/config/size_config.dart';
import 'package:borne_flutter/models/ticket.dart';
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

    return Obx(() {
      if (borneController.tickets.isEmpty) {
        return const SizedBox.shrink();
      } else {
        return Positioned(
          left: 0,
          right: 0,
          bottom: 60,
          child: Container(
            height: SizeConfig.blockHorizontal! * 70,
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