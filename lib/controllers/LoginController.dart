import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:borne_flutter/controllers/BorneController.dart';
import 'package:borne_flutter/models/Alerte.dart';
import 'package:borne_flutter/models/Borne.dart';
import 'package:borne_flutter/models/slide.dart';
import 'package:borne_flutter/services/LoginService.dart';
import 'package:borne_flutter/services/ShortUrlService.dart';
import 'package:borne_flutter/utils/utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Artcile.dart';

class LoginController extends GetxController {
  RxBool loading = false.obs;
  RxBool loadingView = false.obs;
  RxBool afficherAlert = false.obs;
  RxInt duree = 10.obs;
  RxBool alertIsEmpty = false.obs;
  RxBool articleIsEmpty = false.obs;
  RxInt currentIndex = 0.obs;
  RxInt changeArticle = 0.obs;
  RxInt changeAlerte = 0.obs;
  RxString shortUrl = ''.obs;

  final LoginService _loginService = LoginService();
  final ShortUrlService _shortUrlService = ShortUrlService();
  final borneController = BorneController();
  Timer delayedTask = Timer(Duration.zero, () {});

  final box = GetStorage();
  late String token = '';

  Rx<Borne> borne = Borne().obs;
  RxList<Alert> alertes = <Alert>[].obs;
  RxList<Slide> slides = RxList<Slide>.empty(growable: true);

  List<Article> articlePermanent = List.empty();
  Set<int> permanentArticleIdsDisplayed =
      {}; // Initialisez en dehors de la fonction

  void loginBorne({required String code, required String password}) async {
    loading(true);
    try {
      _loginService
          .loginBorne(code: code, password: password)
          .then((value) async {
        loading(false);
        final response = jsonDecode(value.body);
        if (value.statusCode == 200) {
          token = response['access_token'];
          //log("EVENTBD logincontroller $token");
          saveToken(token);
          box.write('token', token);

          final fbToken = await box.read('fcmToken');
         // update();
          borneController.sendToken(code: code, fbToken: fbToken);

          // borne.value = Borne.fromJson(response['borne']);
          // isAlerte(borne.value); Savoir si une alerte est video ou pas
          //verfieAlerteIsEmpty();  Savoir si une alerte est text ou pas

          // startTimerForNextArticle(); // Demarrer l'animation des articles

          Get.offAllNamed('homePage');
        } else {
          loading(false);
          showMessageError(message: jsonDecode(value.body)['message']);
        }
        /* Au bout de 1   min si aucune reponse du serveur notifie l'utilisateur */
      }).timeout(const Duration(minutes: 1), onTimeout: () {
        loading(false);
        showMessageError(message: "Verifier votre connexion internet");
      });
    } catch (e) {
      loading(false);
    }
  }

  // Exemple de transformation des données JSON en instances de `Alerte`
  void processAlertes(List jsonData) {
    final list = jsonData.map((item) => Alert.fromJson(item)).toList();
    alertes.value = list;
    // Vous pouvez maintenant utiliser `alertes` qui contient toutes les instances d'Alerte
  }

  void getUrl() async {
    final token = await getToken();
    const accessToken = '448a1d93fc7acf36a31c268ef9ddb393150fb428';
    final longUrl =
        "https://devmarket.egaz.shop/reading?q=${borne.value.code}&tk=$token";
    await _shortUrlService.shortenUrl(longUrl, accessToken).then((value) {
      shortUrl.value = value;
      update();
      log("Shortened ${shortUrl.value}");
    });
  }

  List<Slide> getSlide() {
    return slides;
  }

/*   isAlerte(Borne borne) {
    if (borne.alerts!.isNotEmpty) {
      if (borne.alerts != null && borne.alerts!.isNotEmpty) {
        final alert = borne.alerts!.firstWhere(
          (el) => el.typealert.libelle.toLowerCase() == 'video',
          orElse: () => Alert(
              libelle: 'Aucune alerte', nbreRandomVideo: 0, randomVideo: 0),
        );
        if (alert.typealert.libelle != null) {
          afficherAlert(true);
          update();
        }
      }
    }
  } */
  //Affiher une une alerte

  onChangeSlide(int slideDuree) {
    duree.value = slideDuree;
  }

//Verifier si un article existe
  bool verfieAlerteIsEmpty() {
    final alertText = borne.value.alerts!.where(
      (el) => el.typealert.libelle.toLowerCase() == 'text',
    );
    if (alertText.isEmpty) {
      alertIsEmpty(true);
    } else {
      alertIsEmpty(false);
    }

    update();

    return alertIsEmpty.value;
  }

  generateToken() async {
    final response = await _loginService.generateNewToken();
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      token = body['access_token'];
      await box.write('token', token);
    }
  }

  List<Alert> getVideoAlerts() {
    final now = DateTime.now();
    return borne.value.alerts!
        .where((item) =>
            item.typealert.libelle.toLowerCase() == 'video' &&
            (now.isAfter(item.debut!) || now.isAtSameMomentAs(item.debut!)) &&
            (now.isAtSameMomentAs(item.fin!) || now.isBefore(item.fin!)))
        .toList();
  }

  //Load view for slide
  void load() {
    Future.delayed(const Duration(seconds: 5), () {
      if (borne.value.slides != null && borne.value.slides!.isNotEmpty) {
        loadingView.value = true;
        update();
      } else {
        loadingView.value = true;
        update();
      }
    });
  }

  //----------------- Fonction pour les slides ---------------------\\

  addNewslide(dynamic slides) {
    borne.value.slides = slides;
    update();
  }

  updateSlide(dynamic slides) {
    if (slides.isEmpty) {
      borne.value.slides = List.empty();
      log("update vide de slide mise a jour");
      update();
    } else {
      borne.value.slides = List.empty();
      borne.value.slides = slides;
      update();
      log("update element de slide mise a jour");
    }
  }

//delete slide
  void deleteSlide(dynamic slides) {
    if (slides.isEmpty) {
      borne.value.slides = List.empty();
      log("suppression de slide mise a jour");
      update();
    } else {
      borne.value.slides = List.empty();
      borne.value.slides = slides;
      log("ajout de slide mise a jour");
      update();
    }
  }

  //Add new article

  void addNewArticle(List<Article> articles) {
    //borne.value.articles!.clear();
    borne.value.articles!.addAll(articles);
    verifyArticleIsEmpty();
    currentIndex.value = 0;
    changeArticle.value = 0;
    delayedTask.cancel();
    startTimerForNextArticle(); // Demarrer l'animation des articles
    update();
  }

  //update new article
  void updateArticle(List<Article> articles) {
    if (articles.isEmpty) {
      articleIsEmpty.value = true;
      delayedTask.cancel();
      update();
    } else {
      borne.value.articles!.clear();
      borne.value.articles!.addAll(articles);
      articleIsEmpty.value = false;
      currentIndex.value = 0;
      changeArticle.value = 0;
      delayedTask.cancel();
      startTimerForNextArticle(); // Demarrer l'animation des articles
      update();
    }
  }

  /*  void deleteArticle(List<Article> articles) {
    articleIsEmpty.value = false;
    currentIndex.value = 0;
    changeArticle.value = 0;
    delayedTask.cancel();
    startTimerForNextArticle(); // Demarrer l'animation des articles
    update();
  } */

  //update  alerte
  void updateAlerte(List<Alert> alerts) {
    borne.value.alerts!.clear();
    borne.value.alerts!.addAll(alerts);
    changeAlerte.value++;
    verifyArticleIsEmpty();
    verfieAlerteIsEmpty();
    update();
  }

//Mettre a jour tous les infos de la borne
  void updateBorneInfo(Borne borneUpdate) {
    borne.value = borneUpdate;
    verfieAlerteIsEmpty();
    verfieAlerteIsEmpty();
    update();
  }

  bool enableInfiniteScroll() {
    return borne.value.slides!.length == 1 ? false : true;
  }

  //Ajouter un nouveau slide
  /*  void addSlide(List<Slide> slides) {
    borne.value.slides!.clear();
    borne.value.slides!.addAll(slides as List<Slide>);
    update();
  } */

  //----------------- Fonction pour les articles ---------------------\\

  //fonction animation des articles
/*   void startTimerForNextArticle() {
    print("rentre");
    if (borne.value.articles!.isNotEmpty) {

      delayedTask =
          Timer(borne.value.articles![currentIndex.value].seconde(), () {
        currentIndex.value =
            (currentIndex.value + 1) % borne.value.articles!.length;
        changeArticle.value++;
        startTimerForNextArticle();
      });
    }
  } */

  //supprimer les articles non permanent
  void startTimerForNextArticle() {
    log("rentre");
    if (borne.value.articles!.isNotEmpty) {
      Article currentArticle = borne.value.articles![currentIndex.value];

      if (shouldSkipPermanentArticle(currentArticle)) {
        skipToNextArticle();
        log("rentre skipToNextArticle ");
        changeArticle.value++;
        startTimerForNextArticle();
      } else {
        delayedTask = Timer(currentArticle.seconde(), () {
          handleDisplayedPermanentArticle(currentArticle);
          log("rentre goToNextArticle ");
          goToNextArticle();
          // Ajoutez cette ligne pour conserver l'effet de défilement
          changeArticle.value++;
          startTimerForNextArticle();
        });
      }
    }
  }

//Cette fonction vérifie si l'article permanent a déjà été affiché.
  bool shouldSkipPermanentArticle(Article article) {
    return article.pivot.permanent == 0 &&
        permanentArticleIdsDisplayed.contains(article.id);
  }

//Cette fonction passe à l'article suivant si l'article actuel doit être sauté.
  void skipToNextArticle() {
    if (borne.value.articles!.isNotEmpty) {
      currentIndex.value =
          (currentIndex.value + 1) % borne.value.articles!.length;
    }
  }

//Cette fonction gère l'ajout de l'identifiant de l'article permanent affiché à l'ensemble.
  void handleDisplayedPermanentArticle(Article article) {
    if (article.pivot.permanent == 0) {
      permanentArticleIdsDisplayed.add(article.id);
    }
  }

//Cette fonction passe à l'article suivant et met à jour l'index.
  void goToNextArticle() {
    if (borne.value.articles!.isNotEmpty) {
      currentIndex.value =
          (currentIndex.value + 1) % borne.value.articles!.length;
    }
    /* changeArticle.value++;
    update(); */
  }

  List<Article> getArticle() {
    final now = DateTime.now();

    if (borne.value.articles != null && borne.value.articles!.isNotEmpty) {
      return borne.value.articles!
          .where((item) =>
              (now.isAfter(item.pivot.debut) ||
                  now.isAtSameMomentAs(item.pivot.debut)) &&
              now.isBefore(item.pivot.fin))
          .toList();
    } else {
      return []; // Ou une autre valeur par défaut si nécessaire
    }
  }

  bool verifyArticleIsEmpty() {
    if (borne.value.articles == null && borne.value.articles!.isEmpty) {
      articleIsEmpty.value = true;
      update();
    } else {
      articleIsEmpty.value = false;
      update();
    }
    return articleIsEmpty.value;
  }

  //----------------- Fonction pour les alerte video ---------------------\\

  String getAlertesText() {
    return borne.value.alerts!
        .where((el) => el.typealert.libelle.toLowerCase() == 'text')
        .map((e) => e.libelle)
        .toList()
        .join("  |  ");
  }

  // Token

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  //get borne info
  getBorneInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    if (token.isNotEmpty) {
      final response = await _loginService.generateNewToken();
      final body = jsonDecode(response.body);
      /* print("EVENTBD ${body['borne']['articles'].toString()}"); */
      final token = body['access_token'];
      await box.write('token', token);
      if (body['borne'] != null) {
        borne.value = Borne.fromJson(body['borne']);
      }
    }
  }


}

//Get.toNamed('home');
/*    alertes.value = borne.value.alerts!
              .where(
                  (item) => item.typealert!.libelle!.toLowerCase() == 'video')
              .toList();
          verfieAlertIsEmpty();
          final AlertVideoController alertVideoController =
              AlertVideoController(
            alert: alertes,
          ); */
