import 'dart:async';
import 'dart:convert';

import 'package:borne_flutter/controllers/BorneController.dart';
import 'package:borne_flutter/controllers/LoginController.dart';
import 'package:borne_flutter/models/Borne.dart';
import 'package:borne_flutter/services/LoginService.dart';
import 'package:borne_flutter/utils/utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ListenController extends GetxController {
  final LoginController loginController = Get.put(LoginController());
  BorneController? _borneController; // Utilisez le type BorneController?

  final LoginService loginService = Get.put(LoginService());

  final box = GetStorage();
  Borne borne = Borne();

  // Méthode pour obtenir le BorneController seulement lorsque vous en avez besoin
  BorneController get borneController {
    _borneController ??= Get.find<BorneController>();
    return _borneController!;
  }

  void addNewAlerte() async {
    final response = await loginService.generateNewToken();
    print(response.body);
  }

//###### Alert mise a jour ################################################
//Change statut
  void changeStatutAlerte() async {
    getBorne().then((borne) {
      if (borne != null) {
        borneController.addOrUpdateAlert(borne.alerts!);
      }
    });
  }

//Update alerte
  void updateAlerte() {
    getBorne().then((borne) {
      if (borne != null) {
        borneController.addOrUpdateAlert(borne.alerts!);
      }
    });
  }

  //Delete alerte
  void deleteAlerte() {
    getBorne().then((borne) {
      if (borne != null) {
        borneController.addOrUpdateAlert(borne.alerts!);
      }
      /*  loginController.updateBorneInfo(borne); */
    });
  }

  //Add new alert
  void storeAlerte() {
    getBorne().then((borne) {
      if (borne != null) {
        borneController.addOrUpdateAlert(borne.alerts!);
      }
      /*   loginController.updateBorneInfo(borne);
      update(); */
    });
  }

  //###### Article  mise a jour ##########################################

  void updateArticle() {
    getBorne().then((borne) {
      if (borne != null) {
        borneController.addOrUpdateArticle(borne.articles!);
      }
    });
  }

  void addNewArticle() {
    getBorne().then((borne) {
      if (borne != null) {
        borneController.addOrUpdateArticle(borne.articles!);
      }
      /* loginController.updateBorneInfo(borne); */
    });
  }

  void deleteArticle() {
    getBorne().then((borne) {
      if (borne != null) {
        borneController.addOrUpdateArticle(borne.articles!);
      }
    });
  }

// ####################### SLIDES #######################################
//Ajout d'un nouveau slide
  void updateSlide() {
    getBorne().then((borne) {
      print("EVENTBD update slide ${borne.toString()}");
      if (borne != null) {
        borneController.addOrUpdateSlide(borne.slides!);
      }
    });
  }

  //###### Slide  mise a jour
  void addSlide() {
    getBorne().then((borne) {
      if (borne != null) {
        borneController.addOrUpdateArticle(borne.articles!);
      }
    });
  }

  void deleteSlide() {
    getBorne().then((borne) {
      print("EVENTBD delete slide ${borne.toString()}");
      if (borne != null) {
        borneController.addOrUpdateArticle(borne.articles!);
      }
    });
  }

  Future<Borne?> getBorne() async {
    final response = await loginService.generateNewToken();

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final token = body['access_token'];
      saveToken(token);
      await box.write('token', token);
      return Borne.fromJson(body['borne']);
    } else {
      print("EVENTBD ${response.body.toString()}");
      return null;
    }
  }

  Future<void> changeTokenApiPeriodic() async {
    Timer.periodic(const Duration(minutes: 1), (timer) async {
      final response = await loginService.generateNewToken();
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final token = body['access_token'];
        saveToken(token);
        await box.write('token', token);
        print("EVENTBD listen 1 $token");
        if (body['borne'] != null) {
          borneController.updateBorneInfo(Borne.fromJson(body['borne']));
          /*  loginController.updateBorneInfo(Borne.fromJson(body['borne'])); */
        }
      }
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    //Mise a jour du token chaque 1 min;
    //changeTokenApiPeriodic();
  }
}
