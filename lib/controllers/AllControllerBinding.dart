import 'package:borne_flutter/controllers/BorneController.dart';
import 'package:borne_flutter/controllers/ListenController.dart';
import 'package:borne_flutter/controllers/LoginController.dart';
import 'package:get/get.dart';

class AllControllerBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<ListenController>(() => ListenController());
    Get.lazyPut<BorneController>(() => BorneController());
    /* Get.lazyPut<TimerController>(() => TimerController(timeZone: '')); */
  }
}
