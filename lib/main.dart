import 'package:flutter/material.dart';

void main() => runApp(const AppBarApp());

class AppBarApp extends StatelessWidget {
  const AppBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: QiitaFeedHome(),
    );
  }
}

class QiitaFeedHome extends StatelessWidget {
  const QiitaFeedHome({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double deviceWidth;
    double deviceHeight = size.height - AppBar().preferredSize.height;
    double aspectRatio = size.aspectRatio;
    //アスペクト比でWidgetの幅と高さを補正

    if (aspectRatio < 0.5) {
      deviceWidth = size.width;
      deviceHeight = size.height;
    } else if (aspectRatio < 0.65) {
      deviceWidth = size.width * 0.9;
      deviceHeight = size.height * 0.9;
    } else if (aspectRatio >= 0.65) {
      deviceWidth = size.width * 0.65;
      deviceHeight = size.height * 0.8;
    } else {
      deviceWidth = size.width;
      deviceHeight = size.height;
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.2),
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
            const Text(
              '-PlayGround-',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
                color: Color(0xFFFFFFFF),
                letterSpacing: 0.25,
                height: 2.5,
              ),
            ),
            SizedBox(
              height: deviceHeight * 0.45,
            ),
            SizedBox(
              width: deviceWidth * 0.85,
              height: deviceHeight * 0.07,
              child: ElevatedButton(
                onPressed: () {},
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
              ),
            ),
            SizedBox(
              width: deviceWidth,
              height: deviceHeight * 0.1,
              child: const Center(
                child: Text(
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
          ],
        ),
      ),
    );
  }
}