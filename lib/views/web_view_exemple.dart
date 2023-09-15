// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExemple extends StatefulWidget {
  const WebViewExemple({
    Key? key,
    required this.pageUrl,
  }) : super(key: key);

  final String pageUrl;

  @override
  State<WebViewExemple> createState() => _WebViewExempleState();
}

class _WebViewExempleState extends State<WebViewExemple> {
  final WebViewController _controller = WebViewController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) => log("ON Progresse"),
        onWebResourceError: (error) {
          log("description :${error.description}");
          log("description :${error.isForMainFrame}");
          log("description :${error.errorCode}");
        },
      ))
      ..addJavaScriptChannel('Toaster',
          onMessageReceived: (JavaScriptMessage message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message.message)),
        );
      })
      ..loadRequest(Uri.parse(widget.pageUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: WebViewWidget(controller: _controller));
  }
}
