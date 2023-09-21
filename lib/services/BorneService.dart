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
    /*  final token = box.read('token'); */
    final token = await getToken();
    try {
      final http.Response response = await http.post(
        getUrl('auth/refresh'),
        headers: headersToken(token),
      );
      return response;
    } catch (e) {
      showMessageError(message: e.toString());
      //Get.offAllNamed('login');
      rethrow;
    }
  }

  //Send fire base token to the server
  Future<http.Response> sendToken(
      {required String code, required String fbToken}) async {
    final box = GetStorage();
    final tokenApi = await box.read('token');

    try {
      http.Response response = await http.post(
        getUrl('store_token'),
        body: jsonEncode({"code": code, "fb_token": fbToken}),
        headers: headersToken(tokenApi),
      );
      log(response.body.toString());
      return response;
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
}
