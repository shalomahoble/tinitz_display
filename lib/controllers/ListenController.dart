import 'dart:async';
import 'dart:convert';

import 'package:borne_flutter/controllers/LoginController.dart';
import 'package:borne_flutter/models/Alerte.dart';
import 'package:borne_flutter/models/Borne.dart';
import 'package:borne_flutter/services/LoginService.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Slide.dart';

class ListenController extends GetxController {
  final LoginController loginController = Get.put(LoginController());

  final LoginService loginService = Get.put(LoginService());

  final box = GetStorage();
  Borne borne = Borne();
  RxList<Alert> alertes = RxList<Alert>.empty(growable: true);
  RxList<Slide> slides = RxList<Slide>.empty(growable: true);

  void addNewAlerte() async {
    final response = await loginService.generateNewToken();
    print(response.body);
  }

//###### Alert mise a jour
//Change statut
  void changeStatutAlerte() async {
    getBorne().then((borne) {
      loginController.updateAlerte(borne.alerts!);
      /* if (borne.alerts != null && borne.alerts!.isNotEmpty) {
        /* print(borne.toString());
        loginController.borne.value.alerts!.clear();
        loginController.borne.value.alerts!.addAll(borne.alerts!); */
        loginController.updateBorneInfo(borne);
        loginController.changeAlerte.value++;
        loginController.verfieAlerteIsEmpty();
        update();
      } */
    });
  }

//Update alerte
  void updateAlerte() {
    getBorne().then((borne) {
      loginController.updateBorneInfo(borne);
      update();
    });
  }

  //Delete borne
  void deleteAlerte() {
    getBorne().then((borne) {
      loginController.updateBorneInfo(borne);
      update();
      /* if (borne.alerts != null) {
        /* loginController.borne.value.alerts!.clear();
        loginController.borne.value.alerts!.addAll(borne.alerts!); */
        loginController.updateBorneInfo(borne);
        loginController.changeAlerte.value++;
        loginController.verfieAlerteIsEmpty();
        update();
      } */
    });
  }

  //Add new alert
  void storeAlerte() {
    getBorne().then((borne) {
      loginController.updateBorneInfo(borne);
      update();
      /*   if (borne.alerts != null) {
        // loginController.borne.value.alerts!.clear();
        // loginController.borne.value.alerts!.addAll(borne.alerts!);
        loginController.updateBorneInfo(borne);
        loginController.changeAlerte++;
        loginController.verfieAlerteIsEmpty();
        update();
      } */
    });
  }

  //###### Article  mise a jour

  void updateArticle() {
    getBorne().then((borne) {
      if (borne.articles != null) {
        loginController.updateBorneInfo(borne);
        update();
      }
    });
  }

  void addNewArticle() {
    getBorne().then((borne) {
      loginController.updateBorneInfo(borne);
      update();
      /*   if (borne.articles != null) {
        loginController.addNewArticle(borne.articles!);
        update();
      } */
    });
  }

//Ajout d'un nouveau slide
  void updateSlide() {
    getBorne().then((borne) {
      print("nouvelle borne ${borne.slides}");
      loginController.updateBorneInfo(borne);
      update();
    });
  }

  //###### Slide  mise a jour
  void addSlide() {
    getBorne().then((borne) {
      print("nouvelle borne ${borne.slides}");
      loginController.updateBorneInfo(borne);
    });
  }

  void deleteSlide() {
    getBorne().then((borne) {
      print("nouvelle 1 ${borne.slides}");
      loginController.updateBorneInfo(borne);
    });
  }

  Future<Borne> getBorne() async {
    final response = await loginService.generateNewToken();
    final body = jsonDecode(response.body);
    /* print("EVENTBD ${body['borne']['articles'].toString()}"); */
    final token = body['access_token'];
    saveToken(token);
    await box.write('token', token);
    return Borne.fromJson(body['borne']);
  }

  Future<void> saveToken(String? token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (token != null && token.isNotEmpty) {
      await prefs.setString('token', token);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

//Mise a jour du token chaque 1 min;

    Timer.periodic(const Duration(seconds: 45), (timer) async {
      final response = await loginService.generateNewToken();
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final token = body['access_token'];
        saveToken(token);
        await box.write('token', token);
        if (body['borne'] != null) {
          loginController.updateBorneInfo(Borne.fromJson(body['borne']));
          /* loginController.delayedTask.cancel(); */
          /*  loginController.getUrl(); */
          /* loginController.startTimerForNextArticle(); */
          update();
        }
      }
    });
  }
}
