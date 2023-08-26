import 'dart:convert';

import 'package:borne_flutter/config/app_config.dart';
import 'package:borne_flutter/utils/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  final box = GetStorage();

  Future<http.Response> loginBorne(
      {required String code, required String password}) async {
    try {
      http.Response response = await http
          .post(getUrl('auth/login'),
              headers: headers,
              body: jsonEncode({
                "code": code,
                "password": password,
              }))
          .timeout(
        const Duration(seconds: 40),
        onTimeout: () {
          return http.Response("Une erreur c'est produite", 400);
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Genrer un nouveau token
  Future<http.Response> generateNewToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? box.read('token');
      final response = await http
          .post(
        getUrl('auth/refresh'),
        headers: headersToken(token),
      )
          .timeout(
        const Duration(seconds: 1),
        onTimeout: () {
          showMessageError(
              message:
                  "Une erreur c'est produite vérifié votre connexion internet ");
          return http.Response("Une erreur c'est produite", 400);
        },
      );

      return response;
    } catch (e) {
      // Gérer l'erreur ici si nécessaire
      rethrow;
    }
  }
}
