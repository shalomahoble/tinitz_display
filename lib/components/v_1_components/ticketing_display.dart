// ignore_for_file: public_member_api_docs, sort_constructors_first
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
    return SizeTransition(
      sizeFactor: animation,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListTile(
                leading: const Icon(Icons.contact_page, size: 35),
                title: Text(ticket.numClient,
                    style: laStyle.copyWith(fontSize: 15)),
                trailing: Text(
                  ticket.caisse.libelle,
                  style: laStyle.copyWith(fontSize: 15),
                ),
                subtitle: Text(ticket.createdAtDate()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
