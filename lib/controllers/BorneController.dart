import 'dart:convert';
import 'dart:async';
import 'package:borne_flutter/models/Alerte.dart';
import 'package:borne_flutter/models/Artcile.dart';
import 'package:borne_flutter/models/Borne.dart';
import 'package:borne_flutter/models/Direction.dart';
import 'package:borne_flutter/models/Site.dart';
import 'package:borne_flutter/services/BorneService.dart';
import 'package:borne_flutter/utils/utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/Slide.dart';

class BorneController extends GetxController {
  final _borneService = BorneService();

  RxBool borneLoading = false.obs;
  Rx<Borne> borne = Borne().obs;
  RxInt dureeDuSlide = 5.obs;
  RxInt currentArticleIndex = 0.obs;
  RxInt articleChangeAnimation = 0.obs;
  Set<int> permanentArticleIdsDisplayed =
      {}; // Initialisez en dehors de la fonction
  RxBool articleEstVide = false.obs;
  Timer delayedTask = Timer(Duration.zero, () {});
  Rx<Site> site = Site(
    image: "",
    direction: Direction(
      libelle: 'libelle',
      adresse: 'adresse',
      image: 'image',
      statut: 0,
    ),
  ).obs;
  RxList<Article> articles = <Article>[].obs;
  RxList<Slide> slides = <Slide>[].obs;
  RxList<Alert> alertes = <Alert>[].obs;
  final box = GetStorage();

  //Time variable
  late final tz.Location _location;
  String timeZone = '';
  RxString currentDate = ''.obs;
  RxString currentTime = ''.obs;
  String formattedDateTime = DateTime.now().toString();

//Recuperer les information concernant une borne
  void getBorne() async {
    _borneService.getBorne().then((response) {
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final token = body['access_token'];
        box.write('token', body['access_token']);
        saveToken(body['access_token']);
        print("EVENTBD borne token $token");
        borne.value = Borne.fromJson(body['borne']);
        articles.value = borne.value.articles!;
        slides.value = borne.value.slides!;
        alertes.value = borne.value.alerts!;
        site.value = borne.value.site!;
        borneLoading.value = true;
        update();
        currentTimeForTimeZone(); // Get timeZone to dsiplay current date and time
        slideChange(0); //Get first slide duration to init slide
        startTimerForNextArticle(); //Start animating articles
      } else if (response.statusCode == 400) {
        showMessageError(
          message: "Token invalide...",
        );
        Get.offAllNamed('login');
      } else {
        showMessageError(
          message: "Une erreur c'est produite  ... Ou token invalide",
        );
        Get.toNamed('login');
      }
    }).timeout(const Duration(minutes: 1), onTimeout: () {
      showMessageError(
        message: 'Vérifier votre connexion internet ou rééssayer plus tard',
      );
      Get.toNamed('login');
    });
  }

  // ALerts function
  //######## Alert Text
  String getAlerteText() {
    if (alertes.isNotEmpty) {
      return alertes
          .where((el) => el.typealert.libelle.toLowerCase() == 'text')
          .map((e) => e.libelle)
          .toList()
          .join("  |  ");
    } else {
      return '';
    }
  }

  //######## Alert video
  List<Alert> getAlerteVideo() {
    if (alertes.isNotEmpty) {
      return alertes
          .where((el) => el.typealert.libelle.toLowerCase() == 'video')
          .toList();
    } else {
      return List.empty();
    }
  }

  //##################################### SLIDE FUNCTION ###############################

//Get current slide and update duration for current slide
  slideChange(int index) {
    if (slides.isNotEmpty) {
      dureeDuSlide.value = slides[index].duree;
      update();
    }
  }

  //##################################### Article FUNCTION ###############################

  //Article animation

  //supprimer les articles non permanent
  void startTimerForNextArticle() {
    print("rentre");
    if (articles.isNotEmpty) {
      Article currentArticle = articles[currentArticleIndex.value];

      if (shouldSkipPermanentArticle(currentArticle)) {
        skipToNextArticle();
        print("rentre skipToNextArticle ");
        articleChangeAnimation.value++;
        startTimerForNextArticle();
      } else {
        delayedTask = Timer(currentArticle.seconde(), () {
          handleDisplayedPermanentArticle(currentArticle);
          print("rentre goToNextArticle ");
          goToNextArticle();
          // Ajoutez cette ligne pour conserver l'effet de défilement
          articleChangeAnimation.value++;
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
    if (articles.isNotEmpty) {
      currentArticleIndex.value =
          (currentArticleIndex.value + 1) % articles.length;
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
    if (articles.isNotEmpty) {
      currentArticleIndex.value =
          (currentArticleIndex.value + 1) % articles.length;
    }
    /* changeArticle.value++;
    update(); */
  }

  //Time function
  currentTimeForTimeZone() {
    // ignore: unnecessary_null_comparison
    if (borne.value != null && site != null && site.value.timezone != null) {
      _location = tz.getLocation(site.value.timezone!);

      Timer.periodic(const Duration(seconds: 1), (timer) {
        tz.TZDateTime date = tz.TZDateTime.now(_location);
        currentDate.value = DateFormat('EEE, MMM d y', 'fr_Fr').format(date);
        currentTime.value = DateFormat('HH:mm', 'fr_Fr').format(date);
        currentDate.value = '${currentDate.value} ${currentTime.value}';
        /* print(currentDate.toString()); */
      });
    } else {
      currentDate.value = DateTime.now().toString();
    }
  }

  //Send fire base to server
  Future<void> sendToken(
      {required String code, required String fbToken}) async {
    try {
      _borneService
          .sendToken(code: code, fbToken: fbToken)
          .then((response) => {print(response.body.toString())});
    } catch (e) {
      rethrow;
    }
  }

  //#################################### Listen to add, update, delete borne info ####################################

  //Add new or update or delete slide
  void addOrUpdateSlide(List<Slide> newListeSlide) {
    slides.value = newListeSlide;
    update();
  }

  //Add new or update or delete alerte (text or video)
  void addOrUpdateAlert(List<Alert> newListeAlerte) {
    alertes.value = newListeAlerte;
    update();
  }

  //Add new or update or delete article
  void addOrUpdateArticle(List<Article> newListeArticle) {
    if (newListeArticle.isEmpty) {
      articleEstVide.value = true;
      playDefaultRingtone();
      update();
      Future.delayed(const Duration(seconds: 3), () {
        articles.clear();
        update();
      });
    } else {
      articles.value = newListeArticle;
      articleEstVide.value = false;
      print("EVENTBD nouvelle article $articles");
      playDefaultRingtone();
      delayedTask.cancel();
      startTimerForNextArticle();
      update();
    }
  }

  //Add new or update or borne info
  void updateBorneInfo(Borne newBorne) {
    borne.value = newBorne;
    site.value = newBorne.site!;
    update();
  }

//Emmettre un son
  void playDefaultRingtone() {
    FlutterRingtonePlayer.playNotification();
  }

  //Mettre a jour tout la borne apres un delais de 12H
  Future<void> updateAllInfoForBorne() async {
    Future.delayed(const Duration(hours: 12), () => getBorne());
  }

  toDeconnecte() {
    removeToken().then((value) => Get.offAllNamed('login'));
  }

//Iniatialisation du controlleur
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initializeDateFormatting('en_US');
    tz.initializeTimeZones();
    print("initialisation de la bornecontroller ");
    getBorne();

    //Function to update all information of borne after 12h hours
    /* updateAllInfoForBorne(); */
  }
}
