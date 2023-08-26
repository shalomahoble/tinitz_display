import 'package:borne_flutter/config/app_style.dart';
import 'package:borne_flutter/models/Slide.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SectionEvent extends StatelessWidget {
  const SectionEvent({
    super.key,
    required this.slide,
  });

  final Slide slide;

  @override
  Widget build(BuildContext context) {
    String formateDate(DateTime date) {
      return DateFormat('dd/MM/yyyy').format(date);
    }

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: Colors.black.withOpacity(0.3),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slide.event!.libelle!,
                  style: scannerTitleStyle.copyWith(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.justify,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      slide.event!.ville!,
                      style: scannerSubTitleStyle.copyWith(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      formateDate(slide.event!.dateDebut!),
                      style: scannerSubTitleStyle.copyWith(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '- ${formateDate(slide.event!.dateFin!)}',
                      style: scannerSubTitleStyle.copyWith(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}