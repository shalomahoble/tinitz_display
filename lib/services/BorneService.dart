import 'dart:convert';
import 'dart:developer';

import 'package:borne_flutter/config/app_config.dart';
import 'package:borne_flutter/utils/utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class BorneService extends GetxService {
  final box = GetStorage();
  //Get borne
  Future<http.Response> getBorne() async {
    final token = box.read('token');
    try {
      final response = await http.post(
        getUrl('auth/refresh'),
        headers: headersToken(token),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

//Recuperer tous les slides
  Future<http.Response> getAllSlides() async {
    final token = box.read('token');
    try {
      final response = await http.get(
        getUrl('get_all_slide_borne'),
        headers: headersToken(token),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Recuperer tous les articles
  Future<http.Response> getAllArticles() async {
    final token = box.read('token');
    try {
      final response = await http.get(
        getUrl('get_all_article_borne'),
        headers: headersToken(token),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Recuperer tous les articles
  Future<http.Response> getAllAlertes() async {
    final token = box.read('token');
    try {
      final response = await http.get(getUrl('get_all_alertes_borne'),
          headers: headersToken(token));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // update direction
  Future<http.Response> getSite() async {
    return await http
        .get(getUrl('update-direction'),
            headers: headersToken(box.read('token')))
        .timeout(const Duration(seconds: 15), onTimeout: () {
      return http.Response("Erreur de connexion", 400);
    });
  }

  //Send fire base token to the server
  Future<http.Response> sendToken(
      {required String code, required String fbToken}) async {
    try {
      return await http.post(
        getUrl('store_token'),
        body: jsonEncode({"code": code, "fb_token": fbToken}),
        headers: headersToken(box.read('token')),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> getAllTicket(int siteId) async {
    try {
      http.Response response =
          await http.get(getQueingUrl("site/$siteId/tickets"));
      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  //Desactiver une alerte de la borne
  Future<http.Response> enableArticle({required int idArticle}) async {
    try {
      return await http.post(
        getUrl('update-article'),
        headers: headersToken(box.read("token")),
        body: jsonEncode({"id": idArticle}),
      );
    } catch (e) {
      rethrow;
    }
  }
}
