import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// TODO 4系で書き直してみる
class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key, required this.urlString}) : super(key: key);
  final String urlString;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController? _controller;

  bool _isLoading = false;
  double? _newHeight;

  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) WebView.platform = AndroidWebView();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }


  Future<double> _getNewHeight() async {
    const String javaScript = 'document.documentElement.scrollHeight;';
    final result = await _controller?.runJavascriptReturningResult(javaScript);
    final getHeight = double.tryParse(result.toString()) ?? 0;
    return getHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (_isLoading) const LinearProgressIndicator(),
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                height: _newHeight ?? MediaQuery.of(context).size.height * 0.9,
                child: WebView(
                  initialUrl: widget.urlString,
                  javascriptMode: JavascriptMode.unrestricted,
                  // jsを有効化
                  onWebViewCreated: (controller) async {
                    _controller = controller;
                  },
                  // controller紐付け
                  onPageStarted: (String url) {
                    // 読込開始時
                    setState(() {
                      _isLoading = true;
                    });
                  },
                  onPageFinished: (String url) async {
                    Future.delayed(const Duration(milliseconds: 2000));
                    print("2s経過！！");
                    final newHeight = await _getNewHeight();
                    setState(() {
                      _isLoading = false;
                      _newHeight = newHeight;
                      print("高さを更新！！");
                      print(_newHeight);
                    });
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
