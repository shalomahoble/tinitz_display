import 'package:borne_flutter/controllers/BorneController.dart';
import 'package:borne_flutter/controllers/ListenController.dart';
import 'package:borne_flutter/controllers/LoginController.dart';
import 'package:borne_flutter/services/LoginService.dart';
import 'package:get/get.dart';

class AllControllerBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<LoginService>(() => LoginService());
    Get.lazyPut<BorneController>(() => BorneController());
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<ListenController>(() => ListenController());
    /* Get.lazyPut<TimerController>(() => TimerController(timeZone: '')); */
  }
}
