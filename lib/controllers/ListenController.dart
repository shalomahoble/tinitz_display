import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:borne_flutter/controllers/BorneController.dart';
import 'package:borne_flutter/controllers/LoginController.dart';
import 'package:borne_flutter/models/Alerte.dart';
import 'package:borne_flutter/models/Artcile.dart';
import 'package:borne_flutter/models/Borne.dart';
import 'package:borne_flutter/models/Slide.dart';
import 'package:borne_flutter/services/BorneService.dart';
import 'package:borne_flutter/services/LoginService.dart';
import 'package:borne_flutter/utils/utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ListenController extends GetxController {
  final LoginController loginController = Get.put(LoginController());
  BorneController? _borneController; // Utilisez le type BorneController?
  final borneService = Get.put(BorneService()); // Utilisez le type

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
    log(response.body);
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
  Future<void> updateAlerte() async {
    final response = await borneService.getAllAlertes();
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body)['alertes'];
      final alerts = body.map<Alert>((el) => Alert.fromJson(el)).toList();
      borneController.addOrUpdateAlert(alerts);
    }
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

  Future<void> addNewArticle() async {
    final response = await borneService.getAllArticles();

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body)['articles'];
      final articles = body.map<Article>((el) => Article.fromJson(el)).toList();
      borneController.addOrUpdateArticle(articles);
    }

    // getBorne().then((borne) {
    //   if (borne != null) {
    //     borneController.addOrUpdateArticle(borne.articles!);
    //   }
    // });
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
      if (borne != null) {
        borneController.addOrUpdateSlide(borne.slides!);
      }
    });
  }

  //###### ajouter un Slide
  Future<void> addSlide() async {
    final response = await borneService.getAllSlides();
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body)['slides'];
      final slides = body.map<Slide>((el) => Slide.fromJson(el)).toList();
      borneController.addOrUpdateSlide(slides);
    }
  }

  void deleteSlide() {
    getBorne().then((borne) {
      log("EVENTBD delete slide ${borne.toString()}");
      if (borne != null) {
        borneController.addOrUpdateSlide(borne.slides!);
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
        if (body['borne'] != null) {
          final token = body['access_token'];
          box.write('token', token);
          saveToken(token);
          log(token.toString());
        }
      }
    });
  }

  // ####################### Tickets #######################################
//Nouveau ticket
  Future<void> newTicket({required int id, required int nextId}) async {
    await borneController.newTicket(id: id, nextId: nextId);
  }

//Nouveau debut
  Future<void> firstTicket({required int id}) async {
    await borneController.firstTicket(id: id);
  }

  //suppression ticket
  Future<void> deleteTicket(int id, int nextId) async {
    borneController.deleteTicket(id, nextId);
  }

  //Appeller le suivant ou rappeller
  Future<void> callTicket(int id) async {
    borneController.callNextTicket(id);
  }

//Update all information for borne
  updateBorneInformationPeriodique() {
    Timer.periodic(const Duration(minutes: 5), (timer) {
      borneController.updateAllInfoForBorne();
      log('mise a jour');
    });
  }

  //Listen to refresh firebase token
  void onTokenRefreshToken(String fcmToken) async {
    await borneController.sendToken(
        code: borneController.borne.value.code!, fbToken: fcmToken);
  }

  @override
  // ignore: unnecessary_overrides
  void onInit() {
    super.onInit();

    //Mise a jour du token chaque 1 min;
    // changeTokenApiPeriodic();

    //changer les information de la borne au bout de 5min
    // updateBorneInformationPeriodique();
  }
}
