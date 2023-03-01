import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/feed_page.dart';

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  bool isLoading = false;
  double imageOpacity = 0.2;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double deviceWidth;
    double deviceHeight = size.height - AppBar().preferredSize.height;
    double aspectRatio = size.aspectRatio;
    //アスペクト比でWidgetの幅と高さを補正

    if (aspectRatio >= 0.56 && aspectRatio < 0.65) {
      // 多くのスマホ（iPhone 5 ~ iPhone 8 Plus, iPhoneSE類）
      deviceWidth = size.width * 0.9;
      deviceHeight = size.height * 0.9;
    } else if (aspectRatio >= 0.65) {
      // 古い世代、タブレット（iPhone ~ iPhone 4s）
      deviceWidth = size.width * 0.65;
      deviceHeight = size.height * 0.8;
    } else {
      // 新世代 （iPhone X以降（iPhoneSEは除く））
      deviceWidth = size.width;
      deviceHeight = size.height;
    }

    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(imageOpacity),
              BlendMode.srcATop,
            ),
            fit: BoxFit.cover,
            image: const AssetImage('assets/images/背景画像.png'),
          )),
          // padding: const EdgeInsets.only(top: 220),
          alignment: Alignment.center,

          child: Column(
            children: [
              SizedBox(
                height: deviceHeight * 0.23,
              ),
              const Text(
                'Qiita Feed App',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 36.0,
                  color: Color(0xFFFFFFFF),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              const Text(
                '-PlayGround-',
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFFFFFF),
                    letterSpacing: 0.25,
                    height: 1),
              ),
              SizedBox(
                height: deviceHeight * 0.45,
              ),
              SizedBox(
                width: deviceWidth * 0.85,
                height: deviceHeight * 0.07,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF468300),
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25), // <-- Radius
                    ),
                  ),
                  child: const Text('ログイン',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xfff9fcff),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.75,
                        height: 1.14,
                      )),
                  onPressed: () {
                    // 3秒間ローディング
                    _loading();
                    // TODO ログイン処理を実装する
                    //FeedPageに遷移
                    _toFeed();
                  },
                ),
              ),
              SizedBox(
                width: deviceWidth,
                height: deviceHeight * 0.1,
                child: Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'ログインせずに利用する',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFFFFFF),
                        letterSpacing: 0.75,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
              if (isLoading)
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 3,
                    sigmaY: 3,
                  ),
                  blendMode: BlendMode.srcOver,
                  child: Container(),
                ),
            ],
          ),
        ),
        if (isLoading)
          const Center(
              child: CupertinoActivityIndicator(
                  radius: 20.0, color: CupertinoColors.white))
      ]),
    );
  }

  void _loading() {
    setState(() {
      isLoading = true;
      imageOpacity = 0.3;
      //3秒間のローディングアニメーションを追加
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          isLoading = false;
          imageOpacity = 0.2;
        });
      });
    });
  }

  void _toFeed() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const FeedPage()));
    });
  }
}
