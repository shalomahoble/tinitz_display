import 'package:borne_flutter/config/app_config.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

const String urlScanneCodeQr = "https://devmarket.egaz.shop/api/redirect?";

final box = GetStorage();
//Convert url to Uri
Uri getUrl(String url) {
  return Uri.parse('$baseUrl$url');
}

Uri getQueingUrl(String url) {
  return Uri.parse('$queingUrl$url');
}

void showMessageError(
    {String title = 'Error Message',
    required String message,
    Color color = Colors.red,
    SnackPosition position = SnackPosition.TOP,
    Duration? duration}) {
  Get.snackbar(
    title,
    message,
    backgroundColor: color,
    snackPosition: position,
    duration: duration,
  );
}

//recuperer le token
String getToken() {
  return box.read('token');
}

//Sauvegader le token

Future<void> saveToken(String token) async {
  box.write('token', token);
}

//remove token
Future<void> removeToken() async {
  box.remove('token');
}

// Return url to slide or article

String codeQr(String params, int borneId) {
  return "$urlScanneCodeQr$params&borne=$borneId";
}
