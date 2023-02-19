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
    // ステータスバー（画面最上部の時計や電池残量が表示されている部分）の高さを取得
    // final double statusBarHeight = MediaQuery.of(context).padding.top;
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
        padding: const EdgeInsets.only(top: 220),
        alignment: Alignment.center,

        child: Column(
          children: [


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
                height: 1.43,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 320),
              child: SizedBox(
                width: 327,
                height: 50,

                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF468300),
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25), // <-- Radius
                    ),
                  ),
                  child: const Padding(
                    padding:  EdgeInsets.only(top: 18, left: 16, right: 16, bottom: 17),
                    child: Text('ログイン',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Color(0xfff9fcff),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.75,
                          height: 1.14,
                        )),
                  ),
                ),
              ),
            ),


            const Padding(
              padding: EdgeInsets.only(top: 34),
              child: SizedBox(
                width: 700,
                height: 20,
                child: Center(
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
            ),
          ],
        ),
      ),
    );
  }
}