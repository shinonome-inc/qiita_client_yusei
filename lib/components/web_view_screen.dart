import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key, required this.urlString}) : super(key: key);
  final String urlString;


  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;

  bool _isLoading = false;
  double? newHeight;

  Future<void> getNewHeight() async {
    const String javaScript = 'document.documentElement.scrollHeight;';
    final result = await _controller.runJavaScriptReturningResult(javaScript);
    final double getHeight = double.parse(result.toString());
    setState(() {
      newHeight = getHeight;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
              getNewHeight();
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.urlString));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          if (_isLoading) const LinearProgressIndicator(),
          Expanded(
          child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                     child: SizedBox(
                       height: newHeight ?? MediaQuery.of(context).size.height * 0.9,
                       child: WebViewWidget(
                           controller: _controller
                       ),
                     ),
               )
            ),
        ],
      );
  }
}
