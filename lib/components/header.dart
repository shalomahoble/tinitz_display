// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';

import 'package:borne_flutter/config/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:borne_flutter/config/app_style.dart';
import 'package:borne_flutter/models/Site.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class Header extends StatefulWidget {
  final Site site;
  const Header({
    Key? key,
    required this.site,
  }) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late tz.Location _location;
  String currentTime = '';
  String currentDate = '';

  @override
  void initState() {
    initializeDateFormatting('en_US');
    // TODO: implement initState
    super.initState();

    tz.initializeTimeZones();
    // Remplacez par le fuseau horaire récupéré depuis la base de données
    String timezoneFromDatabase = widget.site.timezone!;
    _location = tz.getLocation(timezoneFromDatabase);

    Timer.periodic(const Duration(seconds: 1), (timer) {
      tz.TZDateTime now = tz.TZDateTime.now(_location);
      DateFormat formatterDate = DateFormat('EEE, MMM d y', 'fr_Fr');
      DateFormat formatter = DateFormat('HH:mm:ss', 'fr_Fr');
      String formattedTime = formatter.format(now);
      String formattedDate = formatterDate.format(now);
      setState(() {
        currentTime = formattedTime;
        currentDate = formattedDate + formattedTime;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.blockHorizontal! * 40,
        vertical: SizeConfig.blockHorizontal! * 10,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.blockHorizontal! * 10,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: widget.site.image,
            height: SizeConfig.blockHorizontal! * 2,
            width: SizeConfig.blockHorizontal! * 1,
            placeholder: (context, url) =>
                LoadingAnimationWidget.discreteCircle(
              color: Colors.green,
              size: 10,
            ),
          ),
          //Image.network(site.image!),
          Text(
            currentDate,
            style: timeStyle,
          ),
        ],
      ),
    );
  }
}
