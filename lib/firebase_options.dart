// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBnAFnIdVZBGQk5bK1ZuMoRwWpcND6cjp4',
    appId: '1:570463753229:web:f1464387b312498233f144',
    messagingSenderId: '570463753229',
    projectId: 'tinitzapp',
    authDomain: 'tinitzapp.firebaseapp.com',
    storageBucket: 'tinitzapp.appspot.com',
    measurementId: 'G-BM17DP1X9L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCUOO89wQz7vUzkVaEm7vOfwXo5hERlk6k',
    appId: '1:570463753229:android:3c65aafbf0d812da33f144',
    messagingSenderId: '570463753229',
    projectId: 'tinitzapp',
    storageBucket: 'tinitzapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBctug91ATIy8-5EqNj1cBKREXayXC8MbE',
    appId: '1:570463753229:ios:1ad05d63f9d40d4433f144',
    messagingSenderId: '570463753229',
    projectId: 'tinitzapp',
    storageBucket: 'tinitzapp.appspot.com',
    iosClientId: '570463753229-61vvlpgak429f03qgojb38oquibvpp0d.apps.googleusercontent.com',
    iosBundleId: 'com.example.borneFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBctug91ATIy8-5EqNj1cBKREXayXC8MbE',
    appId: '1:570463753229:ios:1ad05d63f9d40d4433f144',
    messagingSenderId: '570463753229',
    projectId: 'tinitzapp',
    storageBucket: 'tinitzapp.appspot.com',
    iosClientId: '570463753229-61vvlpgak429f03qgojb38oquibvpp0d.apps.googleusercontent.com',
    iosBundleId: 'com.example.borneFlutter',
  );
}
