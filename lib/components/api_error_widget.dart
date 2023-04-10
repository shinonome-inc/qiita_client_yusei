import 'package:flutter/material.dart';
import '../model/page_name.dart';
import '../screens/top_page.dart';
import 'custom_btn.dart';

Widget buildApiErrorWidget(context, PageName pageName) {
  // APIリクエストエラー時に表示するウィジェット

  final deviceHeight = MediaQuery.of(context).size.height;
  final deviceWidth = MediaQuery.of(context).size.width;

  double heightRatio = 0;
  switch (pageName) {
    case PageName.feed:
      heightRatio = 0.158;
      break;
    case PageName.tags:
      heightRatio = 0.209;
      break;
    case PageName.tagDetailList:
      break;
    case PageName.myPage:
      break;
  }

  return Scaffold(
    body: Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: deviceHeight * heightRatio),
            const SizedBox(
              height: 66.67,
              width: 66.67,
              child: Icon(Icons.error_outline_rounded, size: 48),
            ),
            const SizedBox(height: 16),
            const Text(
              'APIリクエストエラー',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
                letterSpacing: -0.24,
              ),
            ),
            const SizedBox(height: 17),
            const Text(
              'APIリクエスト回数が上限の６０回を超えました！\n上限を解放するにはログインが必要です。',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF828282),
                height: 2,
              ),
            ),
            SizedBox(height: deviceHeight * 0.23),
            SizedBox(
              width: deviceWidth * 0.85,
              height: deviceHeight * 0.07,
              child: CustomButton(
                onPressed: () async {
                  //ログイン画面（トップ画面）へ遷移
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const TopPage()));
                },
                text: 'ログインする',
                colors: 0xFF74C13A,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
