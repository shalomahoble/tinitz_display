import 'package:borne_flutter/config/app_config.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Convert url to Uri
Uri getUrl(String url) {
  return Uri.parse('$baseUrl$url');
}

void showMessageError(
    {String title = 'Error Message', required String message}) {
  Get.snackbar(
    title,
    message,
    backgroundColor: Colors.red.shade600,
  );
}

//recuperer le token
Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token') ?? '';
}

//Sauvegader le token

Future<void> saveToken(String? token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (token != null && token.isNotEmpty) {
    await prefs.setString('token', token);
  }
}
