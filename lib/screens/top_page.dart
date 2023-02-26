import 'package:flutter/material.dart';

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;
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
                  height: 1
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
          ],
        ),
      ),
    );
  }

}
