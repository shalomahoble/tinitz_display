// ignore_for_file: file_names

import 'dart:convert';

import 'package:borne_flutter/config/app_config.dart';
import 'package:borne_flutter/utils/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

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
          return http.Response("", 400);
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Genrer un nouveau token
  Future<http.Response> generateNewToken() async {
    http.Response response = http.Response("", 200);
    try {
      String token = await getToken();
      // ignore: unnecessary_null_comparison
      if (token == null) {
        showMessageError(message: "Le token est nul !");
        return http.Response("Le token est nul", 400);
      }
      response = await http
          .post(
        getUrl('auth/refresh'),
        headers: headersToken(token),
      )
          .timeout(
        const Duration(minutes: 2),
        onTimeout: () {
          showMessageError(
              message:
                  "Une erreur c'est produite vérifié votre connexion internet ");
          return http.Response(
              "Une erreur c'est produite ${response.body.toString()}", 400);
        },
      );
      print("EVENTBD ${response.body.toString()}");
      return response;
    } catch (e) {
      // Gérer l'erreur ici si nécessaire
      rethrow;
    }
  }
}
