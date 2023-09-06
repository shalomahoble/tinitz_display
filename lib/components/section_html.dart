// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:borne_flutter/controllers/WebViewControllerBody.dart';

class SectionHtml extends StatelessWidget {
  final String pageUrl;
  const SectionHtml({
    Key? key,
    required this.pageUrl,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final WebViewControllerBody webViewControllerBody =
        Get.put(WebViewControllerBody(pageUrl));
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: WebViewWidget(
        controller: webViewControllerBody.controller,
      ),

      /* WebViewWidget(
        controller: webViewControllerBody.controller,
      ), */
    );
  }
}
