import 'package:borne_flutter/controllers/AllControllerBinding.dart';
import 'package:borne_flutter/controllers/ListenController.dart';
import 'package:borne_flutter/firebase_options.dart';
import 'package:borne_flutter/views/home_page_loading.dart';
import 'package:borne_flutter/views/login.dart';
import 'package:borne_flutter/views/view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:timezone/data/latest.dart' as tz;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("event   $message");
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  /////// this line is wrong /////////////
  ///
}

void main() async {
/*   final borneController = Get.put(BorneController()); */
  await GetStorage.init();
  final box = GetStorage();
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
    ),
  );
  /* SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual); */
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

/*   SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]); */
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /*  FirebaseAnalytics analytics = FirebaseAnalytics.instance; */

  await FirebaseMessaging.instance.getToken().then((value) async {
    await box.write('fcmToken', value);
  });
  FirebaseMessaging.onBackgroundMessage((_firebaseMessagingBackgroundHandler));
  //Enregistrement du tocken Firebase vers la base de donnée par l'Api
  // borneController.sendToken(token: fmcToken!);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final box = GetStorage();
  final listenController = Get.put(ListenController());
  String token = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _receiveMessageFirebase();
    _checkToken();
  }

  Future<void> _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
    });
  }

  //Firebase Message configure
  Future<void> _receiveMessageFirebase() async {
    FirebaseMessaging.onMessage.listen((event) {
      if (event.notification == null) return;
      print('EVENTBD : ${event.data['event']}');

      switch (event.data['event']) {
        //Alerte Mise a jour
        case 'CHANGE_STATUT_ALERT':
          listenController.changeStatutAlerte();
          break;
        case 'UPDATE_ALERT':
          listenController.updateAlerte();
          break;
        case 'DELETE_ALERT':
          listenController.deleteAlerte();
          break;
        case 'STORE_ALERT':
          listenController.storeAlerte();
          break;
        //Articles mise a jour
        case 'STORE_ARTICLE':
          listenController.addNewArticle();
          break;
        case 'UPDATE_ARTICLE':
          listenController.updateArticle();
          break;
        case 'DELETE_ARTICLE':
          listenController.deleteArticle();
          break;
        case 'CHANGE_STATUT_ARTICLE':
          listenController.updateArticle();
          break;
        //Slide mise a jour
        case 'STORE_SLIDE':
          listenController.addSlide();
          break;
        case 'DELETE_SLIDE':
          listenController.deleteSlide();
          break;
        case 'UPDATE_SLIDE':
          listenController.updateSlide();
          break;
        case 'CHANGE_STATUT_SLIDE':
          listenController.updateSlide();
          break;
        default:
      }
    });
    //Ecouter l'app quand c'est en background
    /* FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage); */
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AllControllerBinding(),
      title: 'Borne App TINITZ',
      // home: Login(),
      //home: const HomePageLoading(),
      // ignore: unnecessary_null_comparison
      home: token.isNotEmpty ? const HomePage() : Login(),
      getPages: [
        GetPage(
          name: '/login',
          page: () => Login(),
        ),
        GetPage(
          name: '/home',
          page: () => const Home(),
        ),
        GetPage(
          name: '/homePage',
          page: () => const HomePage(),
        ),
      ],
    );
  }
}
