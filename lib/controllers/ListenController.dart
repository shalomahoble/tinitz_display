import 'dart:async';
import 'dart:convert';
import 'dart:developer';

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
  //final borneService = Get.put(BorneService()); // Utilisez le type

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
  Future<void> changeStatutAlerte() async {
    await borneController.addOrUpdateAlert();
  }

//Update alerte
  Future<void> updateAlerte() async {
    await borneController.addOrUpdateAlert();
  }

  //Delete alerte
  Future<void> deleteAlerte() async {
    await borneController.addOrUpdateAlert();
  }

  //Add new alert
  Future<void> storeAlerte() async {
    await borneController.addOrUpdateAlert();
  }

  //###### Article  mise a jour ##########################################

  Future<void> updateArticle() async {
    await borneController.addOrUpdateArticle();
  }

  Future<void> addNewArticle() async {
    await borneController.addOrUpdateArticle();
  }

  Future<void> deleteArticle() async {
    await borneController.addOrUpdateArticle();
  }

// ####################### SLIDES #######################################
//Ajout d'un nouveau slide
  Future<void> updateSlide() async {
    await borneController.addOrUpdateSlide();
  }

  //###### ajouter un Slide ou mettre a jour le slide
  Future<void> addSlide() async {
    await borneController.addOrUpdateSlide();
  }

  Future<void> deleteSlide() async {
    await borneController.addOrUpdateSlide();
  }

  //Change parameters
  Future<void> changeParameters() async {
    final response = await loginService.generateNewToken();
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final setting = body['setting'];
      saveToken(body['access_token']);
      borneController.parameterChange(setting);
    }
  }

  //Update direction for borne
  Future<void> updateDirection() async {
    await borneController.updateSiteInfo();
  }

  Future<Borne?> getBorne() async {
    final response = await loginService.generateNewToken();
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return Borne.fromJson(body['borne']);
    } else {
      return null;
    }
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
  Future<void> updateBorneInformationPeriodique() async {
    Timer.periodic(const Duration(minutes: 10), (timer) {
      borneController.updateAllInfoForBorne();
    });
  }

  //Listen to refresh firebase token
  Future<void> onTokenRefreshToken(String fcmToken) async {
    await borneController.sendToken(
        code: borneController.borne.value.code!, fbToken: fcmToken);
  }

  @override
  // ignore: unnecessary_overrides
  void onInit() {
    super.onInit();
    updateBorneInformationPeriodique(); // update information periodique
  }
}
