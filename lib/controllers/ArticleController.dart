import 'package:get/get.dart';

import '../models/Artcile.dart';

class ArticleController extends GetxController {
  final currentIndex = 0.obs;
  // final RxList<Article> articles = <Article>[].obs;
  RxInt changer = 1.obs;
  final elementChangeCount = 0.obs; // Compteur pour les changements d'élément
  List<Article> articlepermanent = List.empty();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void startTimerForNextArticle() {}
}
