// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:borne_flutter/controllers/LoginController.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimerController extends GetxController {
  final LoginController loginController = Get.put(LoginController());
  late final tz.Location _location;
  String timeZone = '';
  RxString currentDate = ''.obs;
  RxString currentTime = ''.obs;
  String? formattedDateTime;
  Rx<DateTime> now = Rx<DateTime>(DateTime.now());
/*   TimerController({
    required this.timeZone,
  }); */

  @override
  void onInit() {
    super.onInit();
    initializeDateFormatting('en_US');
    tz.initializeTimeZones();
    // Remplacez par le fuseau horaire récupéré depuis la base de données
    if (loginController.borne.value.site != null &&
        loginController.borne.value.site!.timezone != null) {
      timeZone = loginController.borne.value.site!.timezone!;
      _location = tz.getLocation(timeZone);
      // Utiliser Stream.periodic pour mettre à jour l'heure à intervalles réguliers

      Timer.periodic(const Duration(seconds: 1), (timer) {
        tz.TZDateTime date = tz.TZDateTime.now(_location);
        formattedDateTime = DateFormat('EEE, MMM d y', 'fr_Fr').format(date);
        currentDate.value = formattedDateTime!;
        currentTime.value = DateFormat('HH:mm', 'fr_Fr').format(date);
        currentDate.value = '${currentDate.value} ${currentTime.value}';
        /* print(currentDate.value); */
        /* now.value = DateTime.now();
      print('Date et heure actuelles : ${now.value}'); */
      });
    } else {
      currentDate.value = now.string;
    }
  }
}
