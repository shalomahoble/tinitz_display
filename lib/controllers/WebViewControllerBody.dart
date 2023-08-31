import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewControllerBody extends GetxController {
  final String url;
  final WebViewController controller = WebViewController();

  WebViewControllerBody(this.url);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) => print('On Progress'),
          onWebResourceError: (error) {
            print("Erreur lie au webview ${error.description.toString()}");
            print("Erreur lie au webview type ${error.errorType.toString()}");
            print("Erreur lie au webview code ${error.errorCode.toString()}");
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    controller.clearLocalStorage();
  }
}
