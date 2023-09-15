import 'dart:developer';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewControllerBody extends GetxController {
  final String url;
  final WebViewController controller = WebViewController();

  WebViewControllerBody(this.url);

  @override
  void onInit() {
    super.onInit();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) => log('On Progress'),
          onWebResourceError: (error) {
            log("Erreur lie au webview ${error.description.toString()}");
            log("Erreur lie au webview type ${error.errorType.toString()}");
            log("Erreur lie au webview code ${error.errorCode.toString()}");
          },
        ),
      )
      ..loadRequest(Uri.parse(
          "https://medium.com/flutter-community/flutter-bloc-for-beginners-839e22adb9f5"));
  }

  @override
  void onClose() {
    super.onClose();
    controller.clearLocalStorage();
  }
}
