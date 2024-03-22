import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:borne_flutter/components/v_1_components/ticketing_display.dart';
import 'package:borne_flutter/models/Alerte.dart';
import 'package:borne_flutter/models/Artcile.dart';
import 'package:borne_flutter/models/Borne.dart';
import 'package:borne_flutter/models/Direction.dart';
import 'package:borne_flutter/models/Site.dart';
import 'package:borne_flutter/models/setting.dart';
import 'package:borne_flutter/models/ticket.dart';
import 'package:borne_flutter/services/BorneService.dart';
import 'package:borne_flutter/utils/utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/Slide.dart';

class BorneController extends GetxController with GetTickerProviderStateMixin {
  final _borneService = Get.find<BorneService>();

  RxBool borneLoading = false.obs;
  Rx<Borne> borne = Borne().obs;
  RxInt dureeDuSlide = 5.obs;
  RxInt currentArticleIndex = 0.obs;
  RxInt currentArticleduree = 10.obs;
  RxInt articleChangeAnimation = 0.obs;
  // Initialisez en dehors de la fonction
  Set<int> permanentArticleIdsDisplayed = {};
  RxBool articleEstVide = false.obs;
  Timer delayedTask = Timer(Duration.zero, () {});
  RxBool isCardVisible = true.obs;
  Rx<Site> site = Site(
    id: 0,
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
  RxList<Ticket> tickets = <Ticket>[].obs;
  Rx<Setting> setting = Setting.nothing().obs;
  final box = GetStorage();
  Rx<Timer> videoTimer = Timer(Duration.zero, () {}).obs;
  Rx<Timer> videoTimerSecond = Timer(Duration.zero, () {}).obs;

  //Time variable
  tz.Location _location = tz.getLocation('Africa/Abidjan');
  String timeZone = '';
  RxString currentDate = ''.obs;
  RxString currentTime = ''.obs;
  String formattedDateTime = DateTime.now().toString();

  late AnimationController controller;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  FlutterTts flutterTts = FlutterTts();
  final _isOnline = false.obs;
  bool get isOnline => _isOnline.value;

//Recuperer les information concernant une borne
  Future<void> getBorne() async {
    try {
      final response = await _borneService.getBorne();
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        borne.value = Borne.fromJson(body['borne']);
        setting.value = Setting.fromJson(body['setting']);
        articles.value = borne.value.articles!;
        slides.value = borne.value.slides!;
        alertes.value = borne.value.alerts!;
        site.value = borne.value.site!;
        borneLoading.value = true;
        update();
        currentTimeForTimeZone(); // Get timeZone to dsiplay current date and time
        slideChange(0); //Get first slide duration to init slide

        Future.wait([
          saveFirebaseToken(), // save firebase token
          getAllTicketForBorne(), // get all ticket for borne
        ]);
      } else if (response.statusCode == 401) {
        showMessageError(
          message: "Token invalide... ${response.body.toString()}",
          duration: const Duration(seconds: 6),
        );
        Get.offAllNamed('login');
      } else if (response.statusCode == 400) {
        showMessageError(
          message: response.body.toString(),
          color: Colors.orangeAccent,
          duration: const Duration(seconds: 5),
        );
        Get.offAllNamed('login');
      } else {
        showMessageError(
          message: "Une erreur s'est produite",
          color: Colors.orangeAccent,
          duration: const Duration(seconds: 5),
        );
        Get.offAllNamed('login');
      }
    } catch (e) {
      rethrow;
    }
  }

  listenApp() async {
    Connectivity().onConnectivityChanged.listen(_connectivityListener);
  }

  _connectivityListener(ConnectivityResult result) async {
    _isOnline.value = false;
    if (result != ConnectivityResult.none) {
      _isOnline.value = await InternetConnectionChecker().hasConnection;
      _isOnline.refresh();
      if (_isOnline.isTrue) {
        getBorne();
      }
    }
  }

  // ALerts function
  //######## Alert Text
  String getAlerteText() {
    if (alertes.isNotEmpty) {
      List<String> splittedAlert;
      String finalAlertMessage = "";

      // return alertes
      //     .where((el) => el.typealert.libelle.toLowerCase() == 'text')
      //     .map((e) => e.libelle)
      //     .toList()
      //     .join("|");

      splittedAlert = alertes
          .where((el) => el.typealert.libelle.toLowerCase() == 'text')
          .where((el) => el.libelle != null && el.libelle != '')
          .map((e) => e.libelle)
          .whereType<String>()
          .toList();

      final screenWidth = MediaQuery.sizeOf(Get.context!).width;
      final spaceBetweenText = screenWidth < 600
          ? 20
          : 600 >= screenWidth && screenWidth < 875
              ? 50
              : 100;
      for (String alerte in splittedAlert) {
        finalAlertMessage += alerte + (" " * spaceBetweenText);
      }

      return finalAlertMessage;
    } else {
      return '';
    }
  }

  //######## Alert video
  List<Alert> getAlerteVideo() {
    if (alertes.isNotEmpty) {
      return alertes
          .where((el) => el.typealert.libelle.toLowerCase() == 'video')
          .where((el) => el.fileUrl != null && el.fileUrl != '')
          .toList();
    } else {
      return List.empty();
    }
  }

  //##################################### SLIDE FUNCTION ###############################

//Get current slide and update duration for current slide
//Update duration for current slide
  void slideChange(int index) {
    if (slides.isNotEmpty && index < slides.length) {
      dureeDuSlide.value = slides[index].duree;
      update();
    }
  }

  //##################################### Article FUNCTION ###############################

//Cette fonction passe à l'article suivant et met à jour l'index.
  void goToNextArticle() {
    if (articles.isNotEmpty) {
      currentArticleIndex.value =
          (currentArticleIndex.value + 1) % articles.length;
      currentArticleduree.value =
          articles[currentArticleIndex.value].pivot.duree;
      isCardVisible(true);
      startToAnimateArticle(); // start to animate next article
      playDefaultRingtone(); // play default ringtone
      update();
    }
    /* changeArticle.value++;
    update(); */
  }

// ################################ TIME ################################
  //Time function
  void currentTimeForTimeZone() {
    log("time zone 1 ${site.value.timezone!}");
    // ignore: unnecessary_null_comparison
    if (borne.value != null && site != null && site.value.timezone != null) {
      _location = tz.getLocation(site.value.timezone!);
      log("time zone 2 ${site.value.timezone!}");
      Timer.periodic(const Duration(seconds: 1), (timer) {
        tz.TZDateTime date = tz.TZDateTime.now(_location);
        currentDate.value = DateFormat('EEE d MMM  y', 'fr_Fr').format(date);
        currentTime.value = DateFormat('HH:mm', 'fr_Fr').format(date);
        currentDate.value =
            '${currentDate.value[0].toUpperCase() + currentDate.value.substring(1)} ${currentTime.value}';
      });
    } else {
      currentDate.value = DateTime.now().toString();
    }
  }

  //Send fire base to server
  Future<void> sendToken({
    required String code,
    required String fbToken,
  }) async {
    try {
      await _borneService.sendToken(code: code, fbToken: fbToken);
    } catch (e) {
      rethrow;
    }
  }

  //#################################### Listen to add, update, delete borne info ####################################

  //Add new or update or delete slide
  Future<void> addOrUpdateSlide() async {
    final response = await _borneService.getAllSlides();
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body)['slides'];
      final slide = body.map<Slide>((el) => Slide.fromJson(el)).toList();
      slides.assignAll(slide);
      update();
    }
  }

  //Add new or update or delete alerte (text or video)
  Future<void> addOrUpdateAlert() async {
    final response = await _borneService.getAllAlertes();
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body)['alertes'];
      final alerts = body.map<Alert>((el) => Alert.fromJson(el)).toList();
      alertes.assignAll(alerts);
      update();
    }
  }

  //parameters of borne change
  Future<void> parameterChange(dynamic newSetting) async {
    setting.value = Setting.fromJson(newSetting);
    update();
  }

  //################################################################################################

  //Add new or update or delete article
  Future<void> addOrUpdateArticle() async {
    final response = await _borneService.getAllArticles();
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body)['articles'];
      final article = body.map<Article>((el) => Article.fromJson(el)).toList();
      if (article.isEmpty) {
        articleEstVide.value = true;
        isCardVisible(true);
        playDefaultRingtone();
        videoTimer.value.cancel();
        update();
        Future.delayed(const Duration(seconds: 3), () {
          articles.clear();
          update();
        });
      } else {
        isCardVisible(true);
        articleEstVide.value = false; //Article n'est pas vide
        currentArticleIndex.value = 0; //On remet l'index a 0
        articles.assignAll(article);
        currentArticleduree.value =
            articles[0].pivot.duree; //Mettre a jour la durre
        update(); //On informe tout le monde
      }
    }
  }

  //Add new or update or borne info
  void updateBorneInfo(Borne newBorne) {
    borne.value = newBorne;
    site.value = newBorne.site!;
    update();
  }

  //Get direction info update
  Future<void> updateSiteInfo() async {
    final response = await _borneService.getSite();
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body)['site'];
      site.value = Site.fromJson(body);
      update();
    }
  }

//Emmettre un son
  void playDefaultRingtone() {
    FlutterRingtonePlayer.playNotification();
  }

  //Mettre a jour tout la borne apres un delais de 12H
  Future<void> updateAllInfoForBorne() async {
    final response = await _borneService.getBorne();
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      borne.value = Borne.fromJson(body['borne']);
      site.value = borne.value.site!;
      slides.value = borne.value.slides!;
      alertes.value = borne.value.alerts!;
      articles.value = borne.value.articles!;
      update();
    } else {
      log("error de login avec le token");
    }
  }

  // function to start animation article isVisible
  void startVisibleAnimation() {
    log('secondes des articles precedent ${currentArticleduree.value}');
    videoTimer.value =
        Timer.periodic(Duration(seconds: currentArticleduree.value), (timer) {
      isCardVisible(false);
      log("suivant premiere fois ${currentArticleIndex.value.toString()} ${isCardVisible.value.toString()}");

      if (articles.isNotEmpty) {
        //Affichage de l'article si les articles ne sont pas vides ...

        // Article currentArticle = articles[currentArticleIndex.value];

        videoTimerSecond.value = Timer(const Duration(seconds: 10), () {
          goToNextArticle();
        });
      } else {
        videoTimer.value.cancel();
        videoTimerSecond.value.cancel();
      }
    });
  }

  //Mettre a jour un article permanent
  Future<void> enableArticlePermanent(Article article) async {
    if (article.pivot.permanent == 0) {
      final response = await _borneService.enableArticle(idArticle: article.id);
      if (response.statusCode == 200) {
        final newArticles = jsonDecode(response.body)['articles']
            .map<Article>((art) => Article.fromJson(art))
            .toList();
        articles.assignAll(newArticles);
        currentArticleIndex.value =
            (currentArticleIndex.value + 1) % articles.length;
        update();
      }
    }
  }

  // Other function tu run article
  void startToAnimateArticle() {
    videoTimer.value = Timer(Duration(seconds: currentArticleduree.value), () {
      isCardVisible(false);

      // Supprimer l''article de la liste s'il est permanent
      enableArticlePermanent(articles[currentArticleIndex.value]);
      Timer(const Duration(seconds: 5), () {
        goToNextArticle(); // go next article
      });
    });
  }

  ///Save firebase token
  Future<void> saveFirebaseToken() async {
    final firebaseToken = await FirebaseMessaging.instance.getToken();
    if (firebaseToken != null) {
      _borneService.sendToken(code: "code", fbToken: firebaseToken);
    }
  }

  //#################################### Listen to add, update, delete borne info ####################################

  Future<void> getAllTicketForBorne() async {
    final response = await _borneService.getAllTicket(borne.value.site!.id);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      tickets.value =
          body["clients"].map<Ticket>((tick) => Ticket.fromJson(tick)).toList();
      update();
    } else {
      log("Erreur c'est produite pour les tickets");
    }
  }

  //New ticket
  Future<void> newTicket({required int id, required int nextId}) async {
    final response = await _borneService.getAllTicket(borne.value.site!.id);

    if (tickets.isNotEmpty && isPresent(id)) {
      //Recuperer l'index du ticket
      final index = tickets.indexWhere((el) => el.id == id);
      //Suppression dans la liste a un index
      final removeItem = tickets.removeAt(index);
      listKey.currentState?.removeItem(
          index,
          (context, animation) => TicketingDisplay(
                ticket: removeItem,
                animation: animation,
              ),
          duration: const Duration(microseconds: 300));
      update();
    }

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final newTicket = body["clients"]
          .map<Ticket>((tick) => Ticket.fromJson(tick))
          .toList() as List<Ticket>;
      if (newTicket.isNotEmpty && nextId != 0) {
        final tickect = newTicket.where((el) => el.id == nextId).toList().first;
        if (!isPresent(tickect.id)) {
          tickets.add(tickect);
          listKey.currentState?.insertItem(
            0,
            duration: const Duration(milliseconds: 300),
          );
          callTicket(tickect);
        }
        update();
      }
    } else {
      log(response.body.toString());
    }
  }

  void callTicket(Ticket ticket) {
    final text =
        "le Ticket ${ticket.numClient} est attendu a la ${ticket.caisse.libelle}";
    speak(text);
  }

  //delete ticket
  void deleteTicket(int id, int nextId) {
    if (tickets.isNotEmpty && isPresent(id)) {
      //Recuperer l'index du ticket
      final index = tickets.indexWhere((el) => el.id == id);
      //Suppression dans la liste a un index
      final removeItem = tickets.removeAt(index);
      listKey.currentState!.removeItem(
          index,
          (context, animation) => TicketingDisplay(
                ticket: removeItem,
                animation: animation,
              ),
          duration: const Duration(seconds: 300));
      update();
      //Client suivant a appelle ticket
      callNextTicket(nextId);
    }
  }

  //Debut du ticket
  Future<void> firstTicket({required int id}) async {
    final response = await _borneService.getAllTicket(borne.value.site!.id);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final newTicket = body["clients"]
          .map<Ticket>((tick) => Ticket.fromJson(tick))
          .toList() as List<Ticket>;

      final tickect = newTicket.where((el) => el.id == id).toList().first;
      if (!isPresent(tickect.id)) {
        tickets.add(tickect);
        listKey.currentState?.insertItem(
          0,
          duration: const Duration(seconds: 3),
        );
        callTicket(tickect);
        update();
      }
    }
  }

  //Appeller le suivant ou rappeller
  void callNextTicket(int nextId) {
    if (tickets.isNotEmpty && isPresent(nextId)) {
      final nextTicket = tickets.where((el) => el.id == nextId).toList().first;
      final text =
          "le Ticket ${nextTicket.numClient} est attendu a la ${nextTicket.caisse.libelle}";
      speak(text);
    }
  }

  //Verifie si l'id est present dans ma liste d'article
  bool isPresent(int id) {
    return tickets.any((el) => el.id == id);
  }

  //Function to speak ...
  Future<void> speak(String text) async {
    await flutterTts.setLanguage("fr-FR"); // Choisissez la langue
    // Réglage de la hauteur de la voix (1.0 est la hauteur par défaut)
    await flutterTts.setPitch(1.0);
    // Réglage de la vitesse de la voix (1.0 est la vitesse par défaut)
    await flutterTts.setSpeechRate(.5);

    await flutterTts.speak(text); // Lecture du texte
  }

//Deconnexion de la borne

  void deconnexion() {
    borne.value = Borne();
    videoTimer.value.cancel();
    videoTimerSecond.value.cancel();
    articles.clear();
    update();
    Get.offAllNamed("login");
    removeToken();
  }

//Iniatialisation du controlleur
  @override
  void onInit() async {
    super.onInit();
    initializeDateFormatting('en_US');
    tz.initializeTimeZones();
    // await getBorne();

    ever(articles, (callback) {
      videoTimer.value.cancel();
      videoTimerSecond.value.cancel();
      if (articles.isNotEmpty) {
        currentArticleduree.value = articles.first.pivot.duree;
        startToAnimateArticle();
        log("l'article a ete modifier");
      }
    });
    //Listent App in connexion is operational
    listenApp();
  }

  @override
  void onClose() {
    super.onClose();
    controller.dispose();
    videoTimer.value.cancel();
    videoTimerSecond.value.cancel();
  }
}
