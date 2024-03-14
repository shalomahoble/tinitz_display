import 'dart:developer';

import 'package:borne_flutter/controllers/ListenController.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class EventController extends GetxController {
  final listenController = Get.put(ListenController());

  //Firebase Message configure
  Future<void> receiveMessageFirebase() async {
    FirebaseMessaging.onMessage.listen((event) {
      if (event.notification == null) return;
      log('EVENTBD : ${event.data}');
      final data = event.data;

      switch (event.data['event']) {
        //Alerte Mise a jour
        case 'CHANGE_STATUT_ALERT':
          listenController.updateAlerte();
          break;
        case 'UPDATE_ALERT':
          listenController.updateAlerte();
          break;
        case 'DELETE_ALERT':
          listenController.updateAlerte();
          break;
        case 'STORE_ALERT':
          listenController.updateAlerte();
          break;
        //Articles mise a jour
        case 'STORE_ARTICLE':
          listenController.addNewArticle();
          break;
        case 'UPDATE_ARTICLE':
          listenController.addNewArticle();
          break;
        case 'DELETE_ARTICLE':
          listenController.addNewArticle();
          break;
        case 'CHANGE_STATUT_ARTICLE':
          listenController.addNewArticle();
          break;
        //Slide mise a jour
        case 'STORE_SLIDE':
          listenController.addSlide();
          break;
        case 'DELETE_SLIDE':
          listenController.addSlide();
          break;
        case 'UPDATE_SLIDE':
          listenController.addSlide();
          break;
        case 'CHANGE_STATUT_SLIDE':
          listenController.addSlide();
          break;
        case 'CHANGE_SETTING':
          listenController.changeParameters();
          break;

        //Slide mise a jour


//#########################---Ticket -----##################################################
        case "NEXT TICKET":
          final id = int.parse(data['current_id']);
          final nextId = int.parse(data['next_id']);
          listenController.newTicket(id: id, nextId: nextId);
          break;
        case "DEBUT TICKET":
          final id = int.parse(data['id']);
          listenController.firstTicket(id: id);
          break;
        case "RAPPEL TICKET":
          final id = int.parse(data['current_id']);
          listenController.callTicket(id);
          break;

        default:
      }
    });
  }
}
