import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewLoad extends StatelessWidget {
  final String url;
  WebViewLoad(this.url);
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        title: Text('News Content'),
        centerTitle: true,
      ),
      url: url,
      withZoom: false,
      withLocalStorage: true,
    );
  }
}
