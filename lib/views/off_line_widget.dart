// ignore_for_file: must_be_immutable

import 'package:borne_flutter/config/app_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OffLineWidget extends StatelessWidget {
  OffLineWidget({super.key, this.onPressed});

  final void Function()? onPressed;

  String currentDate = '';

  String getCurrentDateTime() {
    currentDate = DateFormat('EEE d MMM  y', 'fr_Fr').format(DateTime.now());
    return '${currentDate[0].toUpperCase() + currentDate.substring(1)} ${DateFormat('HH:mm', 'fr_Fr').format(DateTime.now())}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset("assets/images/tinitz-logo.png"),
                Text(getCurrentDateTime(), style: labelStyle),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Veuillez vérifier votre connexion internet.",
              style: emptyTextForSlide,
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
              onPressed: onPressed,
              icon: const Icon(Icons.wifi_off, size: 100)),
          const Spacer(),
        ],
      ),
    );
  }
}
