import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:borne_flutter/components/v_1_components/ticketing_display.dart';
import 'package:borne_flutter/models/Alerte.dart';
import 'package:borne_flutter/models/Artcile.dart';
import 'package:borne_flutter/models/Borne.dart';
import 'package:borne_flutter/models/Direction.dart';
import 'package:borne_flutter/models/Site.dart';
import 'package:borne_flutter/models/ticket.dart';
import 'package:borne_flutter/services/BorneService.dart';
import 'package:borne_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/Slide.dart';

class BorneController extends GetxController with GetTickerProviderStateMixin {
  final _borneService = BorneService();

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
  final box = GetStorage();

  //Time variable
  late final tz.Location _location;
  String timeZone = '';
  RxString currentDate = ''.obs;
  RxString currentTime = ''.obs;
  String formattedDateTime = DateTime.now().toString();

  late AnimationController controller;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final Tween<Offset> offsetTween = Tween<Offset>(
    begin: const Offset(0.0, -4.0), // Position initiale (milieu)
    end: const Offset(0.0, -6.5), // Position finale (barre d'applications)
  );
  FlutterTts flutterTts = FlutterTts();

//Recuperer les information concernant une borne
  Future<void> getBorne() async {
    final response = await _borneService.getBorne();
    if (response.statusCode == 200) {
      log('je suis entre');
      final body = jsonDecode(response.body);
      final token = body['access_token'];
      box.write('token', token);
      saveToken(token);
      borne.value = Borne.fromJson(body['borne']);
      articles.value = borne.value.articles!;
      slides.value = borne.value.slides!;
      alertes.value = borne.value.alerts!;
      site.value = borne.value.site!;
      borneLoading.value = true;
      update();
      currentTimeForTimeZone(); // Get timeZone to dsiplay current date and time
      slideChange(0); //Get first slide duration to init slide
      //startTimerForNextArticle(); //Start animating articles
      // getAllTicketForBorne();
      startVisibleAnimation();
    } else if (response.statusCode == 400) {
      showMessageError(
        message: "Token invalide...",
      );
      Get.offAllNamed('login');
    } else {
      showMessageError(
        message: "Vérifier votre connexion internet ou rééssayer plus tard",
      );
      Get.offAllNamed('login');
    }

    /* _borneService
        .getBorne()
        .then((response) {})
        .timeout(const Duration(minutes: 1), onTimeout: () {
      showMessageError(
        message: 'Vérifier votre connexion internet ou rééssayer plus tard',
      );
      Get.offAllNamed('login');
    }); */
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
    log("rentre");
    if (articles.isNotEmpty) {
      Article currentArticle = articles[currentArticleIndex.value];

      if (shouldSkipPermanentArticle(currentArticle)) {
        skipToNextArticle();
        log("rentre skipToNextArticle ");
        articleChangeAnimation.value++;
        startTimerForNextArticle();
      } else {
        delayedTask = Timer(currentArticle.seconde(), () {
          handleDisplayedPermanentArticle(currentArticle);
          log("rentre goToNextArticle ");
          goToNextArticle();
          // Ajoutez cette ligne pour conserver l'effet de défilement
          articleChangeAnimation.value++;
          // startTimerForNextArticle();
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
      currentArticleduree.value =
          articles[currentArticleIndex.value].pivot.duree;
      update();
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
      await _borneService
          .sendToken(code: code, fbToken: fbToken)
          .then((response) => {log(response.body.toString())});
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
      articleEstVide.value = false; //Article n'est pas vide
      currentArticleIndex.value = 0; //On remet l'index a 0
      currentArticleduree.value = articles[currentArticleIndex.value]
          .pivot
          .duree; //Mettre a jour la durre
      articles.value = newListeArticle; //Affectation des nouvelles articles
      log("EVENTBD nouvelle article $articles");
      playDefaultRingtone(); //On emet un son
      //controller.reset(); //On reinitialise l'animation
      // startNewAnimation();
      startVisibleAnimation(); //On relance l'animation
      //delayedTask.cancel();
      //startTimerForNextArticle();
      update(); //On informe tout le monde
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
    final response = await _borneService.getBorne();
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      borne.value = Borne.fromJson(body['borne']);
      site.value = borne.value.site!;
      slides.value = borne.value.slides!;
      alertes.value = borne.value.alerts!;
      articles.value = borne.value.articles!;
    }
  }

  toDeconnecte() {
    removeToken().then((value) => Get.offAllNamed('login'));
  }

//cette fonction verifie si l'article precedent est permanent et le supprime de la liste
  void isPermanentArticle() {
    if (articles.isNotEmpty) {
      Article currentArticle = articles[currentArticleIndex.value];
      if (shouldSkipPermanentArticle(currentArticle)) {
        articles.removeAt(currentArticleIndex.value);
      } else if (currentArticle.pivot.permanent == 0) {
        permanentArticleIdsDisplayed.add(currentArticle.id);
        articles.removeAt(currentArticleIndex.value);
      }
      goToNextArticle();
    } else {
      articleEstVide.value = true;
      update();
    }
  }

  // function to start animation article
  void startNewAnimation() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )
      ..repeat(reverse: true)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(seconds: 1), () {
            if (articles.isEmpty) {
              controller.stop();
            } else {
              isPermanentArticle();
              controller.reverse(); // Réinitialise l'animation
            }
          });
        } else if (status == AnimationStatus.dismissed) {
          Future.delayed(Duration(seconds: currentArticleduree.value), () {
            controller.forward();
          });
        }
      });
    controller.forward();
  }

  // function to start animation article isVisible

  void startVisibleAnimation() {
    Timer.periodic(Duration(seconds: currentArticleduree.value), (timer) {
      if (articles.isNotEmpty) {
        Article currentArticle = articles[currentArticleIndex.value];
        if (shouldSkipPermanentArticle(currentArticle)) {
          skipToNextArticle();
          startVisibleAnimation();
        } else {
          handleDisplayedPermanentArticle(currentArticle);
          isCardVisible(!isCardVisible.value);
          if (isCardVisible.isTrue) {
            goToNextArticle();
            playDefaultRingtone();
          }
        }
      }
    });
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

//Iniatialisation du controlleur
  @override
  void onInit() {
    super.onInit();
    initializeDateFormatting('en_US');
    tz.initializeTimeZones();
    log("initialisation de la bornecontroller ");
    getBorne();
    // startNewAnimation();
  }

  @override
  void onClose() {
    super.onClose();
    controller.dispose();
  }
}
