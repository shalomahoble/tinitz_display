// ignore_for_file: file_names

import 'package:get/get.dart';

import '../models/Artcile.dart';

class ArticleController extends GetxController {
  final currentIndex = 0.obs;
  // final RxList<Article> articles = <Article>[].obs;
  RxInt changer = 1.obs;
  final elementChangeCount = 0.obs; // Compteur pour les changements d'élément
  List<Article> articlepermanent = List.empty();

  // ignore: unnecessary_overrides
  @override
  void onInit() {
    super.onInit();
  }

  void startTimerForNextArticle() {}
}
