import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key, required this.urlString}) : super(key: key);
  final String urlString;


  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller = WebViewController();

  bool _isLoading = false;
  double? _newHeight;

  Future<double> _getNewHeight() async {
    const String javaScript = 'document.documentElement.scrollHeight;';
    final result = await _controller.runJavaScriptReturningResult(javaScript);
    final getHeight = double.tryParse(result.toString()) ?? 0;
    return getHeight;
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
          onPageFinished: (String url) async {
            final newHeight = await _getNewHeight();
            setState(() {
              _isLoading = false;
              _newHeight = newHeight;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.urlString));
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
                  child: WebViewWidget(
                      controller: _controller
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}
