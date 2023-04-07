import 'package:flutter/material.dart';
import 'package:flutter_app/screens/top_page.dart';
import 'package:provider/provider.dart';
import '../components/article_list_body.dart';
import '../components/custom_appbar.dart';
import '../components/no_internet_widget.dart';
import '../main.dart';
import '../components/custom_btn.dart';
import '../util/connection_status.dart';
import '../view_model/feed_view_model.dart';
import '../model/page_name.dart';

class MyPage extends StatefulWidget {
  const MyPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  FeedViewModel feedViewModel = FeedViewModel();


  @override
  Widget build(BuildContext context) {
    if (connectionStatus.interNetConnected) {
      // ネットワーク接続ありの場合のウィジェット
      return Scaffold(
          body: _buildLists());
    } else {
      // ネットワーク接続なしの場合のウィジェット
      return _buildNoInternetWidget();
    }
  }

  Widget _buildNoInternetWidget() {
    // ネットワークに接続されていない時はNoInterNetWidgetを表示する
    return NoInternetWidget(
      onPressed: () async {
        if (await ConnectionStatus.checkConnectivity()) {
          connectionStatus.interNetConnected = true;
          setState(() {});
        } else {
          connectionStatus.interNetConnected = false;
        }
      },
    );
  }


  Widget _buildLists() {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    // アクセストークンが取得できてないときは表示しない
    print(accessToken);
    if (!connectionStatus.interNetConnected || accessToken.isNotEmpty) {
      //ログイン時に表示するWidget or ネットワーク接続がない時は、NoInterNetWidgetがArticleDetailListBodyContent経由で表示される
      return Scaffold(
        //ネットワーク接続がある時のみ専用のAppBarを表示
        appBar: connectionStatus.interNetConnected
            ?
        const CustomAppBar(title: 'MyPage')
            : null,
        body: ChangeNotifierProvider(
            create: (_) => feedViewModel,
            child: const ArticleDetailListBodyContent(
                tag: null, pageName: PageName.myPage)),
      );
    } else {
      // ログインしていない場合に表示する
      return Scaffold(
        //ネットワーク接続がある時のみ専用のAppBarを表示
        appBar: connectionStatus.interNetConnected && accessToken.isEmpty
            ?
        const CustomAppBar(title: 'MyPage')
            : null,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: deviceHeight * 0.267,),
              const Text(
                'ログインが必要です',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                  letterSpacing: -0.24,
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'マイページの機能を利用するには\nログインを行っていただく必要があります。',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF828282),
                  height: 2,
                ),
              ),
              SizedBox(height: deviceHeight * 0.28),
              SizedBox(
                width: deviceWidth * 0.85,
                height: deviceHeight * 0.07,
                child: CustomButton(
                  onPressed: () async {
                    //ログイン画面（トップ画面）へ遷移
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TopPage()));
                  },
                  text: 'ログインする',
                  colors: 0xFF74C13A,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
