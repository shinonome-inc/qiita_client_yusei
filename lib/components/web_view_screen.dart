import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Androidに対応
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key, required this.urlString}) : super(key: key);
  final String urlString;


  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;


  bool _isLoading = false;
  double? _newHeight;


  @override
  void initState() {
    super.initState();

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);

    controller
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


    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;

  }

  Future<double> _getNewHeight() async {
    const String javaScript = 'document.documentElement.scrollHeight;';
    final result = await _controller.runJavaScriptReturningResult(javaScript);
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