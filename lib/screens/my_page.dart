import 'package:flutter/material.dart';
import 'package:flutter_app/screens/top_page.dart';
import 'package:flutter_app/view_model/my_page_view_model.dart';
import 'package:provider/provider.dart';
import '../components/article_list_body.dart';
import '../main.dart';
import '../components/custom_btn.dart';
import '../view_model/feed_view_model.dart';

class MyPage extends StatefulWidget {
  const MyPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  MyPageViewModel myPageViewModel = MyPageViewModel();
  FeedViewModel feedViewModel = FeedViewModel();

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    // TODO アクセストークンが取得できてないときは表示しない
    if (accessToken != '') {
      //ログイン時に表示するWidget
      return ChangeNotifierProvider(
          create: (_) => feedViewModel,
          child: const ArticleDetailListBodyContent(
              tag: null, pageName: 'my_page'));
    } else {
      // TODO ログインしていない場合に表示するように設定する
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 227),
          child: Column(
            children: [
              const Icon(Icons.login, size: 48),
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
              SizedBox(height: deviceHeight * 0.243),
              SizedBox(
                width: deviceWidth * 0.85,
                height: deviceHeight * 0.07,
                child: CustomButton(
                  btnLoading: true,
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
