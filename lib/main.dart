import 'dart:developer';

import 'package:borne_flutter/config/app_style.dart';
import 'package:borne_flutter/controllers/AllControllerBinding.dart';
import 'package:borne_flutter/controllers/EventController.dart';
import 'package:borne_flutter/controllers/ListenController.dart';
import 'package:borne_flutter/firebase_options.dart';
import 'package:borne_flutter/views/login.dart';
import 'package:borne_flutter/views/view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:timezone/data/latest.dart' as tz;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  /////// this line is wrong /////////////
  ///
}

void main() async {
/*   final borneController = Get.put(BorneController()); */
  await GetStorage.init();
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
  FirebaseMessaging.onBackgroundMessage((_firebaseMessagingBackgroundHandler));
  //Enregistrement du tocken Firebase vers la base de donnée par l'Api
  // borneController.sendToken(token: fmcToken!);

  //Pour être averti chaque fois que le jeton est mis à jour,
  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    final listencontroller = Get.put(ListenController());
    listencontroller.onTokenRefreshToken(fcmToken);
  }).onError((error) => log(error.toString()));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final box = GetStorage();
  final eventController = Get.put(EventController());

  @override
  void initState() {
    super.initState();
    eventController.receiveMessageFirebase();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AllControllerBinding(),
      title: 'Borne App TINITZ',
      // home: const OffLineWidget(),
      home: box.hasData('token') ? const HomePage() : Login(),
      getPages: [
        GetPage(name: '/login', page: () => Login()),
        GetPage(name: '/home', page: () => const Home()),
        GetPage(name: '/homePage', page: () => const HomePage()),
      ],
    );
  }
}

class LoadView extends StatelessWidget {
  const LoadView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoadingAnimationWidget.threeArchedCircle(
          color: KOrange,
          size: 40,
        ),
      ),
    );
  }
}
