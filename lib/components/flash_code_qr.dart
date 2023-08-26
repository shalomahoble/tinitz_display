// ignore_for_file: must_be_immutable

import 'package:borne_flutter/config/app_style.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class FlashCodeQR extends StatelessWidget {
  FlashCodeQR({
    Key? key,
  }) : super(key: key);

  String url = "http://devmarket.egaz.shop/titrologie/";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        children: [
          QrImageView(
            padding: EdgeInsets.zero,
            data:
                'https://images.unsplash.com/photo-1580894894513-541e068a3e2b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=870&q=80',
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Scanner Ce code Qr",
                style: scannerTitleStyle,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Pour lire l'article",
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: scannerSubTitleStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
