// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:borne_flutter/config/size_config.dart';
import 'package:flutter/material.dart';

import 'package:borne_flutter/config/app_style.dart';
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
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(ticket.caisse.libelle),

                // Expanded(
                //   child: ListTile(
                //     leading: const Icon(Icons.contact_page, size: 35),
                //     title: Text(ticket.numClient,
                //         style: laStyle.copyWith(fontSize: 15)),
                //     trailing: Text(
                //       ticket.caisse.libelle,
                //       style: laStyle.copyWith(fontSize: 15),
                //     ),
                //     subtitle: Text(ticket.createdAtDate()),
                //   ),
                // ),
              ],
            ),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    "https://images.pexels.com/photos/1435750/pexels-photo-1435750.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                    width: SizeConfig.blockHorizontal! * 10,
                    height: SizeConfig.blockHorizontal! * 10,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: SizeConfig.blockHorizontal! * 10),
                Text(ticket.numClient)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
