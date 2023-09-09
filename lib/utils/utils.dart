import 'package:borne_flutter/config/app_config.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String urlScanneCodeQr = "https://devmarket.egaz.shop/api/redirect?";
//Convert url to Uri
Uri getUrl(String url) {
  return Uri.parse('$baseUrl$url');
}

void showMessageError(
    {String title = 'Error Message',
    required String message,
    Color color = Colors.red,
    SnackPosition position = SnackPosition.TOP}) {
  Get.snackbar(title, message, backgroundColor: color, snackPosition: position);
}

//recuperer le token
Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token') ?? '';
}

//Sauvegader le token

Future<void> saveToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // ignore: unnecessary_null_comparison
  if (token != null && token.isNotEmpty) {
    await prefs.setString('token', token);
  }
}

//remove token
Future<void> removeToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
}

// Return url to slide or article

String codeQr(String params, int borneId) {
  return "$urlScanneCodeQr$params&borne=$borneId";
}
