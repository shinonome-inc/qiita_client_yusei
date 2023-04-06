import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/qiita_api_service.dart';
import 'package:flutter_app/screens/home_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../main.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({
    Key? key,
    required this.urlString,
  }) : super(key: key);
  final String urlString;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController? _controller;
  late final String state;

  bool _isLoading = false;
  double? _newHeight;

  @override
  void initState() {
    super.initState();
    state = _randomString(40);
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
    final initialUrl = widget.urlString == "isLogIn"
        ? QiitaApiService.displayAllowPage(state)
        : widget.urlString;

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
                  initialUrl: initialUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                  // jsを有効化
                  onWebViewCreated: (controller) async {
                    _controller = controller;
                  },
                  navigationDelegate: (NavigationRequest request) {
                    print(request);
                    if (request.url.startsWith(
                        "qiitaapp://dev.qiitayusei.qiitaapp/oauth/authorize/callback?code")) {
                      Uri uri = Uri.parse(request.url);
                      certification(uri);
                      return NavigationDecision.prevent;
                    }
                    return NavigationDecision.navigate;
                  },
                  // controller紐付け
                  onPageStarted: (String url) {
                    // 読込開始時
                    setState(() {
                      _isLoading = true;
                    });
                  },
                  onPageFinished: (String url) async {
                    final newHeight = await _getNewHeight();
                    setState(() {
                      _isLoading = false;
                      _newHeight = newHeight;
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

  String _randomString(int length) {
    const char = "abcdefghijklmnopqrstuvwxyz0123456789";
    final rand = Random.secure();
    final codeUnits = List.generate(length, (index) {
      final n = rand.nextInt(char.length);
      return char.codeUnitAt(n);
    });
    return String.fromCharCodes(codeUnits);
  }

  void certification(Uri uri) async {
    final token = await QiitaApiService.issueAccessToken(uri, state);
    saveAccessToken(token);

    if (accessToken != '' || accessToken != null) {
      print("遷移してok");
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    }
  }
}
